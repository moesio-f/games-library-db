all: down build up

build:
	@docker compose build

up:
	@docker compose up -d

down:
	@docker compose down

mongo:
	@docker compose exec -it mongodb mongosh "mongodb://root:root@localhost:27017"

mariadb:
	@docker compose exec -it mariadb mariadb -uroot -proot

neo4j:
	@docker compose exec -it neo4j cypher-shell -u neo4j -p root
