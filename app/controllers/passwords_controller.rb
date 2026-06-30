class PasswordsController < ApplicationController
  def edit
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to login_path, alert: "Link inválido ou expirado."
  end

  def update
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
    return rejeitar_senhas_divergentes unless senhas_coincidem?

    if @pessoa.update(password_params)
      @pessoa.update(reset_password_token: nil, reset_password_sent_at: nil)
      redirect_to login_path, notice: "Senha definida com sucesso! Agora você pode acessar o Camaar."
    else
      rejeitar_senhas_divergentes
    end
  end

  private

  def senhas_coincidem?
    params[:pessoa][:password] == params[:pessoa][:password_confirmation]
  end

  def rejeitar_senhas_divergentes
    flash.now[:alert] = "As senhas não coincidem"
    render :edit, status: :unprocessable_entity
  end

  def password_params
    params.require(:pessoa).permit(:password, :password_confirmation)
  end
end