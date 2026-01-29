class AddStadiumsToClubs < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:clubs, :primary_stadium_id)
      add_column :clubs, :primary_stadium_id, :bigint
      add_foreign_key :clubs, :stadiums, column: :primary_stadium_id
      add_index :clubs, :primary_stadium_id
    end
    
    unless table_exists?(:club_stadiums)
      create_table :club_stadiums do |t|
        t.references :club, null: false, foreign_key: true
        t.bigint :stadium_id, null: false

        t.timestamps
      end
      
      add_foreign_key :club_stadiums, :stadiums
      add_index :club_stadiums, [:club_id, :stadium_id], unique: true
    end
  end
end
