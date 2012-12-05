class CreatePlayings < ActiveRecord::Migration
  def change
    create_table :playings do |t|
      t.string :game
      t.string :location
      t.text :content

      t.timestamps
    end
  end
end
