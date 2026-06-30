class Admin::ResultadosController < Admin::BaseController
  def index
    @formularios = Formulario.includes(:turma, :template).all
  end

  def show
    @formulario = Formulario.find(params[:id])
  end

  def exportar_csv
    @formulario = Formulario.includes(questoes: { respostas: { discente: :pessoa } }).find(params[:id])

    if @formulario.status != 'fechado'
      redirect_to admin_resultados_path, alert: "Relatórios só podem ser gerados para avaliações encerradas."
      return
    end

    send_data gerar_csv(@formulario), filename: "relatorio_turma_#{@formulario.turma.codigo}.csv", type: "text/csv"
  end

  private

  def gerar_csv(formulario)
    CSV.generate(headers: true) do |csv|
      csv << ["Aluno", "Matrícula", "Questão", "Resposta"]
      formulario.questoes.each { |questao| linhas_da_questao(questao).each { |linha| csv << linha } }
    end
  end

  def linhas_da_questao(questao)
    questao.respostas.map do |resposta|
      [resposta.discente.pessoa.nome, resposta.discente.matricula, questao.enunciado, resposta.conteudo]
    end
  end
end