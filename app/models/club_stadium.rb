class ClubStadium < ApplicationRecord
  belongs_to :club
  belongs_to :stadium
  
  validates :club_id, uniqueness: { scope: :stadium_id }
end
