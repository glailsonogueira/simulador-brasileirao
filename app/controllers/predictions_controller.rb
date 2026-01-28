class PredictionsController < ApplicationController
  before_action :set_championship
  
  def index
    redirect_to root_path, alert: 'Nenhum campeonato ativo' unless @championship
    if @championship
      @rounds = @championship.rounds.includes(matches: [:home_club, :away_club]).order(:number)
    end
  end
  
  def update_batch
    round = Round.find(params[:round_id])
    
    unless round.is_unlocked?
      redirect_to predictions_path, alert: 'Esta rodada ainda está bloqueada!'
      return
    end
    
    if round.deadline_passed?
      redirect_to round_path(round), alert: 'Prazo expirado! Não é possível fazer palpites após 1 hora antes do primeiro jogo.'
      return
    end
    
    predictions_params = params[:predictions] || {}
    
    saved_count = 0
    predictions_params.each do |match_id, scores|
      prediction = current_user.predictions.find_or_initialize_by(match_id: match_id)
      if prediction.update(
        home_score: scores[:home],
        away_score: scores[:away]
      )
        saved_count += 1
      end
    end
    
    redirect_to round_path(round), notice: "#{saved_count} previsão(ões) salva(s) com sucesso!"
  end
  
  private
  
  def set_championship
    @championship = Championship.current
  end
end
