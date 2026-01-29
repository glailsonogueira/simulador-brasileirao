class AddPredictedAtToPredictions < ActiveRecord::Migration[7.2]
  def change
    add_column :predictions, :predicted_at, :datetime
    add_column :predictions, :locked, :boolean, default: false
    add_index :predictions, :predicted_at
  end
end
