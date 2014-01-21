class ChangeEmptyGeoToNull < ActiveRecord::Migration
  def up
    Playing.where(latitude: 0, longitude: 0).update_all(latitude: nil, longitude: nil)
  end

  def down
    Playing.where(latitude: nil, longitude: nil).update_all(latitude: 0, longitude: 0)
  end
end
