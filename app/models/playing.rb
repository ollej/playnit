class Playing < ActiveRecord::Base
  attr_accessible :content, :game, :location

  validates :game,    :presence => true
  validates :content, :presence => true,
                      :length => { :minimum => 3 }
end
