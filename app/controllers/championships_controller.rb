class ChampionshipsController < ApplicationController
  before_action :require_admin
  before_action :set_championship, only: [:recalculate_all_rankings]

  def recalculate_all_rankings
    # Recalcular todas as rodadas
    @championship.rounds.each do |round|
      RoundScore.calculate_for_round(round)
    end
    
    # Recalcular ranking geral
    OverallStanding.calculate_for_championship(@championship)
    
    redirect_to championship_rankings_path(championship_id: @championship.id), 
                notice: 'Rankings recalculados com sucesso!'
  end

  private

  def set_championship
    @championship = Championship.find(params[:id])
  end
end
