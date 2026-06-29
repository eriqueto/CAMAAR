require 'rails_helper'

RSpec.describe Pessoa, type: :model do
  describe "Validações" do
    it "é inválido sem email" do
      pessoa = Pessoa.new(usuario: "joao123", password: "123", nome: "Joao Teste", email: nil)
      expect(pessoa).not_to be_valid
      expect(pessoa.errors[:email]).to include("can't be blank")
    end
  end
end