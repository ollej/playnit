class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_uid, :string
    add_column :users, :name, :string
    add_column :users, :avatar, :string
    add_index :users, :google_uid, unique: true
  end
end
