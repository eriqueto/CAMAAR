class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    pessoa = Pessoa.find_by(email: params[:login]) || Pessoa.find_by(usuario: params[:login])
    if pessoa && pessoa.authenticate(params[:password])
      session[:pessoa_id] = pessoa.usuario
      if pessoa.admin?
        redirect_to admin_root_path
      else
        redirect_to root_path
      end
    else
      flash.now[:alert] = "E-mail/Matrícula ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:pessoa_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end
end