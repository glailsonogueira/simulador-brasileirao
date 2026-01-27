class AddChampionshipToRounds < ActiveRecord::Migration[7.1]
  def change
    add_reference :rounds, :championship, null: true, foreign_key: true
    add_index :rounds, [:championship_id, :number], unique: true
  end
end
