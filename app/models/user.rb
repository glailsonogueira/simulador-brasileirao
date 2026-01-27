class User < ApplicationRecord
  has_secure_password validations: false
  has_many :predictions, dependent: :destroy
  has_many :round_scores, dependent: :destroy
  has_one :overall_standing, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.avatar_url = auth.info.image
      user.password = SecureRandom.hex(32)
    end
  end
  
  private
  
  def password_required?
    provider.blank? && (new_record? || password.present?)
  end
end
