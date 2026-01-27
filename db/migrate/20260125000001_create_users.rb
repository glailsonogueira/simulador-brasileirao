class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.string :provider
      t.string :uid
      t.string :avatar_url
      t.boolean :admin, default: false

      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
