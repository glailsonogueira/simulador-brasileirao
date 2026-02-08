module Admin
  class ChampionshipsController < ApplicationController
    before_action :require_admin
    before_action :set_championship, only: [:show, :edit, :update, :destroy, :activate]
    
    def index
      @championships = Championship.order(year: :desc)
    end
    
    def show
      @available_clubs = Club.where.not(id: @championship.club_ids).ordered
      @championship_clubs = @championship.championship_clubs.includes(:club).order(:position_order)
    end
    
    def new
      @championship = Championship.new(year: Date.current.year)
    end
    
    def create
      @championship = Championship.new(championship_params)
      
      if @championship.save
        redirect_to admin_championship_path(@championship), notice: 'Campeonato criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
    end
    
    def update
      if @championship.update(championship_params)
        redirect_to admin_championship_path(@championship), notice: 'Campeonato atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      @championship.destroy
      redirect_to admin_championships_path, notice: 'Campeonato removido com sucesso!'
    end
    
    def activate
      Championship.update_all(active: false)
      @championship.update(active: true)
      redirect_to admin_championships_path, notice: "Campeonato #{@championship.year} ativado!"
    end
    
    def add_club
      @championship = Championship.find(params[:championship_id])
      club = Club.find(params[:club_id])
      
      if @championship.can_add_club?
        @championship.clubs << club
        redirect_to admin_championship_path(@championship), notice: "#{club.name} adicionado ao campeonato!"
      else
        redirect_to admin_championship_path(@championship), alert: "Campeonato já possui 20 clubes!"
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_championship_path(@championship), alert: e.message
    end
    
    def remove_club
      @championship = Championship.find(params[:championship_id])
      club = Club.find(params[:club_id])
      
      # Verificar se o clube já participou de algum jogo
      matches_count = Match.joins(:round)
                           .where(rounds: { championship_id: @championship.id })
                           .where("home_club_id = ? OR away_club_id = ?", club.id, club.id)
                           .count
      
      if matches_count > 0
        redirect_to admin_championship_path(@championship), 
                    alert: "Não é possível remover #{club.name} pois já possui #{matches_count} partida(s) cadastrada(s) nas rodadas."
        return
      end
      
      @championship.clubs.delete(club)
      redirect_to admin_championship_path(@championship), notice: "#{club.name} removido do campeonato!"
    end
    
    def generate_rounds
      @championship = Championship.find(params[:championship_id])
      
      unless @championship.complete?
        redirect_to admin_championship_path(@championship), alert: "Adicione 20 clubes antes de gerar rodadas!"
        return
      end
      
      if @championship.rounds.any?
        redirect_to admin_championship_path(@championship), alert: "Rodadas já foram geradas!"
        return
      end
      
      # Criar 38 rodadas
      38.times do |i|
        @championship.rounds.create!(number: i + 1)
      end
      
      redirect_to admin_championship_path(@championship), notice: "38 rodadas criadas com sucesso!"
    end
    
    private
    
    def set_championship
      @championship = Championship.find(params[:id])
    end
    
    def championship_params
      params.require(:championship).permit(:year, :name, :active, :start_date, :end_date, :favorite_club_id)
    end
  end
end
