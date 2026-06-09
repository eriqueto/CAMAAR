class Discente < ApplicationRecord
  belongs_to :pessoa
  has_many :turma_discentes
  has_many :turmas, through: :turma_discentes
end
