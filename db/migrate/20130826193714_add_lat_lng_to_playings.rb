class AddLatLngToPlayings < ActiveRecord::Migration
  def change
    add_column :playings, :latitude, :decimal
    add_column :playings, :longitude, :decimal
  end
end
