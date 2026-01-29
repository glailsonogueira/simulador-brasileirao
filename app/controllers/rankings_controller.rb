class RankingsController < ApplicationController
  def index
    @championships = Championship.order(year: :desc)
  end

  def show_championship
    @championship = Championship.find(params[:id])
    @overall_standings = @championship.overall_standings
                                      .includes(:user)
                                      .order(position: :asc)
    @rounds = @championship.rounds.order(:number)
  end

  def round
    @championship = Championship.current
    @round = @championship.rounds.find(params[:round_id])
    @round_scores = @round.round_scores
                          .includes(:user)
                          .order(position: :asc)
  end

  def user_detail
    @championship = Championship.current
    @user = User.find(params[:id])
    @overall_standing = @championship.overall_standings.find_by(user: @user)
    @round_scores = @user.round_scores
                         .joins(:round)
                         .where(rounds: { championship_id: @championship.id })
                         .order('rounds.number ASC')
  end
end
