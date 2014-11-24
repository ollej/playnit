require 'carrierwave/orm/activerecord'

class Playing < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user

  validates :game, :presence => true
  #validates :latitude, :presence => true
  #validates :longitude, :presence => true

  def self.associate_by_session_token(token, user)
    where(:session_token => token, :user_id => nil).each do |p|
      p.update_attribute(:user, user)
    end
  end

  def coords
    "#{latitude},#{longitude}"
  end

  def position
    { coords: { latitude: latitude, longitude: longitude } }
  end

  def has_location
    latitude.present? && longitude.present?
  end

  def toolbar_class(current_user)
    return "" unless current_user
    return "playing-owner" if user == current_user
    return "playing-admin" if current_user.can_modify?(self)
    ""
  end
end
