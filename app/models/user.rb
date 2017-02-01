class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :sort_by
  has_secure_password
  has_many :tasks, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }, on: :create
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }, on: :create
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  after_commit :send_welcome_email, on: :create

  def send_welcome_email
    SendMail.perform_async(self.attributes, 'welcome_email')
  end

  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
