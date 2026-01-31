class OverallStanding < ApplicationRecord
  belongs_to :championship
  belongs_to :user
  
  validates :user_id, uniqueness: { scope: :championship_id }
  
  scope :ordered, -> { order(position: :asc) }
  scope :top_10, -> { ordered.limit(10) }
  
  def self.calculate_for_championship(championship)
    # Limpar standings anteriores deste campeonato
    championship.overall_standings.destroy_all
    
    # Calcular para cada usuário que tem previsões neste campeonato
    User.where(active: true).find_each do |user|
      update_user_overall_standing(user, championship)
    end
    
    # Calcular posições com critérios de desempate
    rank_overall_standings(championship)
  end
  
  def self.update_user_overall_standing(user, championship)
    round_scores = RoundScore.joins(:round)
                             .where(rounds: { championship_id: championship.id })
                             .where(user: user)
    
    # Se não tem nenhum score, não criar standing
    return if round_scores.empty?
    
    standing = OverallStanding.find_or_initialize_by(user: user, championship: championship)
    standing.total_points = round_scores.sum(:total_points)
    standing.rounds_won = round_scores.where(winner: true).count
    standing.exact_scores = round_scores.sum(:exact_scores)
    standing.correct_results = round_scores.sum(:correct_results)
    standing.save!
  end
  
  def self.rank_overall_standings(championship)
    # Ordenar por:
    # 1. Total de pontos (desc)
    # 2. Rodadas vencidas (desc)
    # 3. Total de placares exatos (desc)
    # 4. Previsão mais cedo no campeonato (asc)
    
    standings = championship.overall_standings.includes(:user)
    
    sorted_standings = standings.sort_by do |standing|
      earliest_prediction = standing.user.predictions
                                   .joins(:match)
                                   .joins('INNER JOIN rounds ON matches.round_id = rounds.id')
                                   .where('rounds.championship_id = ?', championship.id)
                                   .where.not(predicted_at: nil)
                                   .minimum(:predicted_at) || Time.current
      
      [
        -standing.total_points,
        -standing.rounds_won,
        -standing.exact_scores,
        earliest_prediction
      ]
    end
    
    # Atualizar posições
    sorted_standings.each_with_index do |standing, index|
      standing.update_column(:position, index + 1)
    end
  end
end
