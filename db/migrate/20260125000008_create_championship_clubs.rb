class CreateChampionshipClubs < ActiveRecord::Migration[7.1]
  def change
    create_table :championship_clubs do |t|
      t.references :championship, null: false, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.integer :position_order

      t.timestamps
    end
    
    add_index :championship_clubs, [:championship_id, :club_id], unique: true
  end
end
