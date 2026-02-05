class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :toggle_admin, :toggle_active, :force_password_change]
  
  def index
    @users = User.order(:name)
  end
  
  def show
  end
  
  def toggle_admin
    @user.update(admin: !@user.admin?)
    redirect_to admin_users_path, notice: "#{@user.name} #{@user.admin? ? 'agora é admin' : 'não é mais admin'}!"
  end
  
  def toggle_active
    @user.update(active: !@user.active?)
    redirect_to admin_users_path, notice: "#{@user.name} foi #{@user.active? ? 'ativado' : 'desativado'}!"
  end

  def force_password_change
    @user.update(force_password_change: !@user.force_password_change?)
    status = @user.force_password_change? ? 'deverá alterar a senha no próximo login' : 'não precisa mais alterar a senha'
    redirect_to admin_users_path, notice: "#{@user.name} #{status}!"
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_admin
    redirect_to root_path, alert: 'Acesso negado' unless current_user&.admin?
  end
end
