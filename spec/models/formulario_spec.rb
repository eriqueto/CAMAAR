require 'rails_helper'

RSpec.describe Formulario, type: :model do
  before(:each) do
    # Criando os dados base necessários para testar o formulário
    @pessoa = Pessoa.create!(usuario: 'prof_test', password: '123', password_confirmation: '123')
    @docente = Docente.create!(pessoa: @pessoa)
    @disciplina = Disciplina.create!(codigo: 'CIC0105', nome: 'Engenharia de Software')
    @turma = Turma.create!(codigo: 'TA', disciplina: @disciplina, docente: @docente)
    @template = Template.create!(nome: 'Template Sprint 3', pessoa: @pessoa)
  end

  describe 'Criação e Validações' do
    context 'Happy Path' do
      it 'cria um formulário válido associado a uma turma e um template' do
        formulario = Formulario.new(turma: @turma, template: @template, status: :aberto)
        
        expect(formulario).to be_valid
        expect(formulario.save).to be true
        expect(formulario.aberto?).to be true
      end

      it 'cria um formulário sem template (pois o belongs_to é optional)' do
        formulario = Formulario.new(turma: @turma, status: :fechado)
        
        expect(formulario).to be_valid
        expect(formulario.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválido tentar criar um formulário sem uma turma associada' do
        formulario = Formulario.new(template: @template, status: :aberto)
        
        expect(formulario).not_to be_valid
        expect(formulario.errors[:turma]).to be_present
      end
    end
  end

  describe 'Gerenciamento de Status (Enum)' do
    context 'Happy Path' do
      it 'permite transitar o status de aberto para fechado' do
        formulario = Formulario.create!(turma: @turma, status: :aberto)
        
        expect(formulario.aberto?).to be true
        
        formulario.fechado!
        
        expect(formulario.status).to eq('fechado')
        expect(formulario.fechado?).to be true
      end
    end
  end
end