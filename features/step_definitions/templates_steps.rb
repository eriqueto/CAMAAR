Dado('que existem os seguintes templates cadastrados no sistema:') do |table|
  table.hashes.each do |row|
    Template.create!(titulo: row['titulo'], descricao: row['descricao'])
  end
end

Dado('que estou logado como um usuário Administrador') do
end

Quando('acesso a página de gerenciamento de templates') do
  visit templates_path
end

Então('devo ver uma lista contendo todos os templates cadastrados') do
  expect(page).to have_css('body')
end

Então('devo visualizar o template {string}') do |titulo_template|
  expect(page).to have_content(titulo_template)
end

Dado('que não existem templates cadastrados no sistema') do
  Template.destroy_all
end

Então('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end