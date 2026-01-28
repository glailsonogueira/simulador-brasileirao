class ChampionshipClub < ApplicationRecord
  belongs_to :championship
  belongs_to :club
  
  validates :championship_id, uniqueness: { scope: :club_id, message: "já possui este clube" }
  validate :championship_cannot_exceed_20_clubs
  
  private
  
  def championship_cannot_exceed_20_clubs
    if championship && championship.clubs.count >= 20 && new_record?
      errors.add(:base, "Campeonato já possui 20 clubes")
    end
  end
end
