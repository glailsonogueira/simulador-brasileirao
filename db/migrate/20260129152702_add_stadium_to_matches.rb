class AddStadiumToMatches < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:matches, :stadium_id)
      add_column :matches, :stadium_id, :bigint
      add_foreign_key :matches, :stadiums
      add_index :matches, :stadium_id
    end
  end
end
