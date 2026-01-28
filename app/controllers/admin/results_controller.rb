class Admin::ResultsController < ApplicationController
  before_action :require_admin
  before_action :set_round
  
  def index
    @matches = @round.matches.includes(:home_club, :away_club).order(:scheduled_at)
  end
  
  def update
    @match = @round.matches.find(params[:id])
    
    if @match.update(match_params)
      # Recalcular pontuações se o jogo foi finalizado
      if @match.finished?
        ScoreCalculatorService.new(@match).calculate
      end
      
      redirect_to admin_round_results_path(@round), notice: 'Resultado atualizado com sucesso!'
    else
      redirect_to admin_round_results_path(@round), alert: 'Erro ao atualizar resultado'
    end
  end
  
  def recalculate
    @round.matches.where(finished: true).each do |match|
      ScoreCalculatorService.new(match).calculate
    end
    
    redirect_to admin_round_results_path(@round), notice: 'Pontuações recalculadas com sucesso!'
  end
  
  private
  
  def set_round
    @round = Round.find(params[:round_id])
  end
  
  def match_params
    params.require(:match).permit(:home_score, :away_score, :finished)
  end
  
  def require_admin
    redirect_to root_path, alert: 'Acesso negado' unless current_user&.admin?
  end
end
