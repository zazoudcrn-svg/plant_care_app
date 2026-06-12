class Plant < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_one_attached :photo

  def days_since_last_watered
    return nil if last_watered_on.blank?

    (Date.today - last_watered_on).to_i
  end
end
