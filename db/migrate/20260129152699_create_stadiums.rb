class CreateStadiums < ActiveRecord::Migration[7.2]
  def change
    create_table :stadiums do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :state, null: false, limit: 2
      
      t.timestamps
    end
    
    add_index :stadiums, :name
  end
end
