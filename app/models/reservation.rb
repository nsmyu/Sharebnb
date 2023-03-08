class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def total_price
   (check_out_on - check_in_on) * num_of_people * room.price
  end

  validates :num_of_people, :check_in_on, :check_out_on, presence: true
  validate :check_out_on_must_be_after_check_in_on

  def check_out_on_must_be_after_check_in_on
    if check_in_on == nil || check_out_on == nil
      return
    elsif check_out_on <= check_in_on
      errors.add(:check_out_on, "はチェックイン日の翌日以降で選択してください")
    end
  end
end
