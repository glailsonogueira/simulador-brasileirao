class Round < ApplicationRecord
  belongs_to :championship
  has_many :matches, dependent: :destroy
  has_many :round_scores, dependent: :destroy
  
  validates :number, presence: true, uniqueness: { scope: :championship_id }
  
  # Status da rodada para um usuário específico
  def status_for_user(user)
    return :bloqueada if blocked?
    return :encerrada if finished?
    return :aguardando_encerramento if awaiting_closure?
    return :em_andamento if in_progress_for_user?(user)
    return :aberta_previsoes if open_for_predictions?
    :aberta_previsoes
  end
  
  # Bloqueada se:
  # - Rodada anterior NÃO finalizada E
  # - Falta mais de 3 dias para o primeiro jogo
  def blocked?
    return false if number == 1 # Primeira rodada nunca bloqueia
    return false if matches.empty?
    
    first_match_time = matches.minimum(:scheduled_at)
    return false if first_match_time.nil?
    
    # Libera se falta 3 dias ou menos para o primeiro jogo
    days_until_first_match = (first_match_time - Time.current) / 1.day
    return false if days_until_first_match <= 3
    
    # Libera se a rodada anterior foi finalizada
    previous_round = championship.rounds.find_by(number: number - 1)
    return false if previous_round&.finished?
    
    # Caso contrário, bloqueia
    true
  end
  
  # Encerrada (todos jogos finalizados)
  def finished?
    return false if matches.empty?
    matches.all?(&:finished?)
  end
  
  # Aguardando Encerramento (todos jogos iniciaram mas não finalizaram)
  def awaiting_closure?
    return false if matches.empty?
    
    all_started = matches.all? { |m| m.scheduled_at.present? && Time.current >= m.scheduled_at }
    not_all_finished = matches.any? { |m| !m.finished? }
    
    all_started && not_all_finished
  end
  
  # Aberta para Previsões (pelo menos 1 jogo ainda aceita previsão)
  def open_for_predictions?
    return false if matches.empty?
    matches.any? { |m| m.can_predict? }
  end
  
  # Em Andamento (para um usuário específico)
  def in_progress_for_user?(user)
    return false if matches.empty?
    
    # Pelo menos um jogo já começou
    has_started = matches.any? { |m| m.scheduled_at.present? && Time.current >= m.scheduled_at }
    return false unless has_started
    
    # Ainda tem jogos abertos para previsão
    has_open_matches = matches.any? { |m| m.can_predict? }
    return false unless has_open_matches
    
    # Todas as previsões do usuário foram feitas
    matches_with_predictions = user.predictions.where(match: matches).count
    all_predictions_made = matches_with_predictions == matches.count
    
    all_predictions_made
  end
  
  # Pelo menos um jogo já começou?
  def any_match_started?
    matches.any? { |m| m.scheduled_at.present? && Time.current >= m.scheduled_at }
  end
  
  alias_method :all_matches_finished?, :finished?
  
  # Helpers para exibição
  def status_label_for_user(user)
    case status_for_user(user)
    when :aberta_previsoes then 'Aberta para Previsoes'
    when :bloqueada then 'Bloqueada'
    when :em_andamento then 'Em Andamento'
    when :aguardando_encerramento then 'Aguardando Encerramento'
    when :encerrada then 'Encerrada'
    else 'Aberta para Previsoes'
    end
  end
  
  def status_color_for_user(user)
    case status_for_user(user)
    when :aberta_previsoes
      any_match_started? ? '#28a745' : '#ffc107'  # Verde se iniciou, Amarelo se não
    when :bloqueada then '#dc3545'                # Vermelho
    when :em_andamento then '#28a745'             # Verde
    when :aguardando_encerramento then '#007bff'  # Azul
    when :encerrada then '#666'                   # Cinza
    else '#ffc107'
    end
  end
end
