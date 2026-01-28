class RenameMatchResultColumns < ActiveRecord::Migration[7.2]
  def change
    rename_column :matches, :home_result, :home_score
    rename_column :matches, :away_result, :away_score
  end
end
