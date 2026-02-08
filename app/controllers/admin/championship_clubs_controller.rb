class Admin::ChampionshipClubsController < ApplicationController
  before_action :require_admin
  before_action :set_championship
  
  def index
    @available_clubs = Club.where.not(id: @championship.club_ids).order(:name)
    @championship_clubs = @championship.championship_clubs.includes(:club).order(:position_order)
  end
  
  private
  
  def set_championship
    @championship = Championship.find(params[:championship_id])
  end
end
