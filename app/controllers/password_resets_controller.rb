class PasswordResetsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :edit, :update]
  
  # GET /password_resets/new
  def new
  end
  
  # POST /password_resets
  def create
    @user = User.find_by(email: params[:email]&.downcase&.strip)
    
    if @user
      @user.generate_password_reset_token
      PasswordResetMailer.reset_email(@user).deliver_now
      redirect_to login_path, notice: "Instruções para redefinir sua senha foram enviadas para #{params[:email]}"
    else
      flash.now[:alert] = "Email não encontrado"
      render :new, status: :unprocessable_entity
    end
  end
  
  # GET /password_resets/:token/edit
  def edit
    @user = User.find_by_password_reset_token(params[:token])
    
    unless @user && @user.password_reset_token_valid?
      redirect_to new_password_reset_path, alert: "Link de redefinição de senha inválido ou expirado"
    end
  end
  
  # PATCH /password_resets/:token
  def update
    @user = User.find_by_password_reset_token(params[:token])
    
    unless @user && @user.password_reset_token_valid?
      redirect_to new_password_reset_path, alert: "Link de redefinição de senha inválido ou expirado"
      return
    end
    
    if params[:user][:password].blank?
      flash.now[:alert] = "A senha não pode estar em branco"
      render :edit, status: :unprocessable_entity
      return
    end
    
    if params[:user][:password] != params[:user][:password_confirmation]
      flash.now[:alert] = "A confirmação de senha não corresponde"
      render :edit, status: :unprocessable_entity
      return
    end
    
    if @user.reset_password(params[:user][:password])
      redirect_to login_path, notice: "Senha redefinida com sucesso!"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end
end