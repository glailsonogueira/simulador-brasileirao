class OmniauthCallbacksController < ApplicationController
  skip_before_action :require_login
  
  def google_oauth2
    auth = request.env['omniauth.auth']
    
    # Tentar encontrar por provider/uid primeiro
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    
    # Se não encontrar, buscar por email
    if user.nil?
      user = User.find_by(email: auth.info.email)
      
      if user
        # Email já existe - vincular automaticamente ao Google
        user.update(
          provider: auth.provider,
          uid: auth.uid,
          avatar_url: auth.info.image,
          active: true  # Reativar se estiver inativo
        )
        message = 'Sua conta foi vinculada ao Google com sucesso!'
      else
        # Criar novo usuário
        user = User.create(
          provider: auth.provider,
          uid: auth.uid,
          email: auth.info.email,
          name: auth.info.name,
          avatar_url: auth.info.image,
          password: SecureRandom.hex(32),
          active: true
        )
        message = 'Cadastro realizado com sucesso!'
      end
    else
      # Já estava vinculado
      message = 'Login realizado com sucesso!'
    end
    
    if user.persisted?
      if user.active?
        session[:user_id] = user.id
        redirect_to root_path, notice: message
      else
        redirect_to login_path, alert: 'Sua conta está desativada. Entre em contato com o administrador.'
      end
    else
      redirect_to login_path, alert: 'Erro ao realizar login com Google'
    end
  end
  
  def failure
    redirect_to login_path, alert: 'Falha na autenticação'
  end
end
