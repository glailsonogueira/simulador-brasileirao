class Championship < ApplicationRecord
  belongs_to :favorite_club, class_name: 'Club', optional: true
  has_many :championship_clubs, dependent: :destroy
  has_many :clubs, through: :championship_clubs
  has_many :rounds, dependent: :destroy
  has_many :overall_standings, dependent: :destroy
  
  validates :year, presence: true, uniqueness: true
  validates :name, presence: true
  validate :only_one_active_championship, if: :active?
  
  scope :active_championships, -> { where(active: true) }
  
  def self.current
    active_championships.first
  end
  
  def full_name
    "#{name} #{year}"
  end
  
  def clubs_count
    clubs.count
  end
  
  def can_add_club?
    clubs_count < 20
  end
  
  def complete?
    clubs_count == 20
  end
  
  private
  
  def only_one_active_championship
    if Championship.where(active: true).where.not(id: id).exists?
      errors.add(:active, 'Ja existe um campeonato ativo')
    end
  end
end
