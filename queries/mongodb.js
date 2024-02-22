use users;

// 1. Usuário cadastrado?
db.users.find({ username: "hyan_batista"}); // Retorna um documento
db.users.find({ username: "jose"}) // Retorna vazio

// 2. O usuário digitou a senha correta?
// Aplicação utiliza o bcrypt (https://bcrypt.online/) e confirma
//	se o hash bate
// Obtemos a senha de um usuário da seguinte forma
db.users.find({ username: "gabriel_augusto"}, {_id: 0, password: 1});

// 3. Qual a data de nascimento de um usuário?
db.users.find({ username: "henrique_sabino"}, {_id: 0, dob: 1});

// 4. Quando esse usuário entrou na plataforma?
db.users.find({username: 'moesio_filho'}, {_id: 0, creation_date: 1});

// 5. Quantas coleções esse usuário possui?
db.users.find({username: 'samuel_vidal'}, {_id: 0, n_collections: 1});

// 6. Quantos jogos esse usuário possui?
db.users.find({username: 'samuel_vidal'}, {_id: 0, n_games: 1});

// 7. Quantos amigos na plataforma esse usuário possui?
db.users.find({username: 'hyan_batista'}, {_id: 0, n_friends: 1});

// 8. Qual a biografia desse usuário?
db.users.find({username: 'hyan_batista'}, {_id: 0, biography: 1});

