class Admin::FormulariosController < Admin::BaseController
  def new
    @templates = Template.all
    @turmas = if departamento_admin.present?
                Turma.includes(:disciplina, :docente).joins(:docente).where(docentes: { departamento: departamento_admin })
              else
                Turma.includes(:disciplina, :docente).all
              end
  end

  def create
    turmas_ids = params[:turma_ids]
    template = template_valido(turmas_ids)
    return unless template

    criar_formularios_para_turmas(turmas_ids, template)
    redirect_to admin_root_path, notice: "Formulário criado e vinculado às turmas com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Ocorreu um erro ao gerar os formulários: #{e.message}"
    redirect_to new_admin_formulario_path
  end

  private

  def departamento_admin
    current_pessoa.docente&.departamento
  end

  # Roda as validações de template/turmas em sequência; redireciona e retorna
  # nil no primeiro erro encontrado, ou o Template válido em caso de sucesso.
  def template_valido(turmas_ids)
    return redirect_sem_template && nil if params[:template_id].blank?

    template = Template.find(params[:template_id])
    return redirect_sem_questoes && nil if template.template_questoes.empty?
    return redirect_sem_turmas && nil if turmas_ids.blank?
    return redirect_turmas_nao_autorizadas && nil if turmas_invalidas?(turmas_ids)

    template
  end

  def turmas_invalidas?(turmas_ids)
    return false unless departamento_admin.present?

    Turma.joins(:docente).where(id: turmas_ids).where.not(docentes: { departamento: departamento_admin }).any?
  end

  def criar_formularios_para_turmas(turmas_ids, template)
    ActiveRecord::Base.transaction do
      turmas_ids.each do |turma_id|
        formulario = Formulario.create!(turma_id: turma_id, template: template, status: :aberto)
        template.template_questoes.each do |tq|
          formulario.questoes.create!(enunciado: tq.enunciado, tipo_resposta: tq.tipo_resposta, opcoes: tq.opcoes)
        end
      end
    end
  end

  def redirect_sem_template
    flash[:alert] = "Obrigatório: O formulário deve ser baseado em um template existente."
    redirect_to new_admin_formulario_path
  end

  def redirect_sem_questoes
    flash[:alert] = "O formulário precisa ter ao menos uma pergunta antes de ser publicado."
    redirect_to new_admin_formulario_path
  end

  def redirect_sem_turmas
    flash[:alert] = "Você precisa selecionar pelo menos uma turma."
    redirect_to new_admin_formulario_path
  end

  def redirect_turmas_nao_autorizadas
    flash[:alert] = "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."
    redirect_to admin_root_path
  end
end