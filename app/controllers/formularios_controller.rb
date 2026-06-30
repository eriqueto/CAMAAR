class FormulariosController < ApplicationController
  before_action :require_login

  def show
    @formulario = Formulario.includes(:questoes).find(params[:id])
    @questoes = @formulario.questoes
  end

  def responder
    @formulario = Formulario.find(params[:id])
    respostas_params = params[:respostas] || {}

    if respostas_invalidas?(respostas_params)
      redirect_to formulario_path(@formulario), alert: "Erro: Todos os campos obrigatórios precisam ser preenchidos."
      return
    end

    salvar_respostas(respostas_params)
    redirect_to root_path, notice: "Avaliação enviada com sucesso! Obrigado pela sua participação."
  rescue StandardError => e
    redirect_to formulario_path(@formulario), alert: "Erro ao enviar avaliação. Tente novamente."
  end

  private

  def respostas_invalidas?(respostas_params)
    respostas_params.blank? || respostas_params.values.any?(&:blank?)
  end

  def salvar_respostas(respostas_params)
    ActiveRecord::Base.transaction do
      respostas_params.each do |questao_id, conteudo|
        Resposta.create!(
          questao_id: questao_id,
          discente_id: current_pessoa.discente.id,
          conteudo: conteudo
        )
      end
    end
  end
end