class AddFavoriteClubToChampionships < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:championships, :favorite_club_id)
      add_reference :championships, :favorite_club, foreign_key: { to_table: :clubs }, null: true
    end
  end
end
