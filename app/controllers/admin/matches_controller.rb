class Admin::MatchesController < ApplicationController
  before_action :require_admin
  before_action :set_match, only: [:edit, :update, :finalize, :reopen]

  def edit
    @round = @match.round
    @championship = @round.championship
    @stadiums = Stadium.ordered
  end

  def update
    @round = @match.round
    
    if @match.update(match_params)
      redirect_to matches_admin_round_path(@round), notice: 'Partida atualizada com sucesso!'
    else
      @championship = @round.championship
      @stadiums = Stadium.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def finalize
    @round = @match.round
    
    if @match.update(match_finalize_params.merge(finished: true))
      # Recalcular TODA a rodada usando o método correto
      RoundScore.calculate_for_round(@round)
      OverallStanding.calculate_for_championship(@round.championship)
      
      redirect_to results_admin_round_path(@round), notice: 'Partida finalizada e rankings recalculados com sucesso!'
    else
      redirect_to results_admin_round_path(@round), alert: 'Erro ao finalizar partida.'
    end
  end

  def reopen
    @round = @match.round
    
    if @match.update(finished: false)
      redirect_to results_admin_round_path(@round), notice: 'Partida reaberta para edição!'
    else
      redirect_to results_admin_round_path(@round), alert: 'Erro ao reabrir partida.'
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:scheduled_at, :stadium_id, :home_score, :away_score, :finished)
  end

  def match_finalize_params
    params.require(:match).permit(:home_score, :away_score)
  end
end