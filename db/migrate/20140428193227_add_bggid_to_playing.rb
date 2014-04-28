class AddBggidToPlaying < ActiveRecord::Migration
  def change
    add_column :playings, :bgg_id, :integer
  end
end
