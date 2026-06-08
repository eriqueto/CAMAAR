class Turma < ApplicationRecord
    belongs_to :disciplina
    belongs_to :docente
    has_many :turma_discentes
    has_many :discentes, through: :turma_discentes
end
