USE collections;

// 1. Quais coleções esse usuário possui?
SELECT * FROM collection WHERE owner_username='samuel_vidal';

// 2. Quais jogos fazem parte dessa coleção?
SELECT g.name FROM game g WHERE g.id IN (SELECT cg.game_id FROM collection_has_game cg WHERE cg.collection_id = 5);

SELECT cg.collection_id, g.id, g.name, cg.added_at FROM collection_has_game cg INNER JOIN game g ON g.id = cg.game_id WHERE cg.collection_id = 5;

// 3. Quais jogos tem nome similar a X?
SELECT g.name FROM game g WHERE g.name LIKE "DARK SOULS%";

// 4. Quais gêneros do jogo X?
SELECT g.name FROM genre g WHERE g.id IN (SELECT ghg.genre_id FROM game_has_genre ghg WHERE ghg.game_id = 5288);

// 5. Em quais plataformas o jogo X está disponível?
SELECT platform FROM game_runs_on WHERE game_id = 5288;

// 6. Em quais lojas o jogo X é vendido?
SELECT s.name, s.website FROM store s WHERE s.id IN (SELECT store_id FROM game_available_at WHERE game_id = 169);

// 7. Quais metadados do jogo X?
SELECT * FROM game WHERE id = 169;

// 8. Qual website da loja X?
SELECT * FROM store WHERE store.name LIKE '%steam%';

