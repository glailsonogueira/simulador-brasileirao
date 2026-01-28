class Club < ApplicationRecord
  has_one_attached :badge
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_club_id', dependent: :destroy
  has_many :away_matches, class_name: 'Match', foreign_key: 'away_club_id', dependent: :destroy
  has_many :championship_clubs, dependent: :destroy
  has_many :championships, through: :championship_clubs
  
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, length: { maximum: 3 }
  
  scope :ordered, -> { order(:name) }
  scope :special, -> { where(special_club: true) }
  
  def matches
    Match.where('home_club_id = ? OR away_club_id = ?', id, id)
  end
  
  def badge_url
    if badge.attached?
      Rails.application.routes.url_helpers.rails_blob_path(badge, only_path: true)
    elsif badge_filename.present?
      "/badges/#{badge_filename}"
    else
      nil
    end
  end
end
