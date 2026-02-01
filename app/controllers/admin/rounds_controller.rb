class Admin::RoundsController < ApplicationController
  before_action :require_admin
  before_action :set_round, only: [:matches, :create_matches, :results, :calculate_rankings, :finalize_all, :reopen_all]

  def matches
    @championship = @round.championship
    @matches = @round.matches.includes(:home_club, :away_club, :stadium).order(:scheduled_at)
  end

  def create_matches
    redirect_to matches_admin_round_path(@round), notice: 'Partidas criadas!'
  end

  def results
    @championship = @round.championship
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
  end

  def finalize_all
    count = 0
    
    @round.matches.where(finished: false).find_each do |match|
      match_data = params[:matches]&.[](match.id.to_s)
      
      if match_data && match.update(
        home_score: match_data[:home_score],
        away_score: match_data[:away_score],
        finished: true
      )
        count += 1
      end
    end
    
    redirect_to results_admin_round_path(@round), notice: "#{count} partida(s) finalizada(s) com sucesso!"
  end

  def reopen_all
    count = @round.matches.where(finished: true).update_all(finished: false)
    redirect_to results_admin_round_path(@round), notice: "#{count} partida(s) reaberta(s) para edição!"
  end

  def calculate_rankings
    RoundScore.calculate_for_round(@round)
    redirect_to results_admin_round_path(@round), notice: 'Rankings calculados com sucesso!'
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end
end