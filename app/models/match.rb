class Match < ApplicationRecord
  belongs_to :round
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'
  has_many :predictions, dependent: :destroy
  
  validates :scheduled_at, presence: true
  validate :clubs_must_be_different
  validate :clubs_must_be_in_championship
  
  scope :finished, -> { where(finished: true) }
  scope :pending, -> { where(finished: false) }
  scope :ordered_by_date, -> { order(:scheduled_at) }
  
  def result_set?
    home_score.present? && away_score.present?
  end
  
  def involves_special_club?
    home_club.special_club? || away_club.special_club?
  end
  
  def involves_remo?
    involves_special_club?
  end
  
  def remo_is_home?
    home_club.special_club?
  end
  
  def remo_is_away?
    away_club.special_club?
  end
  
  def match_result
    return nil unless result_set?
    return :home_win if home_score > away_score
    return :away_win if away_score > home_score
    :draw
  end
  
  def open_for_predictions?
    scheduled_at - 1.hour > Time.current
  end
  
  def formatted_datetime
    scheduled_at.strftime("%d/%m/%Y às %H:%M")
  end
  
  def short_datetime
    scheduled_at.strftime("%d/%m %H:%M")
  end
  
  private
  
  def clubs_must_be_different
    if home_club_id == away_club_id
      errors.add(:base, "Um clube não pode jogar contra si mesmo")
    end
  end
  
  def clubs_must_be_in_championship
    return unless round&.championship
    championship_club_ids = round.championship.club_ids
    
    unless championship_club_ids.include?(home_club_id)
      errors.add(:home_club, "não está participando deste campeonato")
    end
    
    unless championship_club_ids.include?(away_club_id)
      errors.add(:away_club, "não está participando deste campeonato")
    end
  end
end
