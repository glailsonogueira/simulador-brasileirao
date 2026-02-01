class Admin::MatchesController < ApplicationController
  before_action :require_admin
  before_action :set_round
  before_action :set_match, only: [:edit, :update, :finalize_match, :reopen_match]

  def edit
    @championship = @round.championship
    @stadiums = Stadium.ordered
  end

  def update
    if @match.update(match_params)
      redirect_to matches_admin_round_path(@round), notice: 'Partida atualizada com sucesso!'
    else
      @championship = @round.championship
      @stadiums = Stadium.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def finalize_match
    if @match.update(match_finalize_params.merge(finished: true))
      redirect_to results_admin_round_path(@round), notice: 'Partida finalizada com sucesso!'
    else
      redirect_to results_admin_round_path(@round), alert: 'Erro ao finalizar partida.'
    end
  end

  def reopen_match
    if @match.update(finished: false)
      redirect_to results_admin_round_path(@round), notice: 'Partida reaberta para edição!'
    else
      redirect_to results_admin_round_path(@round), alert: 'Erro ao reabrir partida.'
    end
  end

  private

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_match
    @match = @round.matches.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:scheduled_at, :stadium_id, :home_score, :away_score, :finished)
  end

  def match_finalize_params
    params.require(:match).permit(:home_score, :away_score)
  end
end
