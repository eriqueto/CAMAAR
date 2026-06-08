# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_06_08_224406) do
  create_table "discentes", force: :cascade do |t|
    t.string "curso"
    t.string "matricula"
    t.string "pessoa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_discentes_on_pessoa_id"
  end

  create_table "disciplinas", primary_key: "codigo", id: :string, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docentes", force: :cascade do |t|
    t.string "departamento"
    t.string "pessoa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_docentes_on_pessoa_id"
  end

  create_table "pessoas", primary_key: "usuario", id: :string, force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "formacao"
    t.string "ocupacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ehAdm"
  end

  create_table "turma_discentes", force: :cascade do |t|
    t.integer "discente_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discente_id"], name: "index_turma_discentes_on_discente_id"
    t.index ["turma_id"], name: "index_turma_discentes_on_turma_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo"
    t.string "horario"
    t.string "semestre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "docente_id", null: false
    t.string "disciplina_id", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
    t.index ["docente_id"], name: "index_turmas_on_docente_id"
  end

  add_foreign_key "discentes", "pessoas"
  add_foreign_key "docentes", "pessoas"
  add_foreign_key "turma_discentes", "discentes"
  add_foreign_key "turma_discentes", "turmas"
  add_foreign_key "turmas", "disciplinas", primary_key: "codigo"
  add_foreign_key "turmas", "docentes"
end
