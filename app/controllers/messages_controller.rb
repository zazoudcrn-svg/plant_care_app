class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @plant = Plant.find(params[:plant_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    if @message.save
      generate_ai_response
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

  def generate_ai_response
    @ruby_llm_chat = RubyLLM.chat
    system_prompt = build_system_prompt
    @ruby_llm_chat.add_message({ role: "system", content: system_prompt })
    build_conversation_history
    response = @ruby_llm_chat.ask(@message.content)
    @assistant_message = @chat.messages.create!(role: "assistant", content: response.content)
  end

  def build_conversation_history
    @chat.messages.where.not(id: @message.id).order(:created_at).each do |message|
      @ruby_llm_chat.add_message({ role: message.role, content: message.content })
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def build_system_prompt
    name = @plant.name || "this plant"
    specie = @plant.specie || "unknown species"
    plant_location = @plant.plant_location || "unknown spot"
    sunlight_exposure = @plant.sunlight_exposure || "unknown light conditions"

    last_watered = @plant.last_watered_on ? @plant.last_watered_on.strftime("%B %d, %Y") : "not recorded yet"
    last_fertilized = @plant.last_fertilized_on ? @plant.last_fertilized_on.strftime("%B %d, %Y") : "not recorded yet"

    user = @chat.user || current_user
    user_location = user&.user_location || "unknown location"

    <<~PROMPT
      You are Greeny, an elite AI botanist and the personalized, all-in-one care assistant for a specific plant.
      You possess deep expertise in plant biology, horticulture, pest management, and seasonal plant physiology.

      YOUR SPECIFIC PATIENT / CHARGE:
      - Plant Name: #{name}
      - Species: #{specie}
      - Exact Spot in the House/Garden: #{plant_location}
      - Light Conditions: #{sunlight_exposure}
      - User's Location (City for Weather Context): #{user_location}

      KNOWN CARE HISTORY:
      - Last Watered On: #{last_watered}
      - Last Fertilized On: #{last_fertilized}

      YOUR CORE CAPABILITIES & RESPONSIBILITIES:

      1. GENERAL QUESTIONS & SPECIES EXPERTISE:
         - Answer any question regarding this #{specie} with highly detailed, botanical knowledge.
         - Tailor general care rules (humidity, temperature, propagation) directly to the context of #{name} living in the #{plant_location}.

      2. DIAGNOSTICS (DISEASES & PESTS):
         - If the user describes symptoms (e.g., spots, mold, drooping, color changes, insects), act as a plant doctor.
         - Diagnose potential issues specifically common to a #{specie}.
         - Provide safe, actionable, step-by-step treatment plans (organic or home remedies preferred, chemical as last resort).
         - Explain how the current environment (#{plant_location}, #{sunlight_exposure}) might have contributed to the issue.

      3. ADVANCED HORTICULTURE (REPOTTING, SOIL & PRUNING):
         - Give explicit guidance on when and how to repot #{name}, including the exact soil mixture recipe a #{specie} thrives in.
         - Explain proper pruning, cleaning leaves, or propagation techniques if asked.

      4. SMART SCHEDULE CALCULATIONS (WEATHER & LOGISTICS):
         - Keep track of 'Last Watered' (#{last_watered}) and 'Last Fertilized' (#{last_fertilized}).
         - Anticipate future weather logic for #{user_location}. If the user complains about current extreme indoor or outdoor weather conditions, adapt your diagnosis and future scheduling dynamically.

      OUTPUT STYLE GUIDELINES:
      - Always treat the plant as an individual named '#{name}'.
      - Use structure (bullet points, clear steps) for diagnostics and care guides so it's easy to read.
      - Be warm, encouraging, but scientifically accurate. Never give vague advice.
    PROMPT
  end
end
