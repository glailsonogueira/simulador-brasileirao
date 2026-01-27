class CreateClubs < ActiveRecord::Migration[7.1]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false, limit: 3
      t.string :primary_color
      t.boolean :special_club, default: false

      t.timestamps
    end
    
    add_index :clubs, :name, unique: true
    add_index :clubs, :abbreviation, unique: true
    add_index :clubs, :special_club
  end
end
