// 1. Quais são amigos do usuário X?
// No exemplo abaixo, não estamos nos preocupando com a direção
#	de quem começou a amizade
MATCH (u1:User {name: "hyan_batista"})-[r:FRIEND]-(u2:User)
RETURN u1, r, u2;

// 2. Quais são os principais gêneros da coleção X do usuário Y?
// Podemos mudar levemente essa query para mostrar o grafo
MATCH (collection:Collection {id: 0})-[has_game:HAS_GAME]-(game:Game)-[has_genre:HAS_GENRE]-(genre:Genre)
RETURN collection.name AS collection, genre.name AS genre, COUNT(genre.name) AS occurrences
ORDER BY occurrences DESC
LIMIT 5

// 3. Quais jogos de uma coleção também estão presentes em coleções dos amigos?
MATCH (u1:User {name: 'gabriel_augusto'})-[hc1:HAS_COLLECTION]->(c1:Collection {id: 0})-[hg1:HAS_GAME]->(g:Game)<-[hg2:HAS_GAME]-(c2:Collection)<-[hc2:HAS_COLLECTION]-(u2:User)-[:FRIEND]-(u1)
WHERE c2.id <> c1.id
RETURN u1, hc1, c1, hg1, g, hg2, c2, hc2, u2

MATCH (u1:User)-[hc1:HAS_COLLECTION]->(c1:Collection)-[hg1:HAS_GAME]->(g1:Game)<-[hg2:HAS_GAME]-(c2:Collection)<-[hc2:HAS_COLLECTION]-(u2:User)-[f:FRIEND]-(u1)
RETURN u1, hc1, c1, hg1, g1, hg2, c2, hc2, u2, f

// 4. Dada uma coleção de um usuário, quais coleções de amigos são mais similares?
// Podemos responder de algumas formas, vamos começar com o maior overlap de jogos
// entre coleções
// A primeira query visualiza o grafo e a 2ª traz a resposta
MATCH (u1:User {name: "samuel_vidal"})-[hc1:HAS_COLLECTION]->(c1:Collection {name: "Mundo Aberto"})-[hg1:HAS_GAME]->(g1:Game)<-[hg2:HAS_GAME]-(c2:Collection)<-[hc2:HAS_COLLECTION]-(u2:User)-[f:FRIEND]-(u1)
MATCH (c2)-[hg3:HAS_GAME]->(g2:Game)
RETURN u1, hc1, c1, hg1, g1, hg2, c2, hc2, u2, f, hg3, g2

MATCH (u1:User {name: "samuel_vidal"})-[hc1:HAS_COLLECTION]->(c1:Collection {name: “Mundo Aberto”})-[hg1:HAS_GAME]->(g1:Game)<-[hg2:HAS_GAME]-(c2:Collection)<-[hc2:HAS_COLLECTION]-(u2:User)-[f:FRIEND]-(u1)
RETURN u2.name AS friend, c2.name AS collection, COUNT(g1) AS n_common_games
ORDER BY n_common_games DESC

// 5. Dada uma coleção, quais são os jogos similares presentes em coleções de amigos?
// Nesse caso, vamos considerar jogos similares àqueles que possuem a maior quantidade de gêneros/tags em comum

// Primeiro, obtemos a lista dos top K gêneros da coleção
MATCH (root:User {name: "henrique_sabino"})-[has_collection:HAS_COLLECTION]->(collection:Collection {name: "História"})-[has_game:HAS_GAME]->(game:Game)-[has_genre:HAS_GENRE]->(genre:Genre)
RETURN genre.name as genre, COUNT(genre.name) AS occurrences
ORDER BY occurrences DESC
LIMIT 2

// Depois, buscamos na coleção de amigos os jogos que possuem esses K gêneros
MATCH (root:User {name: "henrique_sabino"})-[friends:FRIEND]-(friend:User)-[has_collection:HAS_COLLECTION]->(collection:Collection)-[has_game:HAS_GAME]->(recommendation:Game)
MATCH (recommendation)-[hg1:HAS_GENRE]->(g1:Genre {name: "Adventure"})
MATCH (recommendation)-[hg2:HAS_GENRE]->(g2:Genre {name: "Story Rich"})
MATCH (recommendation) WHERE NOT (root)-[:HAS_COLLECTION]->(:Collection)-[:HAS_GAME]->(recommendation)
RETURN root, friends, friend, has_collection, collection, has_game, recommendation, hg1, hg2, g1, g2
LIMIT 4


