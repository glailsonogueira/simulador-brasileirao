class AddBadgeFilenameToClubs < ActiveRecord::Migration[7.2]
  def change
    add_column :clubs, :badge_filename, :string
  end
end
