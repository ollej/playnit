class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :playing

  def admin?
    admin
  end

  def can_modify?(playing)
    return true if self == playing.user
    return true if admin?
    false
  end

  def add_provider(auth_hash)
    info = auth_hash[:info]
    self.email ||= info[:email]
    self.name ||= info[:name]
    self.avatar ||= info[:image]
    self.google_uid ||= auth_hash[:uid]
  end

  def self.from_omniauth(auth_hash)
    user = User.find_or_create_by(google_uid: auth_hash[:uid]) do |u|
      u.add_provider(auth_hash)
      u.password = Devise.friendly_token[0,20]
    end
    user
  end
end
