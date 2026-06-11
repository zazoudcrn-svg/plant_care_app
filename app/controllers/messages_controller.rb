class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @plant = Plant.find(params[:plant_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    if @message.save
      generate_ai_response
      generate_chat_title_if_first_message if @chat.messages.where(role: "user").count == 1
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to plant_chat_path(@plant, @chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_message_container",
            partial: "messages/form",
            locals: { plant: @plant, chat: @chat, message: @message }
          )
        end
        format.html { redirect_to plant_chat_path(@plant, @chat), alert: @message.errors[:content].first }
      end
    end
  end

  private

  def generate_chat_title_if_first_message
    prompt = "Create a very short, catchy title (maximum 3-4 words) in the user's language based on this message: '#{@message.content}'. Do not use quotes, punctuation, or extra explanations. Just give the title."

    ai_title_response = @ruby_llm_chat.ask(prompt)

    clean_title = ai_title_response.content.gsub(/['"„微]/, '').strip
    @chat.update(title: clean_title)
  end

  def generate_ai_response
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    response = @ruby_llm_chat.ask(@message.content)
    @assistant_message = @chat.messages.create!(role: "assistant", content: response.content)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
