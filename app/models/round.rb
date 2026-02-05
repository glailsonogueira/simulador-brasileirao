class Round < ApplicationRecord
  belongs_to :championship
  has_many :matches, dependent: :destroy
  has_many :round_scores, dependent: :destroy
  
  validates :number, presence: true, uniqueness: { scope: :championship_id }
  
  # Status da rodada para um usuário específico
  def status_for_user(user)
    return :encerrada if finished?
    return :aguardando_encerramento if awaiting_closure?
    return :previsoes_encerradas if predictions_closed?
    return :em_andamento if in_progress?
    return :aberta_previsoes_verde if open_predictions_green?
    return :aberta_previsoes_amarela if open_predictions_yellow?
    return :bloqueada if blocked?
    :bloqueada
  end
  
  # Bloqueada se:
  # - Nenhum jogo cadastrado OU
  # - Falta mais de 5 dias para o primeiro jogo
  # NÃO bloqueia por rodada anterior incompleta se os jogos já começaram
  def blocked?
    # Bloqueia se não tem jogos cadastrados
    return true if matches.empty?
    
    first_match_time = matches.minimum(:scheduled_at)
    return true if first_match_time.nil?
    
    # Se o primeiro jogo já começou, NÃO bloqueia mais
    return false if Time.current >= first_match_time
    
    # Calcula dias até o primeiro jogo
    days_until_first_match = (first_match_time - Time.current) / 1.day
    
    # Bloqueia se falta mais de 5 dias
    return true if days_until_first_match > 5
    
    # Para rodadas após a 1ª, bloqueia se rodada anterior não finalizou
    # E ainda falta tempo para começar
    if number > 1
      previous_round = championship.rounds.find_by(number: number - 1)
      return true unless previous_round&.finished?
    end
    
    false
  end
  
  # Encerrada (todos jogos finalizados)
  def finished?
    return false if matches.empty?
    matches.all?(&:finished?)
  end

  # Aguardando Encerramento
  # - Último jogo passou 3h do horário de início E
  # - Pelo menos um jogo ainda não foi finalizado
  def awaiting_closure?
    return false if matches.empty?
    return false if finished? # Se todos finalizaram, não está aguardando
    
    last_match_time = matches.maximum(:scheduled_at)
    return false if last_match_time.nil?
    
    # Verifica se já passaram 3h do último jogo
    hours_since_last_match = (Time.current - last_match_time) / 1.hour
    
    # Aguardando se passou 3h E tem jogos não finalizados
    hours_since_last_match >= 3 && matches.any? { |m| !m.finished? }
  end
  
  # Aberta para Previsões (VERDE)
  # - Rodada anterior finalizada OU
  # - Falta entre 5 e 2 dias para o primeiro jogo
  def open_predictions_green?
    return false if matches.empty?
    return false if finished?
    return false if awaiting_closure?
    return false if in_progress?
    return false if predictions_closed?
    return false if open_predictions_yellow?
    
    first_match_time = matches.minimum(:scheduled_at)
    return false if first_match_time.nil?
    
    days_until_first_match = (first_match_time - Time.current) / 1.day
    
    # Entre 5 e 2 dias
    return true if days_until_first_match >= 2 && days_until_first_match <= 5
    
    # Ou rodada anterior finalizada (e não está em outras condições)
    if number > 1
      previous_round = championship.rounds.find_by(number: number - 1)
      return true if previous_round&.finished? && days_until_first_match >= 0 && days_until_first_match < 2
    end
    
    # Rodada 1 com 2 dias ou menos (mas mais de 1h)
    return true if number == 1 && days_until_first_match >= 0 && days_until_first_match < 2
    
    false
  end
  
  # Aberta para Previsões (AMARELA)
  # - Falta menos de 2 dias até 1h antes do primeiro jogo
  def open_predictions_yellow?
    return false if matches.empty?
    return false if finished?
    return false if awaiting_closure?
    return false if in_progress?
    return false if predictions_closed?
    
    first_match_time = matches.minimum(:scheduled_at)
    return false if first_match_time.nil?
    
    hours_until_first_match = (first_match_time - Time.current) / 1.hour
    
    # Menos de 2 dias (48h) e mais de 1h
    hours_until_first_match < 48 && hours_until_first_match >= 1
  end
  
  # Previsões Encerradas
  # - Falta menos de 1h para o primeiro jogo (mas ainda não começou)
  def predictions_closed?
    return false if matches.empty?
    return false if finished?
    return false if awaiting_closure?
    
    first_match_time = matches.minimum(:scheduled_at)
    return false if first_match_time.nil?
    
    hours_until_first_match = (first_match_time - Time.current) / 1.hour
    
    # Menos de 1h para começar E ainda não começou
    hours_until_first_match < 1 && hours_until_first_match >= 0
  end
  
  # Em Andamento (VERDE)
  # - Primeiro jogo já iniciou (mas nem todos finalizaram)
  def in_progress?
    return false if matches.empty?
    return false if finished?
    return false if awaiting_closure?
    
    first_match_time = matches.minimum(:scheduled_at)
    return false if first_match_time.nil?
    
    # Primeiro jogo já começou
    Time.current >= first_match_time
  end
  
  # Pode acessar a tela de previsões?
  def can_access_predictions?
    status = status_for_user(User.first) # Pegar qualquer usuário para determinar status
    status != :bloqueada
  end
  
  # Pode inserir/editar previsões?
  def can_edit_predictions?
    open_predictions_green? || open_predictions_yellow?
  end
  
  # Pelo menos um jogo já começou?
  def any_match_started?
    matches.any? { |m| m.scheduled_at.present? && Time.current >= m.scheduled_at }
  end
  
  alias_method :all_matches_finished?, :finished?
  
  # Helpers para exibição
  def status_label_for_user(user)
    case status_for_user(user)
    when :aberta_previsoes_verde then 'Aberta para Previsões'
    when :aberta_previsoes_amarela then 'Aberta para Previsões'
    when :bloqueada then 'Bloqueada'
    when :previsoes_encerradas then 'Previsões Encerradas'
    when :em_andamento then 'Em Andamento'
    when :aguardando_encerramento then 'Aguardando Encerramento'
    when :encerrada then 'Encerrada'
    else 'Bloqueada'
    end
  end
  
  def status_color_for_user(user)
    case status_for_user(user)
    when :aberta_previsoes_verde then '#28a745'      # Verde
    when :aberta_previsoes_amarela then '#ffc107'    # Amarelo
    when :bloqueada then '#dc3545'                   # Vermelho
    when :previsoes_encerradas then '#6c757d'        # Cinza
    when :em_andamento then '#28a745'                # Verde
    when :aguardando_encerramento then '#007bff'     # Azul
    when :encerrada then '#666'                      # Cinza escuro
    else '#dc3545'                                   # Vermelho (padrão bloqueada)
    end
  end
end