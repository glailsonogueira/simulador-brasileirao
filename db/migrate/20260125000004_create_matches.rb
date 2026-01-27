class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :round, null: false, foreign_key: true
      t.references :home_club, null: false, foreign_key: { to_table: :clubs }
      t.references :away_club, null: false, foreign_key: { to_table: :clubs }
      t.datetime :scheduled_at, null: false
      t.integer :home_result
      t.integer :away_result
      t.boolean :finished, default: false

      t.timestamps
    end
    
    add_index :matches, [:round_id, :home_club_id, :away_club_id], 
              unique: true, name: 'index_matches_on_round_and_clubs'
    add_index :matches, :finished
    add_index :matches, :scheduled_at
  end
end
