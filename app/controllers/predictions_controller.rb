class PredictionsController < ApplicationController
  before_action :require_login

  def index
    @championships = Championship.order(year: :desc)
  end

  def show_championship
    @championship = Championship.find(params[:championship_id])
    @rounds = @championship.rounds.order(:number)
  end

  def update_batch
    @championship = Championship.find(params[:championship_id])
    round = @championship.rounds.find(params[:round_id])
    predictions_params = params[:predictions] || {}
    
    updated_count = 0
    locked_count = 0
    skipped_count = 0
    
    predictions_params.each do |match_id, scores|
      match = Match.find(match_id)
      
      # Pular se campos vazios ou incompletos
      if scores[:home].blank? || scores[:away].blank?
        skipped_count += 1
        next
      end
      
      # Verificar se o jogo está bloqueado
      unless match.can_predict?
        locked_count += 1
        next
      end
      
      prediction = current_user.predictions.find_or_initialize_by(match_id: match_id)
      
      if prediction.update(
        home_score: scores[:home],
        away_score: scores[:away]
      )
        updated_count += 1
      end
    end
    
    message = "#{updated_count} previsao(es) salva(s) com sucesso!"
    message += " #{locked_count} jogo(s) bloqueado(s)." if locked_count > 0
    message += " #{skipped_count} jogo(s) ignorado(s) (campos vazios)." if skipped_count > 0
    
    redirect_to round_prediction_path(championship_id: @championship.id, round_id: round.id), notice: message
  end
end
