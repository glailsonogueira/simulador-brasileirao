class Admin::StadiumsController < ApplicationController
  before_action :require_admin
  before_action :set_stadium, only: [:show, :edit, :update, :destroy]

  def index
    @stadiums = Stadium.ordered
  end

  def show
  end

  def new
    @stadium = Stadium.new
  end

  def create
    @stadium = Stadium.new(stadium_params)
    if @stadium.save
      redirect_to admin_stadiums_path, notice: 'Estadio criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stadium.update(stadium_params)
      redirect_to admin_stadiums_path, notice: 'Estadio atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @stadium.matches.any?
      redirect_to admin_stadiums_path, alert: "Nao e possivel excluir #{@stadium.name} pois tem #{@stadium.matches.count} partida(s) cadastrada(s)."
      return
    end
    
    @stadium.destroy
    redirect_to admin_stadiums_path, notice: 'Estadio removido com sucesso!'
  end

  private

  def set_stadium
    @stadium = Stadium.find(params[:id])
  end

  def stadium_params
    params.require(:stadium).permit(:name, :city, :state)
  end
end
