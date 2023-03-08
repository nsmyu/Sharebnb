class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy

  has_one_attached :image

  validates :room_name, :description, :price, :address, presence: true
end
