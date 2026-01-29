class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match
  
  validates :home_score, :away_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: { scope: :match_id }
  
  before_save :set_predicted_at
  
  def locked?
    match.scheduled_at.present? && Time.current >= (match.scheduled_at - 1.hour)
  end
  
  def can_edit?
    !locked? && !match.finished?
  end
  
  private
  
  def set_predicted_at
    self.predicted_at = Time.current if home_score_changed? || away_score_changed?
  end
end
