class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }, on: :create
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }, on: :create
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
