class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email, :password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  before_save :generate_refresh_token

  has_many :timers

  def generate_refresh_token
   self.refresh_token = SecureRandom.hex(80)
  end

  def regenerate_refresh_token
    
    generate_refresh_token
    self.save(validate: false)
    self.reload
  end
end
