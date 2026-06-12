require 'csv'

class Admin::ResultadosController < Admin::BaseController
  def index
    @formularios = Formulario.includes(:turma, :template).all
  end

  def show
    @formulario = Formulario.includes(questoes: :respostas).find(params[:id])
  end

  def exportar_csv
    @formulario = Formulario.includes(questoes: { respostas: { discente: :pessoa } }).find(params[:id])

    csv_data = CSV.generate(headers: true) do |csv|
      questoes = @formulario.questoes
      header = ["Nome do Aluno", "Matrícula"] + questoes.map(&:enunciado)
      csv << header
      respostas_por_aluno = Resposta.joins(:questao).where(questoes: { formulario_id: @formulario.id }).group_by(&:discente)
      respostas_por_aluno.each do |discente, respostas|
        linha = [discente.pessoa.nome, discente.matricula]
        questoes.each do |questao|
          resposta_do_aluno = respostas.find { |r| r.questao_id == questao.id }
          linha << (resposta_do_aluno ? resposta_do_aluno.conteudo : "Não respondeu")
        end
        csv << linha
      end
    end
    
    send_data csv_data, filename: "resultados_turma_#{@formulario.turma.codigo}.csv", type: "text/csv"
  end
end