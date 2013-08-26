class AddLatLngToPlayings < ActiveRecord::Migration
  def change
    add_column :playings, :latitude, :decimal
    add_column :playings, :longitude, :decimal
    Playing.where(latitude: nil).update_all(latitude: 0, longitude: 0)
  end
end
