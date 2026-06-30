class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to is_admin? ? admin_root_path : avaliacoes_path
    end
  end

  def create
    pessoa = autenticar_pessoa(params[:login], params[:password])
    return rejeitar_login unless pessoa

    session[:pessoa_id] = pessoa.usuario
    redirect_to pessoa.admin? ? admin_root_path : avaliacoes_path
  end

  def destroy
    session[:pessoa_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end

  private

  def autenticar_pessoa(login, password)
    pessoa = Pessoa.find_by(email: login) || Pessoa.find_by(usuario: login)
    pessoa if pessoa&.authenticate(password)
  end

  def rejeitar_login
    flash.now[:alert] = "Identificação ou senha inválidos. Verifique suas credenciais e tente novamente."
    render :new, status: :unprocessable_entity
  end
end