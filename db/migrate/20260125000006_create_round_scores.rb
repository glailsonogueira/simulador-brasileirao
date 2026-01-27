class CreateRoundScores < ActiveRecord::Migration[7.1]
  def change
    create_table :round_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.integer :total_points, default: 0
      t.integer :exact_scores, default: 0
      t.integer :correct_results, default: 0
      t.integer :special_exact_scores, default: 0
      t.integer :special_correct_results, default: 0
      t.integer :position, default: 0
      t.boolean :winner, default: false

      t.timestamps
    end
    
    add_index :round_scores, [:user_id, :round_id], unique: true
    add_index :round_scores, [:round_id, :position]
  end
end
