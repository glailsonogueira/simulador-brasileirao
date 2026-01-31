class Admin::RoundsController < ApplicationController
  before_action :require_admin
  before_action :set_round, only: [:matches, :create_matches, :results, :update_results, :calculate_rankings]

  def matches
    @championship = @round.championship
    @matches = @round.matches.includes(:home_club, :away_club, :stadium).order(:scheduled_at)
  end

  def create_matches
    # Lógica para criar partidas (se necessário)
    redirect_to matches_admin_round_path(@round), notice: 'Partidas criadas!'
  end

  def results
    @championship = @round.championship
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
  end

  def update_results
    params[:matches]&.each do |match_id, scores|
      match = @round.matches.find(match_id)
      match.update(
        home_score: scores[:home],
        away_score: scores[:away],
        finished: scores[:finished] == '1'
      )
    end
    
    redirect_to results_admin_round_path(@round), notice: 'Resultados atualizados com sucesso!'
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
