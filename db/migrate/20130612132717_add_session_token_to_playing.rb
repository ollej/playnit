class AddSessionTokenToPlaying < ActiveRecord::Migration
  def change
    add_column :playings, :session_token, :string
    add_index :playings, :session_token
    add_index :playings, :user_id
  end
end
