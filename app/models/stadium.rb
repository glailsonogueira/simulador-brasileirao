class Stadium < ApplicationRecord
  self.table_name = 'stadiums'
  
  has_many :clubs_as_primary, class_name: 'Club', foreign_key: 'primary_stadium_id'
  has_many :club_stadiums, dependent: :destroy
  has_many :clubs, through: :club_stadiums
  has_many :matches, dependent: :nullify
  
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true, length: { is: 2 }
  
  scope :ordered, -> { order(:name) }
  
  def full_location
    "#{city} - #{state}"
  end
  
  def full_name
    "#{name} (#{city}/#{state})"
  end
end
