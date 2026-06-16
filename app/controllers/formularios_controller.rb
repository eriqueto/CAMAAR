class FormulariosController < ApplicationController
  before_action :require_login

  def show
    @formulario = Formulario.includes(:questoes).find(params[:id])
    @questoes = @formulario.questoes
  end

  def responder
    @formulario = Formulario.find(params[:id])
    respostas_params = params[:respostas] || {}
    ActiveRecord::Base.transaction do
      respostas_params.each do |questao_id, conteudo|
        Resposta.create!(
          questao_id: questao_id,
          discente_id: current_pessoa.discente.id,
          conteudo: conteudo
        )
      end
    end
    redirect_to avaliacoes_path, notice: "Avaliação enviada com sucesso! Obrigado pela sua participação."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to formulario_path(@formulario), alert: "Os seguintes campos são obrigatórios: #{e.record.errors.full_messages.join(', ')}"
  end
end