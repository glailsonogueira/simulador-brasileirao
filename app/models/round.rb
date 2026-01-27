class Round < ApplicationRecord
  belongs_to :championship
  has_many :matches, dependent: :destroy
  has_many :round_scores, dependent: :destroy
  
  validates :number, presence: true, uniqueness: { scope: :championship_id }
  
  scope :ordered, -> { order(:number) }
  
  def all_matches_finished?
    matches.any? && matches.all?(&:finished?)
  end
  
  def previous_round
    championship.rounds.where('number < ?', number).order(number: :desc).first
  end
  
  def is_unlocked?
    return true if number == 1 # Primeira rodada sempre liberada
    previous_round&.all_matches_finished? || false
  end
  
  def deadline_passed?
    return false if matches.empty?
    first_match = matches.order(:scheduled_at).first
    first_match.scheduled_at - 1.hour < Time.current
  end
  
  def open_for_predictions?
    !deadline_passed?
  end
  
  def status
    return :locked unless is_unlocked?
    return :finished if all_matches_finished?
    return :closed if deadline_passed?
    :open
  end
end
