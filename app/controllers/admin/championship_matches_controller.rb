class Admin::ChampionshipMatchesController < ApplicationController
  before_action :require_admin
  before_action :set_championship
  
  def index
    @rounds = @championship.rounds.order(:number)
  end
  
  private
  
  def set_championship
    @championship = Championship.find(params[:championship_id])
  end
end