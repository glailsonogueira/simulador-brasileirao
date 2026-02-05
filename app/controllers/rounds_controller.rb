class RoundsController < ApplicationController
  before_action :require_login

  def show
    @championship = Championship.find(params[:championship_id])
    @round = @championship.rounds.find(params[:round_id])

    # Verificar se o usuário pode acessar esta rodada
    unless @round.can_access_predictions?
      redirect_to championship_predictions_path(championship_id: @championship.id), 
                  alert: "Esta rodada está bloqueada. Aguarde a rodada anterior ser finalizada ou que falte menos de 5 dias para o primeiro jogo."
      return
    end

    @matches = @round.matches.includes(:home_club, :away_club, :stadium).order(:scheduled_at)
    @predictions = current_user.predictions.where(match: @matches).index_by(&:match_id)
    
    # Buscar pontuações totais da rodada
    @round_scores = RoundScore.where(round: @round).index_by(&:user_id)
    
    # Buscar TODOS os usuários (exceto o administrador) INCLUINDO o usuário atual
    all_users_including_current = User.where.not(name: 'Administrador').order(:name)
    
    # Criar ranking de TODOS os usuários por pontuação
    if @round.all_matches_finished?
      ranked_users = all_users_including_current.sort_by do |user|
        -(@round_scores[user.id]&.total_points || 0)
      end
      
      # Criar hash de posições: user_id => position
      @user_rankings = {}
      ranked_users.each_with_index do |user, index|
        @user_rankings[user.id] = index + 1
      end
    else
      @user_rankings = {}
    end
    
    # Separar outros usuários (exceto o atual)
    @all_users = all_users_including_current.where.not(id: current_user.id)
    
    # Buscar previsões de todos os outros usuários
    @other_users_predictions = {}
    
    @all_users.each do |user|
      user_predictions = user.predictions
                             .where(match_id: @matches.pluck(:id))
                             .index_by(&:match_id)
      
      @other_users_predictions[user] = user_predictions
    end
    
    # Ordenar usuários por ranking (posição)
    if @round.all_matches_finished?
      @all_users = @all_users.sort_by { |user| @user_rankings[user.id] || 999 }
    end
  end
end