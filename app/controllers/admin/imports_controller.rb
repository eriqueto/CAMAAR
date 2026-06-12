class Admin::ImportsController < Admin::BaseController
  def new
  end

  def create
    caminho_classes = Rails.root.join('db', 'data', 'classes.json')
    caminho_membros = Rails.root.join('db', 'data', 'class_members.json')
    if File.exist?(caminho_classes) && File.exist?(caminho_membros)
      begin
        SigaaImportService.processar(caminho_classes, caminho_membros)
        redirect_to admin_root_path, notice: "Dados do SIGAA importados e cruzados com sucesso a partir dos arquivos locais!"
      rescue StandardError => e
        redirect_to new_admin_import_path, alert: "Erro ao processar os arquivos JSON: #{e.message}"
      end
    else
      redirect_to new_admin_import_path, alert: "Arquivos não encontrados! Certifique-se de colocar classes.json e class_members.json na pasta db/data/."
    end
  end
end