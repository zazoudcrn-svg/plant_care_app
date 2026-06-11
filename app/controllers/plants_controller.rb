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
    if @plant.update(plant_params)
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

  private

  def fetch_weather(city)
    return nil if city.blank?

    url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(city)}&appid=#{ENV['OPENWEATHERMAP_API_KEY']}&units=metric"
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  rescue
    nil
  end

  def fetch_forecast(city)
    return nil if city.blank?

    url = "https://api.openweathermap.org/data/2.5/forecast?q=#{URI.encode_www_form_component(city)}&appid=#{ENV['OPENWEATHERMAP_API_KEY']}&units=metric"
    response = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(response)

    data["list"].group_by { |entry| entry["dt_txt"].split(" ").first }
                .reject { |date, _| date == Date.today.to_s }
                .map { |date, entries| entries.find { |e| e["dt_txt"].include?("12:00:00") } || entries.first }
                .first(5)
  rescue
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
      :last_fertilized_on
    )
  end
end
