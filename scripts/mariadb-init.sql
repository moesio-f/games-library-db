-- Create tables and relationships
USE collections;

CREATE TABLE `collection` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(64),
  `owner_username` VARCHAR(128),
  `description` VARCHAR(512),
  `created_at` DATE,
  `last_updated_at` DATE
);

CREATE TABLE `game` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(256),
  `release_date` DATE,
  `description` VARCHAR(1024)
);

CREATE TABLE `genre` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(256)
);

CREATE TABLE `store` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(128),
  `website` VARCHAR(256),
  `logo` VARCHAR(512)
);

CREATE TABLE `game_has_genre` (
  `game_id` INT,
  `genre_id` INT,
  PRIMARY KEY (`game_id`, `genre_id`),
  FOREIGN KEY (`game_id`) REFERENCES game (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`genre_id`) REFERENCES genre (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE `game_available_at` (
  `game_id` int,
  `store_id` int,
  PRIMARY KEY (`game_id`, `store_id`),
  FOREIGN KEY (`game_id`) REFERENCES game (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`store_id`) REFERENCES store (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `game_runs_on` (
  `game_id` int,
  `platform` ENUM ('pc', 'xbox', 'ps', 'mobile', 'switch'),
  PRIMARY KEY (`game_id`, `platform`),
  FOREIGN KEY (`game_id`) REFERENCES game (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `collection_has_game` (
  `collection_id` int,
  `game_id` int,
  `added_at` date,
  PRIMARY KEY (`collection_id`, `game_id`),
  FOREIGN KEY (`collection_id`) REFERENCES collection (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (`game_id`) REFERENCES game (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Data import

LOAD DATA INFILE '/tmp/data/game.csv'
INTO TABLE `game`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/collection.csv'
INTO TABLE `collection`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/genre.csv'
INTO TABLE `genre`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/store.csv'
INTO TABLE `store`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/game_has_genre.csv'
INTO TABLE `game_has_genre`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/game_available_at.csv'
INTO TABLE `game_available_at`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/game_runs_on.csv'
INTO TABLE `game_runs_on`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/tmp/data/collection_has_game.csv'
INTO TABLE `collection_has_game`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
