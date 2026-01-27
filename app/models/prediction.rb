class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match
  
  validates :home_score, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :away_score, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: { scope: :match_id, message: "já fez palpite para este jogo" }
  
  validate :must_be_before_deadline
  validate :cannot_predict_remo_defeat
  
  def predicted_result
    return :home_win if home_score > away_score
    return :away_win if away_score > home_score
    :draw
  end
  
  def exact_score_match?(match)
    home_score == match.home_result && away_score == match.away_result
  end
  
  def result_match?(match)
    predicted_result == match.match_result
  end
  
  def calculate_points(match)
    return 0 unless match.result_set?
    
    is_special = match.involves_special_club?
    
    if exact_score_match?(match)
      is_special ? 20 : 10
    elsif result_match?(match)
      is_special ? 10 : 5
    else
      0
    end
  end
  
  private
  
  def must_be_before_deadline
    return unless match&.round
    
    if match.round.deadline_passed?
      errors.add(:base, "Prazo expirado! Não é possível fazer palpites após 1 hora antes do primeiro jogo da rodada")
      return
    end
    
    if persisted? && changed? && match.round.deadline_passed?
      errors.add(:base, "Não é possível editar após o prazo limite")
    end
  end
  
  def cannot_predict_remo_defeat
    return unless match
    
    if match.home_club.is_remo? && predicted_result == :away_win
      errors.add(:base, "🚫 Não é permitido prever derrota do Remo!")
    end
    
    if match.away_club.is_remo? && predicted_result == :home_win
      errors.add(:base, "🚫 Não é permitido prever derrota do Remo!")
    end
  end
end
