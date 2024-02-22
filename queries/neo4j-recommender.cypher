// Primeiro, obtemos a lista dos top K gêneros da coleção
MATCH (root:User {name: "henrique_sabino"})-[has_collection:HAS_COLLECTION]->(collection:Collection {name: "História"})-[has_game:HAS_GAME]->(game:Game)-[has_genre:HAS_GENRE]->(genre:Genre)
WITH genre.name AS genre_name, COUNT(genre.name) AS occurrences
WHERE occurrences > 4
MATCH (:User {name: "henrique_sabino"})-[:HAS_COLLECTION]->(collection:Collection {name: "História"})-[has_game:HAS_GAME]->(game:Game)-[has_genre:HAS_GENRE]->(genre:Genre {name: genre_name})
RETURN collection, has_game, game, has_genre, genre


// Depois, buscamos na coleção de amigos os jogos que possuem esses K gêneros
MATCH (root:User {name: "henrique_sabino"})-[friends:FRIEND]-(friend:User)-[has_collection:HAS_COLLECTION]->(collection:Collection)-[has_game:HAS_GAME]->(recommendation:Game)
MATCH (recommendation)-[hg1:HAS_GENRE]->(g1:Genre {name: "Adventure"})
MATCH (recommendation)-[hg2:HAS_GENRE]->(g2:Genre {name: "Story Rich"})
MATCH (recommendation) WHERE NOT (root)-[:HAS_COLLECTION]->(:Collection)-[:HAS_GAME]->(recommendation)
RETURN root, friends, friend, has_collection, collection, has_game, recommendation, hg1, hg2, g1, g2
LIMIT 4

