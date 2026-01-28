class RoundsController < ApplicationController
  def show
    @championship = Championship.current
    @round = @championship.rounds.find(params[:id])
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
    @predictions = current_user.predictions.where(match_id: @matches.pluck(:id)).index_by(&:match_id)
  end
end
