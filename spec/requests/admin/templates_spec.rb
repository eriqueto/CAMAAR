require 'rails_helper'

RSpec.describe "Admin::Templates", type: :request do
  before(:each) do
    @admin = Pessoa.create!(
      usuario: 'romario', email: 'romario@unb.br', nome: 'Romário Faria', 
      password: '123', password_confirmation: '123', admin: true
    )
    @template = Template.create!(nome: 'Avaliação de Lógica Computacional', pessoa: @admin)
    
    post login_path, params: { login: 'romario@unb.br', password: '123' }
  end

  describe "GET /admin/templates" do
    it "carrega a lista de templates com sucesso" do
      get admin_templates_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/templates" do
    context "Happy Path" do
      it "cria um novo template válido com sucesso" do
        expect {
          post admin_templates_path, params: { template: { nome: 'Feedback de Estrutura de Dados' } }
        }.to change(Template, :count).by(1)
        
        expect(response).to redirect_to(admin_templates_path)
        expect(flash[:notice]).to eq('Template criado com sucesso.')
      end
    end

    context "Sad Path" do
      it "impede a criação de um template sem nome e renderiza o erro" do
        post admin_templates_path, params: { template: { nome: '' } }
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe "DELETE /admin/templates/:id" do
    it "exclui o template do banco de dados" do
      delete admin_template_path(@template)
      
      expect(Template.exists?(@template.id)).to be_falsey
      expect(response).to redirect_to(admin_templates_path)
      expect(flash[:notice]).to eq('Template excluído com sucesso.')
    end
  end
end