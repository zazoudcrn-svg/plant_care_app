class PlantsController < ApplicationController
  def index
    @plants = current_user.plants
  end

  def show
    @plant = current_user.plants.find(params[:id])
    @chats = @plant.chats.where(user: current_user)
    @weather = fetch_weather(current_user.user_location)
    @forecast = fetch_forecast(current_user.user_location)
  end

  def new
    @plant = Plant.new
  end

  def create
    @plant = Plant.new(plant_params)
    @plant.user = current_user

    if @plant.save
      redirect_to plants_path, notice: 'Plant added to your Dashboard! 🌱'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @plant = current_user.plants.find(params[:id])
  end

  def update
    @plant = current_user.plants.find(params[:id])

    # Add new photos without removing old ones
    @plant.photos.attach(plant_params[:photos]) if plant_params[:photos]

    if @plant.update(plant_params.except(:photos))
      redirect_to @plant, notice: "Plant updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plant = current_user.plants.find(params[:id])
    @plant.destroy
    redirect_to plants_path, notice: "Plant deleted"
  end

  def search
    query = params[:query]

    if query.present? && query.length >= 3
      # Nutzt euren Perenual API-Key aus der .env Datei
      url = "https://perenual.com/api/species-list?key=#{ENV.fetch('PERENUAL_API_KEY',
                                                                   nil)}&q=#{URI.encode_www_form_component(query)}"

      response = Net::HTTP.get(URI.parse(url))
      data = JSON.parse(response)

      if data["data"].present?
        results = data["data"].map do |plant|
          {
            common_name: plant["common_name"]&.capitalize || "Unknown Plant",
            scientific_name: plant["scientific_name"]&.join(", ") || ""
          }
        end
      else
        results = []
      end
    else
      results = []
    end

    render json: results
  rescue StandardError => e
    logger.error "Perenual API Error: #{e.message}"
    render json: []
  end

  private

  def fetch_weather(city)
    return nil if city.blank?

    url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(city)}&appid=#{ENV.fetch(
      'OPENWEATHERMAP_API_KEY', nil
    )}&units=metric"
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  rescue StandardError
    nil
  end

  def fetch_forecast(city)
    return nil if city.blank?

    url = "https://api.openweathermap.org/data/2.5/forecast?q=#{URI.encode_www_form_component(city)}&appid=#{ENV.fetch(
      'OPENWEATHERMAP_API_KEY', nil
    )}&units=metric"
    response = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(response)

    data["list"].group_by { |entry| entry["dt_txt"].split(" ").first }
                .reject { |date, _| date == Date.today.to_s }
                .map { |date, entries| entries.find { |e| e["dt_txt"].include?("12:00:00") } || entries.first }
                .first(5)
  rescue StandardError
    nil
  end

  def plant_params
    params.require(:plant).permit(
      :name,
      :specie,
      :plant_location,
      :sunlight_exposure,
      :date_added,
      :last_watered_on,
      :last_fertilized_on,
      photos: []
    )
  end
end
