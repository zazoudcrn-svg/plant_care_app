class ChatsController < ApplicationController
  before_action :set_plant, only: %i[create show]

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @new_message = Message.new
  end

  def create
    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user
    @chat.plant = @plant
    if @chat.save
      redirect_to plant_chat_path(@plant, @chat)
    else
      redirect_to plant_path(@plant), alert: "Could not start chat."
    end
  end

  private

  def set_plant
    @plant = Plant.find(params[:plant_id])
  end
end
