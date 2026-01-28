class Admin::ClubsController < ApplicationController
  before_action :require_admin
  before_action :set_club, only: [:show, :edit, :update, :destroy]
  
  def index
    @clubs = Club.ordered
  end
  
  def show
  end
  
  def new
    @club = Club.new
  end
  
  def create
    @club = Club.new(club_params)
    
    if @club.save
      redirect_to admin_clubs_path, notice: 'Clube criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @club.update(club_params)
      redirect_to admin_clubs_path, notice: 'Clube atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @club.destroy
    redirect_to admin_clubs_path, notice: 'Clube removido com sucesso!'
  end
  
  private
  
  def set_club
    @club = Club.find(params[:id])
  end
  
  def club_params
    params.require(:club).permit(:name, :abbreviation, :primary_color, :special_club, :badge)
  end
  
  def require_admin
    redirect_to root_path, alert: 'Acesso negado' unless current_user&.admin?
  end
end
