class Championship < ApplicationRecord
  has_many :championship_clubs, dependent: :destroy
  has_many :clubs, through: :championship_clubs
  has_many :rounds, dependent: :destroy
  has_many :overall_standings, dependent: :destroy
  
  validates :year, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than: 2000 }
  validates :name, presence: true
  validate :must_have_exactly_20_clubs, if: :active?
  
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(year: :desc) }
  
  def self.current
    active.first || ordered.first
  end
  
  def full_name
    "#{name} #{year}"
  end
  
  def can_add_club?
    clubs.count < 20
  end
  
  def can_remove_club?
    clubs.count > 0
  end
  
  def clubs_count
    clubs.count
  end
  
  def missing_clubs_count
    [0, 20 - clubs_count].max
  end
  
  def complete?
    clubs_count == 20
  end
  
  private
  
  def must_have_exactly_20_clubs
    if clubs_count != 20
      errors.add(:base, "Campeonato deve ter exatamente 20 clubes (atual: #{clubs_count})")
    end
  end
end
