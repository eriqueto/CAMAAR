class Admin::FormulariosController < Admin::BaseController
  def new
    @templates = Template.all
    @turmas = Turma.includes(:disciplina, :docente).all 
  end

  def create
    template = Template.find(params[:template_id])
    turmas_ids = params[:turma_ids]

    if turmas_ids.blank?
      flash[:alert] = "Você precisa selecionar pelo menos uma turma."
      redirect_to new_admin_formulario_path and return
    end

    ActiveRecord::Base.transaction do
      turmas_ids.each do |turma_id|
        formulario = Formulario.create!(turma_id: turma_id, template: template, status: :aberto)
        template.template_questoes.each do |tq|
          formulario.questoes.create!(
            enunciado: tq.enunciado,
            tipo_resposta: tq.tipo_resposta,
            opcoes: tq.opcoes
          )
        end
      end
    end

    redirect_to admin_root_path, notice: "Formulários baseados no template '#{template.nome}' foram enviados com sucesso!"
  
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Ocorreu um erro ao gerar os formulários: #{e.message}"
    redirect_to new_admin_formulario_path
  end
end