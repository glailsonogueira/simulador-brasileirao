class RankingsController < ApplicationController
  def index
    @championships = Championship.order(year: :desc)
  end

  def show_championship
    @championship = Championship.find(params[:championship_id])
    @overall_standings = @championship.overall_standings
                                      .includes(:user)
                                      .order(position: :asc)
    @rounds = @championship.rounds.order(:number)
  end

  def round
    @championship = Championship.find(params[:championship_id])
    @round = @championship.rounds.find(params[:round_id])
    @round_scores = @round.round_scores
                          .includes(:user)
                          .order(position: :asc)
  end

  def user_detail
    @championship = Championship.find(params[:championship_id])
    @user = User.find(params[:user_id])
    @overall_standing = @championship.overall_standings.find_by(user: @user)
    @round_scores = @user.round_scores
                         .joins(:round)
                         .where(rounds: { championship_id: @championship.id })
                         .order('rounds.number ASC')
  end
end
