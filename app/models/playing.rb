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
    latitude && latitude > 0 && longitude && longitude > 0
  end

  def map_link
    "http://maps.google.com/maps?ie=UTF8&t=h&z=15&q=#{coords}"
  end
end
