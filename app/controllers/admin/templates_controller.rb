class Admin::TemplatesController < Admin::BaseController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    @templates = current_pessoa.templates.includes(:template_questoes)
  end

  def show
    
  end

  def new
    @template = Template.new
    @template.template_questoes.build 
  end

  def create
    @template = current_pessoa.templates.build(template_params)

    if @template.save
      redirect_to admin_templates_path, notice: 'Template criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @template.template_questoes.build if @template.template_questoes.empty?
  end

  def update
    if @template.update(template_params)
      redirect_to admin_templates_path, notice: 'Template atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_templates_path, notice: 'Template excluído com sucesso.'
  end

  private

  def set_template
    @template = current_pessoa.templates.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_templates_path, alert: 'Template não encontrado.'
  end
  
  def template_params
    params.require(:template).permit(
      :nome,
      template_questoes_attributes: [:id, :enunciado, :tipo_resposta, :opcoes, :_destroy]
    )
  end
end