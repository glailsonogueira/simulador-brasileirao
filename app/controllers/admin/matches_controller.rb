class Admin::MatchesController < ApplicationController
  before_action :require_admin
  before_action :set_round
  before_action :set_match, only: [:edit, :update]

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
end
