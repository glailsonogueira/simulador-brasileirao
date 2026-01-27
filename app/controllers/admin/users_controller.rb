class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :toggle_admin]
  
  def index
    @users = User.order(:name)
  end
  
  def show
  end
  
  def toggle_admin
    @user.update(admin: !@user.admin?)
    redirect_to admin_users_path, notice: "#{@user.name} #{@user.admin? ? 'agora é admin' : 'não é mais admin'}!"
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_admin
    redirect_to root_path, alert: 'Acesso negado' unless current_user&.admin?
  end
end
