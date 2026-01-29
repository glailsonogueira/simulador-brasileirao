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
