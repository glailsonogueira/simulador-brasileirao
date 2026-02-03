class PasswordResetMailer < ApplicationMailer
  default from: 'noreply@simuladorbrasileiro.com.br'
  
  def reset_email(user)
    @user = user
    @reset_url = edit_password_reset_url(@user.reset_password_token)
    
    mail(
      to: @user.email,
      subject: 'Redefinição de Senha - Simulador Brasileirão'
    )
  end
end