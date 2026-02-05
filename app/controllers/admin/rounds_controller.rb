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
    match_ids = params[:match_ids] || []
    count = 0
    
    @round.matches.where(finished: false).find_each do |match|
      match_data = params[:matches]&.[](match.id.to_s)
      
      # Finalizar se tem placar preenchido
      if match_data && match_data[:home_score].present? && match_data[:away_score].present?
        if match.update(
          home_score: match_data[:home_score],
          away_score: match_data[:away_score],
          finished: true
        )
          count += 1
        end
      end
    end
    
    # Recalcular rankings UMA VEZ após finalizar todos os jogos
    if count > 0
      recalculate_round_rankings
      redirect_to results_admin_round_path(@round), notice: "#{count} partida(s) finalizada(s) e rankings recalculados com sucesso!"
    else
      redirect_to results_admin_round_path(@round), alert: "Nenhuma partida foi finalizada. Verifique se os placares estão preenchidos."
    end
  end

  def reopen_all
    match_ids = params[:match_ids] || []
    count = 0
    
    if match_ids.empty?
      redirect_to results_admin_round_path(@round), alert: "Selecione pelo menos um jogo para reabrir!"
      return
    end
    
    match_ids.each do |match_id|
      match = @round.matches.find_by(id: match_id, finished: true)
      if match && match.update(finished: false)
        count += 1
      end
    end
    
    redirect_to results_admin_round_path(@round), notice: "#{count} partida(s) reaberta(s) para edição!"
  end

  def calculate_rankings
    RoundScore.calculate_for_round(@round)
    redirect_to results_admin_round_path(@round), notice: 'Rankings calculados com sucesso!'
  end

  def recalculate_round_rankings
    # Usar o método correto que calcula UMA VEZ
    RoundScore.calculate_for_round(@round)
    OverallStanding.calculate_for_championship(@round.championship)
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end
end