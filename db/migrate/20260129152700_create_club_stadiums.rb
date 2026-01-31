class CreateClubStadiums < ActiveRecord::Migration[7.2]
  def change
    create_table :club_stadiums do |t|
      t.references :club, null: false, foreign_key: true
      t.references :stadium, null: false, foreign_key: true
      
      t.timestamps
    end
    
    add_index :club_stadiums, [:club_id, :stadium_id], unique: true
  end
end
