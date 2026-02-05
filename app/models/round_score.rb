class RoundScore < ApplicationRecord
  belongs_to :user
  belongs_to :round
  
  validates :user_id, uniqueness: { scope: :round_id }
  
  scope :ordered, -> { order(position: :asc) }
  scope :winners, -> { where(winner: true) }
  
  def self.calculate_for_round(round)
    # Só calcular se pelo menos 1 jogo foi finalizado
    return unless round.matches.where(finished: true).any?
    
    # Limpar scores anteriores
    round.round_scores.destroy_all
    
    # Calcular para cada usuário que tem previsões
    User.where(active: true).find_each do |user|
      score = RoundScore.new(user: user, round: round)
      
      # APENAS jogos finalizados
      round.matches.where(finished: true).each do |match|
        prediction = user.predictions.find_by(match: match)
        next unless prediction
        
        points = 0
        is_exact = false
        is_correct = false
        is_favorite_exact = false
        is_favorite_correct = false
        
        # Verificar acerto
        if prediction.home_score == match.home_score && prediction.away_score == match.away_score
          # Placar exato
          is_exact = true
          points = match.involves_favorite? ? 20 : 10
          is_favorite_exact = true if match.involves_favorite?
        elsif (prediction.home_score > prediction.away_score && match.home_score > match.away_score) ||
              (prediction.home_score < prediction.away_score && match.home_score < match.away_score) ||
              (prediction.home_score == prediction.away_score && match.home_score == match.away_score)
          # Resultado correto
          is_correct = true
          points = match.involves_favorite? ? 10 : 5
          is_favorite_correct = true if match.involves_favorite?
        end
        
        # Atualizar score
        score.total_points += points
        score.exact_scores += 1 if is_exact && !match.involves_favorite?
        score.correct_results += 1 if is_correct && !match.involves_favorite?
        score.special_exact_scores += 1 if is_favorite_exact
        score.special_correct_results += 1 if is_favorite_correct
      end
      
      score.save!
    end
    
    # Calcular posições com critérios de desempate
    calculate_positions(round)
  end
  
  def self.calculate_positions(round)
    scores = round.round_scores.includes(:user)
    
    # Ordenar por:
    # 1. Total de pontos (desc)
    # 2. Acerto exato no jogo do clube favorito (desc)
    # 3. Placares exatos totais (desc)
    # 4. Previsao mais cedo (asc)
    sorted_scores = scores.sort_by do |score|
      earliest_prediction = score.user.predictions
                                 .joins(:match)
                                 .where(matches: { round_id: round.id })
                                 .where.not(predicted_at: nil)
                                 .minimum(:predicted_at) || Time.current
      
      [
        -score.total_points,
        -score.special_exact_scores,
        -(score.exact_scores + score.special_exact_scores),
        earliest_prediction
      ]
    end
    
    # Verificar se TODOS os jogos da rodada foram finalizados
    all_matches_finished = round.matches.all?(&:finished?)
    
    # Atualizar posições e marcar vencedor APENAS se a rodada estiver completa
    sorted_scores.each_with_index do |score, index|
      is_winner = all_matches_finished && (index == 0) # Primeiro colocado é o vencedor APENAS se rodada completa
      score.update_columns(position: index + 1, winner: is_winner)
    end
  end
end
