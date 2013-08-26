class Playing < ActiveRecord::Base
  attr_accessible :content, :game, :location, :latitude, :longitude
  belongs_to :user

  validates :game,    :presence => true
  validates :content, :presence => true,
                      :length => { :minimum => 3 }

  def self.associate_by_session_token(token, user)
    where(:session_token => token, :user_id => nil).each do |p|
      p.update_attribute(:user, user)
    end
  end

  def coords
    "#{latitude},#{longitude}"
  end

  def map_link
    "http://maps.google.com/maps?ie=UTF8&t=h&z=15&q=#{coords}"
  end
end
