class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match
  
  validates :user_id, uniqueness: { scope: :match_id }
  validates :home_score, :away_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  before_save :set_predicted_at
  
  def locked?
    match.locked? || match.finished?
  end
  
  def can_edit?
    !locked?
  end
  
  private
  
  def set_predicted_at
    # SEMPRE atualiza o predicted_at ao salvar
    self.predicted_at = Time.current
  end
end
