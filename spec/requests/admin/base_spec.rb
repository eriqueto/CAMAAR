require 'rails_helper'

RSpec.describe "Admin::Bases", type: :request do
  before(:each) do
    @aluno = Pessoa.create!(
      usuario: 'richarlison', 
      email: 'pombo@unb.br', 
      nome: 'Richarlison de Andrade', 
      password: '123', 
      password_confirmation: '123', 
      admin: false
    )
  end

  describe "Filtro de Segurança (require_admin)" do
    context "Sad Path" do
      it "bloqueia acesso de discentes em qualquer rota protegida pelo BaseController" do
        #faz o login como aluno
        post login_path, params: { login: 'pombo@unb.br', password: '123' }
        get admin_root_path
        #verifica se a regra require_admin atuou bloqueando o acesso
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso negado.")
      end
    end
  end
end