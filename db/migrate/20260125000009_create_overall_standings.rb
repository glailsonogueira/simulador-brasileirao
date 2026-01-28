class CreateOverallStandings < ActiveRecord::Migration[7.1]
  def change
    create_table :overall_standings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :championship, null: false, foreign_key: true
      t.integer :total_points, default: 0
      t.integer :rounds_won, default: 0
      t.integer :exact_scores, default: 0
      t.integer :correct_results, default: 0
      t.integer :position, default: 0
      t.timestamps
    end
    add_index :overall_standings, [:user_id, :championship_id], unique: true
    add_index :overall_standings, :position
  end
end
