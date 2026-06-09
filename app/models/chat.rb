class Chat < ApplicationRecord
  belongs_to :plant
  belongs_to :user
  has_many :messages, dependent: :destroy
end
