class Account::PasswordsController < ApplicationController
  before_action :require_login
  
  # GET /account/password/edit
  def edit
  end
  
  # PATCH /account/password
  def update
    if params[:current_password].blank?
      flash.now[:alert] = "Digite sua senha atual"
      render :edit, status: :unprocessable_entity
      return
    end
    
    unless current_user.authenticate(params[:current_password])
      flash.now[:alert] = "Senha atual incorreta"
      render :edit, status: :unprocessable_entity
      return
    end
    
    if params[:password].blank?
      flash.now[:alert] = "A nova senha não pode estar em branco"
      render :edit, status: :unprocessable_entity
      return
    end
    
    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = "A confirmação de senha não corresponde"
      render :edit, status: :unprocessable_entity
      return
    end
    
    current_user.password = params[:password]
    current_user.force_password_change = false
    
    if current_user.save
      redirect_to root_path, notice: "Senha alterada com sucesso!"
    else
      flash.now[:alert] = current_user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end
end
