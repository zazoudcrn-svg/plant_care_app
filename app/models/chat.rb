class Chat < ApplicationRecord
  belongs_to :plant
  has_many :messages, dependent: :destroy
end
