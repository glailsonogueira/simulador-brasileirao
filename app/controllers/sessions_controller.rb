class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Login realizado com sucesso!'
      else
        flash.now[:alert] = 'Sua conta está desativada. Entre em contato com o administrador.'
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso!'
  end
end
