class ChatsController < ApplicationController
  def index
    @plant = Plant.find(params[:plant_id])
    @chats = @plant.chats
  end

  def show
    @plant = Plant.find(params[:plant_id])
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @new_message = Message.new
  end

  def create
    @plant = Plant.find(params[:plant_id])
    @chat = @plant.chats.create(title: "Chat about #{@plant.name}")
    redirect_to plant_chat_path(@plant, @chat)
  end
end
