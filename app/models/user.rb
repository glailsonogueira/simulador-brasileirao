class User < ApplicationRecord
  has_secure_password validations: false
  has_many :predictions, dependent: :destroy
  has_many :round_scores, dependent: :destroy
  has_one :overall_standing, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  scope :active_users, -> { where(active: true) }
  scope :inactive_users, -> { where(active: false) }
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.avatar_url = auth.info.image
      user.password = SecureRandom.hex(32)
      user.active = true
    end
  end
  
  def active_for_authentication?
    active
  end
  # ===== MÉTODOS PARA RESET DE SENHA =====
  
  # Gera token de reset de senha
  def generate_password_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save(validate: false)
  end
  
  # Verifica se o token de reset ainda é válido (expira em 2 horas)
  def password_reset_token_valid?
    reset_password_sent_at.present? && reset_password_sent_at > 2.hours.ago
  end
  
  # Reseta a senha
  def reset_password(new_password)
    self.password = new_password
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    self.force_password_change = false
    save
  end
  
  # Busca usuário por token de reset
  def self.find_by_password_reset_token(token)
    find_by(reset_password_token: token)
  end
end