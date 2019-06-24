class User < ApplicationRecord
  validates :email, :name, :auth_token, presence: true
  has_many :posts

  after_initialize :generate_auth_token

  def generate_auth_token
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end
end
