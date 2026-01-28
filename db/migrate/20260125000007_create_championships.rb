class CreateChampionships < ActiveRecord::Migration[7.1]
  def change
    create_table :championships do |t|
      t.integer :year, null: false
      t.string :name, null: false
      t.boolean :active, default: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    
    add_index :championships, :year, unique: true
    add_index :championships, :active
  end
end
