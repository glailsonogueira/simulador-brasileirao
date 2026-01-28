class RoundScore < ApplicationRecord
  belongs_to :user
  belongs_to :round
  
  validates :user_id, uniqueness: { scope: :round_id }
  
  scope :ordered, -> { order(position: :asc) }
  scope :winners, -> { where(winner: true) }
  
  def championship
    round.championship
  end
end
