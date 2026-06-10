class Message < ApplicationRecord
  belongs_to :chat

  MAX_USER_MESSAGES = 5

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "Chat limit reached (5 messages). Start a new chat to continue.")
  end
end
