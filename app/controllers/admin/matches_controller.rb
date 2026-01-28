module Admin
  class MatchesController < ApplicationController
    before_action :require_admin
    before_action :set_round
    before_action :set_match, only: [:edit, :update, :destroy]
    
    def index
      @matches = @round.matches.includes(:home_club, :away_club).ordered_by_date
      @championship = @round.championship
    end
    
    def new
      @match = @round.matches.new
      @clubs = @round.championship.clubs.ordered
    end
    
    def create
      @match = @round.matches.new(match_params)
      
      if @match.save
        redirect_to admin_round_matches_path(@round), notice: 'Partida cadastrada com sucesso!'
      else
        @clubs = @round.championship.clubs.ordered
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
      @clubs = @round.championship.clubs.ordered
    end
    
    def update
      if @match.update(match_params)
        redirect_to admin_round_matches_path(@round), notice: 'Partida atualizada com sucesso!'
      else
        @clubs = @round.championship.clubs.ordered
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      @match.destroy
      redirect_to admin_round_matches_path(@round), notice: 'Partida removida com sucesso!'
    end
    
    private
    
    def set_round
      @round = Round.find(params[:round_id])
    end
    
    def set_match
      @match = @round.matches.find(params[:id])
    end
    
    def match_params
      params.require(:match).permit(:home_club_id, :away_club_id, :scheduled_at)
    end
  end
end
