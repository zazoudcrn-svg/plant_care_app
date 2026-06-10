class PlantsController < ApplicationController
  def index
    @plants = current_user.plants
  end

  def show
    @plant = current_user.plants.find(params[:id])
    @chats = @plant.chats.where(user: current_user)
  end
end
