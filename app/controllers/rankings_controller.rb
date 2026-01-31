class RankingsController < ApplicationController
  before_action :require_login

  def index
    @championships = Championship.order(year: :desc)
  end

  def show_championship
    @championship = Championship.find(params[:championship_id])
    @overall_standings = @championship.overall_standings.includes(:user).order(position: :asc)
    @rounds = @championship.rounds.order(number: :asc)
  end

  def round
    @round = Round.find(params[:round_id])
    @championship = @round.championship
    @round_scores = @round.round_scores.includes(:user).order(position: :asc)
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
  end

  def user_detail
    @championship = Championship.find(params[:championship_id])
    @user = User.find(params[:user_id])
    @overall_standing = @championship.overall_standings.find_by(user: @user)
    @round_scores = RoundScore.joins(:round)
                              .where(rounds: { championship_id: @championship.id })
                              .where(user: @user)
                              .includes(:round)
                              .order('rounds.number DESC')
  end
end
