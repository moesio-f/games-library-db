// Load games
LOAD CSV WITH HEADERS FROM "file:///game.csv" AS row
CREATE (g:Game {name: row.name, id: toInteger(row.id)});
CREATE INDEX game_id_index FOR (g:Game) ON (g.id);

// Load genres
LOAD CSV WITH HEADERS FROM "file:///genre.csv" AS row
CREATE (g:Genre {name: row.name, id: toInteger(row.id)});
CREATE INDEX genre_id_index FOR (g:Genre) ON (g.id);

// Load users
LOAD CSV WITH HEADERS FROM "file:///collection.csv" AS row
MERGE (u:User {name: row.owner_username});

// Load collections
LOAD CSV WITH HEADERS FROM "file:///collection.csv" AS row
CREATE (c:Collection {name: row.name, id: toInteger(row.id)});
CREATE INDEX collection_id_idex FOR (c:Collection) on (c.id);

// Friend relationships
MATCH (gabriel:User {name: 'gabriel_augusto'}), (hyan:User {name: 'hyan_batista'}), (moesio:User {name: 'moesio_filho'}), (henrique:User {name: 'henrique_sabino'}), (samuel:User {name: 'samuel_vidal'})
CREATE (gabriel)-[:FRIEND]->(moesio)
CREATE (henrique)-[:FRIEND]->(gabriel)
CREATE (gabriel)-[:FRIEND]->(samuel)
CREATE (moesio)-[:FRIEND]->(hyan)
CREATE (hyan)-[:FRIEND]->(henrique)
CREATE (samuel)-[:FRIEND]->(moesio)
CREATE (henrique)-[:FRIEND]->(samuel);

// Game genre relationships
LOAD CSV WITH HEADERS FROM "file:///game_has_genre.csv" AS row
MATCH (game:Game {id: toInteger(row.game_id)}), (genre:Genre {id: toInteger(row.genre_id)})
CREATE (game)-[:HAS_GENRE]->(genre);

// User-collection relationships
LOAD CSV WITH HEADERS FROM "file:///collection.csv" AS row
MATCH (u:User {name: row.owner_username}), (c:Collection {id: toInteger(row.id)})
CREATE (u)-[:HAS_COLLECTION]->(c);

// Collection-game relationships
LOAD CSV WITH HEADERS FROM "file:///collection_has_game.csv" AS row
MATCH (game:Game {id: toInteger(row.game_id)}), (collection:Collection {id: toInteger(row.collection_id)})
CREATE (collection)-[:HAS_GAME]->(game);
