class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.integer :number, null: false

      t.timestamps
    end
    
    add_index :rounds, :number, unique: true
  end
end
