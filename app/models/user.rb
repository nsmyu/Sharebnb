class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable
  def update_without_current_password(params)
    update(params)
  end

  has_one_attached :avatar

  validates :name,         presence: true
  validates :email,        presence: true, uniqueness: true
  validates :password,     presence: true, length: {minimum: 6}, on: :create
  validates :introduction, length: {maximum: 250}
end
