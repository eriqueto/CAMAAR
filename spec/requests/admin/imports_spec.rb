require 'rails_helper'

RSpec.describe "Admin::Imports", type: :request do
  before(:each) do
    @admin = Pessoa.create!(
      usuario: 'cafu', email: 'cafu@unb.br', nome: 'Marcos Evangelista Cafu', 
      password: '123', password_confirmation: '123', admin: true
    )
    #loga de adm
    post login_path, params: { login: 'cafu@unb.br', password: '123' }
  end

  describe "GET /admin/imports/new" do
    it "retorna sucesso" do
      get new_admin_import_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/imports" do
    context "Happy Path" do
      it "redireciona com sucesso quando os arquivos existem e são processados" do
        allow(File).to receive(:exist?).and_return(true)
        allow(SigaaImportService).to receive(:processar).and_return(true)

        post admin_imports_path
        
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("Importação de dados concluída com sucesso")
      end
    end

    context "Sad Path" do
      it "rejeita a importação se os arquivos não forem encontrados" do
        allow(File).to receive(:exist?).and_return(false)

        post admin_imports_path
        
        expect(response).to redirect_to(new_admin_import_path)
        expect(flash[:alert]).to include("Arquivos não encontrados!")
      end

      it "trata erros lançados pelo SigaaImportService" do
        allow(File).to receive(:exist?).and_return(true)
        allow(SigaaImportService).to receive(:processar).and_raise(StandardError.new("JSON inválido"))

        post admin_imports_path
        
        expect(response).to redirect_to(new_admin_import_path)
        expect(flash[:alert]).to include("Erro ao processar os arquivos JSON: JSON inválido")
      end
    end
  end
end