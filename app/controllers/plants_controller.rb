class PlantsController < ApplicationController
  def index
    @plants = current_user.plants
  end

  def show
    @plant = current_user.plants.find(params[:id])
  end

  def new
    @plant = Plant.new
  end

  def create
    @plant = Plant.new(plant_params)
end
