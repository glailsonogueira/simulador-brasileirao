class RoundsController < ApplicationController
  before_action :require_login

  def show
    @championship = Championship.find(params[:championship_id])
    @round = @championship.rounds.find(params[:round_id])
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
    @predictions = current_user.predictions.where(match: @matches).index_by(&:match_id)
  end
end
