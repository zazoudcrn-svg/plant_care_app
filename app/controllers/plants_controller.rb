class PlantsController < ApplicationController
  def index
    @plants = current_user.plants
  end

  def show
    @plant = current_user.plants.find(params[:id])
    @chats = @plant.chats.where(user: current_user)
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

  def plant_params
    params.require(:plant).permit(
      :name,
      :specie,
      :plant_location,
      :sunlight_exposure,
      :date_added,
      :last_watered_on,
      :last_fertilized_on,
      :system_prompt
    )
  end
end
