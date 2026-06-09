class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @plant = Plant.find(params[:plant_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    if @message.save
      redirect_to plant_chat_path(@plant, @chat)
    else
      redirect_to plant_chat_path(@plant, @chat), alert: "Message could not be sent."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
