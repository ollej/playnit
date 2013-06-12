class Playing < ActiveRecord::Base
  attr_accessible :content, :game, :location
  belongs_to :user

  validates :game,    :presence => true
  validates :content, :presence => true,
                      :length => { :minimum => 3 }

  def self.associate_by_session_token(token, user)
    where(:session_token => token, :user_id => nil).each do |p|
      p.update_attribute(:user, user)
    end
  end
end
