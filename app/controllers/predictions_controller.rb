class PredictionsController < ApplicationController
  before_action :require_login

  def index
    @championship = Championship.current
    redirect_to root_path, alert: 'Nenhum campeonato ativo no momento.' and return unless @championship
    @rounds = @championship.rounds.order(:number)
  end

  def update_batch
    round = Round.find(params[:round_id])
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
    
    redirect_to round_path(round), notice: message
  end
end
