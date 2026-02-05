class AddPasswordFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :force_password_change, :boolean, default: false
    
    add_index :users, :reset_password_token, unique: true
  end
end
