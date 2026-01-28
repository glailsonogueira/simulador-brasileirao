class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  before_action :require_login
  helper_method :current_user, :logged_in?, :current_championship
  
  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user.present?
  end
  
  def current_championship
    @current_championship ||= Championship.current
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'Você precisa estar logado para acessar esta página'
    end
  end
  
  def require_admin
    redirect_to root_path, alert: 'Acesso negado' unless current_user&.admin?
  end
end
