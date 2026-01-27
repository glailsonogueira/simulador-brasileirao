class OverallStanding < ApplicationRecord
  belongs_to :user
  
  validates :user_id, uniqueness: true
  
  scope :ordered, -> { order(position: :asc) }
  scope :top_10, -> { ordered.limit(10) }
end
