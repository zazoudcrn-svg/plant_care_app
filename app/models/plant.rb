class Plant < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_many_attached :photos
end
