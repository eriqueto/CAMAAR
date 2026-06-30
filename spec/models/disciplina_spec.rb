require 'rails_helper'

RSpec.describe Disciplina, type: :model do
  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'cria uma disciplina válida com código primário' do
        disciplina = Disciplina.new(codigo: 'CIC0097', nome: 'Bancos de Dados')
        
        expect(disciplina).to be_valid
        expect(disciplina.save).to be true
      end
    end
  end
end