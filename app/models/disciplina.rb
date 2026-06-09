class Disciplina < ApplicationRecord
    has_many :turmas
    self.primary_key = 'codigo'
end
