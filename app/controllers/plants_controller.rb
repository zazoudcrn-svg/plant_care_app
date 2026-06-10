class PlantsController < ApplicationController
  def index
    @plants = current_user.plants
  end

  def show
    @plant = current_user.plants.find(params[:id])
    @chats = @plant.chats.where(user: current_user)
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

  private

  def plant_params
    params.require(:plant).permit(:name, :specie, :plant_location, :sunlight_exposure, :last_watered_on,
                                  :last_fertilized_on)
  end
end
