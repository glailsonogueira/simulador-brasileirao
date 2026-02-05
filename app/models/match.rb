class Match < ApplicationRecord
  belongs_to :round
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'
  belongs_to :stadium, optional: true
  has_many :predictions, dependent: :destroy
  
  validates :home_club_id, uniqueness: { scope: [:round_id, :away_club_id] }
  validate :different_clubs
  
  before_validation :set_stadium_from_home_club, on: :create
  
  scope :finished_matches, -> { where(finished: true) }
  scope :unfinished_matches, -> { where(finished: false) }
  
  def involves_favorite?
    championship = round.championship
    return false unless championship.favorite_club_id.present?
    home_club_id == championship.favorite_club_id || away_club_id == championship.favorite_club_id
  end
  
  def can_predict?
    scheduled_at.present? && Time.current < (scheduled_at - 1.hour) && !finished?
  end
  
  def locked?
    scheduled_at.present? && Time.current >= (scheduled_at - 1.hour)
  end

  def result_set?
    home_score.present? && away_score.present?
  end

  # Status do jogo (considera o status da rodada)
  def status
    return :finalizado if finished?
    return :aguardando_encerramento if awaiting_closure?
    return :em_andamento if in_progress?
    
    # Verificar status da rodada
    round_status = round.status_for_user(User.first) # Pegar qualquer usuário
    
    # Jogo só fica "Aberto" se a rodada for Verde ou Amarela E não estiver bloqueado
    if (round_status == :aberta_previsoes_verde || round_status == :aberta_previsoes_amarela)
      return :bloqueado if locked?
      return :aberto
    end
    
    # Em todos os outros status da rodada, jogo fica bloqueado
    :bloqueado
  end
  
  # Em andamento (jogo começou mas não finalizou)
  def in_progress?
    return false if finished?
    scheduled_at.present? && Time.current >= scheduled_at && Time.current < (scheduled_at + 3.hours)
  end
  
  # Aguardando encerramento (passou 3h do início)
  def awaiting_closure?
    return false if finished?
    scheduled_at.present? && Time.current >= (scheduled_at + 3.hours)
  end
  
  # Labels e cores
  def status_label
    case status
    when :finalizado then 'Finalizado'
    when :aguardando_encerramento then 'Aguardando Encerramento'
    when :em_andamento then 'Em Andamento'
    when :bloqueado then 'Bloqueado'
    when :aberto then 'Aberto'
    else 'Aberto'
    end
  end
  
  def status_color
    case status
    when :finalizado then '#28a745'           # Verde
    when :aguardando_encerramento then '#007bff'  # Azul
    when :em_andamento then '#28a745'         # Verde
    when :bloqueado then '#dc3545'            # Vermelho
    when :aberto then '#ffc107'               # Amarelo
    else '#ffc107'
    end
  end
  
  private
  
  def different_clubs
    if home_club_id == away_club_id
      errors.add(:base, "Mandante e visitante devem ser clubes diferentes")
    end
  end
  
  def set_stadium_from_home_club
    self.stadium_id ||= home_club.primary_stadium_id if home_club&.primary_stadium_id.present?
  end
end
