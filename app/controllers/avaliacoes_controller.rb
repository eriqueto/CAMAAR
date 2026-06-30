class AvaliacoesController < ApplicationController
  before_action :require_login

  def index
    @formularios = current_pessoa.discente ? formularios_para_discente(current_pessoa.discente) : []
  end

  private

  def formularios_para_discente(discente)
    turmas_ids = discente.turma_discentes.pluck(:turma_id)
    disponiveis = Formulario.where(turma_id: turmas_ids, status: :aberto)

    disponiveis
      .where.not(id: formularios_respondidos_ids(discente))
      .includes(turma: [:disciplina, { docente: :pessoa }])
      .order(created_at: :desc)
  end

  def formularios_respondidos_ids(discente)
    Resposta.where(discente: discente).joins(:questao).pluck('questoes.formulario_id').uniq
  end
end