class Club < ApplicationRecord
  has_one_attached :badge
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_club_id'
  has_many :away_matches, class_name: 'Match', foreign_key: 'away_club_id'
  has_many :championship_clubs, dependent: :destroy
  has_many :championships, through: :championship_clubs
  
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true,
                          uniqueness: true,
                          length: { is: 3 },
                          format: { with: /\A[A-Z]{3}\z/, message: "deve ter exatamente 3 letras maiúsculas" }
  
  before_validation :upcase_abbreviation
  
  scope :special, -> { where(special_club: true) }
  scope :ordered, -> { order(:name) }
  
  def is_remo?
    special_club?
  end
  
  def participating_in?(championship)
    championships.include?(championship)
  end
  
  private
  
  def upcase_abbreviation
    self.abbreviation = abbreviation&.upcase
  end
end
