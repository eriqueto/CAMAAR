class Correcao2 < ActiveRecord::Migration[7.1]
  def change
    rename_column :pessoas, :password, :password_digest
    remove_foreign_key :questaos, :formularios
    remove_foreign_key :resposta, :discentes
    remove_foreign_key :resposta, :questaos
    remove_foreign_key :template_questaos, :templates
    rename_table :questaos, :questoes
    rename_table :template_questaos, :template_questoes
    rename_table :resposta, :respostas
    add_foreign_key :questoes, :formularios
    add_foreign_key :respostas, :discentes
    add_foreign_key :respostas, :questoes
    add_foreign_key :template_questoes, :templates
    add_foreign_key :templates, :pessoas, column: :pessoa_id, primary_key: :usuario
  end
end