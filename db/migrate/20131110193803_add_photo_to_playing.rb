class AddPhotoToPlaying < ActiveRecord::Migration
  def change
    add_column :playings, :photo, :string
  end
end
