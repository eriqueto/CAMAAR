class Docente < ApplicationRecord
  belongs_to :pessoa
  has_many :turmas
end
