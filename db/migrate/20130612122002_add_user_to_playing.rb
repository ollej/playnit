class AddUserToPlaying < ActiveRecord::Migration
  def change
    add_column :playings, :user_id, :integer
  end
end
