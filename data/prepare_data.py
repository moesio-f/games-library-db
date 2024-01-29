"""Script para preparação dos dados
para o banco relacional das coleções.
"""
import json
import random
from datetime import datetime, timedelta
from pathlib import Path

import numpy as np
import pandas as pd
from tqdm import tqdm

# Definindo a seed randômica
random.seed(42)

# Caminhos relativos para os dados
OUT_DIR = Path('relational-db-data')
EPIC_DATASET = Path('epic-games-store/dataset.csv')
STEAM_DATASET_1 = Path('steam-games/games.json')
STEAM_DATASET_2_CORE = Path('steam-store-games/steam.csv')
STEAM_DATASET_2_DESC = Path('steam-store-games/steam_description_data.csv')

# Variável auxiliar que define as coleções
#   de jogos dos usuários do sistema
USERS = [
    {
        "username": "gabriel_augusto",
        "collections": [
            {
                "name": "Ação e Aventura",
                "games": [
                    "Red Dead Redemption 2",
                    "Tomb Raider",
                    "The Forest",
                    "The Witcher® 3: Wild Hunt",
                    "Horizon Zero Dawn™ Complete Edition"
                ]
            }
        ],
    },
    {
        "username": "hyan_batista",
        "collections": [
            {
                "name": "Spider-Man",
                "games": [
                    "Marvel’s Spider-Man Remastered"
                ]
            },
            {
                "name": "Corrida",
                "games": [
                    "Forza Horizon 4",
                    "Forza Horizon 5",
                    "Forza Motorsport"
                ]
            },
            {
                "name": "Resident Evil",
                "games": [
                    "Resident Evil 2",
                    "Resident Evil 3",
                    "Resident Evil 4",
                    "Resident Evil Village",
                    "Resident Evil 7 Biohazard",
                ]
            }
        ],
    },
    {
        "username": "moesio_filho",
        "collections": [
            {
                "name": "Resident Evil",
                "games": [
                    "Resident Evil 2",
                    "Resident Evil Village",
                    "Resident Evil 7 Biohazard",
                ]
            },
            {
                "name": "RPG",
                "games": [
                    "Baldur's Gate 3",
                    "Monster Hunter: World",
                    "The Witcher® 3: Wild Hunt",
                    "The Elder Scrolls V: Skyrim",
                    "Hades",
                    "DARK SOULS™ III",
                    "ELDEN RING"
                ]
            }
        ],
    },
    {
        "username": "henrique_sabino",
        "collections": [
            {
                "name": "Metroidvania & Hack and Slash",
                "games": [
                    "Hollow Knight",
                    "Dead Cells",
                    "Hades",
                ]
            },
            {
                "name": "História",
                "games": [
                    "God of War",
                    "Marvel’s Spider-Man Remastered",
                    "Baldur's Gate 3",
                    "Red Dead Redemption 2",
                    "Outer Wilds"
                ]
            }
        ],
    },
    {
        "username": "samuel_vidal",
        "collections": [
            {
                "name": "História",
                "games": [
                    "God of War",
                    "The Last of Us™ Part I"
                ]
            },
            {
                "name": "Souls-Like",
                "games": [
                    "Blasphemous",
                    "DARK SOULS™: REMASTERED",
                    "DARK SOULS™ II: Scholar of the First Sin",
                    "Lies of P"
                ]
            },
            {
                "name": "Sobrevivência",
                "games": [
                    "The Forest",
                    "Sons Of The Forest",
                    "Metro Exodus"
                ]
            },
            {
                "name": "Mundo Aberto",
                "games": [
                    "No Man's Sky",
                    "Red Dead Redemption 2",
                    "Grand Theft Auto V"
                ]
            }
        ],
    }
]


def concat_steam_datasets() -> pd.DataFrame:
    # Load first dataset
    with STEAM_DATASET_1.open('r') as f:
        df_1 = pd.DataFrame(json.load(f)).T

    # Load and join the 2nd dataset
    df_2 = pd.read_csv(STEAM_DATASET_2_CORE)
    df_3 = pd.read_csv(STEAM_DATASET_2_DESC)
    df_3 = df_3.rename(columns=dict(steam_appid='appid',
                                    short_description='description'))
    df_2 = pd.merge(df_2, df_3, on='appid', how='inner')
    del df_3

    # Data normalization for dataset 1
    df_1.genres = df_1.genres.map(lambda genres: ';'.join(genres))
    df_1.tags = df_1.tags.map(lambda entry: ';'.join(entry.keys())
                              if isinstance(entry, dict) else '')
    df_1.genres = (df_1.genres + ';' + df_1.tags).str.strip()
    df_1 = df_1.rename(columns={'short_description': 'description'})

    # Data normalization for dataset 2
    df_2.genres = (df_2.genres + ';' + df_2.categories).str.strip()

    # Select subset of data
    df_1 = df_1[['name', 'release_date', 'description', 'genres']]
    df_2 = df_2[['name', 'release_date', 'description', 'genres']]

    # Concatenate DataFrames
    df = pd.concat([df_1, df_2], ignore_index=True)
    del df_1, df_2

    # Remove duplicated genres
    df.genres = df.genres.map(lambda genres: ';'.join(set(genres.split(';'))))

    # Remove empty genres
    df = df[df.genres != '']

    # Remove duplicated genre delimitator
    df.genres = df.genres.str.replace(r';+', ';', regex=True)

    # Normalize leading/trailing genre delimitator
    df.genres = df.genres.str.replace(r'^;', '', regex=True)
    df.genres = df.genres.str.strip(';')

    # Clear duplicates
    df = df.sort_values(by='genres',
                        ascending=False,
                        key=lambda s: s.map(len))
    df = df.drop_duplicates('name', keep='first')

    # Convert dates
    df = df.astype({'release_date': 'datetime64[ns]'})

    # Drop na
    df = df.dropna()

    # Reset index
    df = df.reset_index(drop=True)

    return df


def get_games_df() -> pd.DataFrame:
    # Load Steam dataset
    steam_df = concat_steam_datasets()

    # Load and normalize Epic dataset
    epic_df = pd.read_csv(EPIC_DATASET,
                          usecols=['name', 'date release', 'genres of games'])
    epic_df = epic_df.rename(columns={
        'date release': 'release_date',
        'genres of games': 'genres'
    })
    epic_df['description'] = ''
    epic_df.release_date = pd.to_datetime(epic_df.release_date,
                                          errors='coerce',
                                          format='%m/%d/%y')
    epic_df = epic_df.dropna()

    # Use heuristic to infer genres from epic dataset
    steam_genres = np.unique(';'.join(steam_df.genres).split(';'))
    epic_df.genres = epic_df.genres.map(
        lambda g: ';'.join(sg for sg in steam_genres if sg in g))
    epic_df = epic_df[epic_df.genres != '']

    # Reorganize column order in Epic dataset
    epic_df = epic_df[['name', 'release_date', 'description', 'genres']]

    # Concatenate DataFrames
    epic_only = epic_df[~epic_df.name.isin(steam_df.name)]
    df = pd.concat([steam_df, epic_only], ignore_index=True)
    df['in_steam'] = df.name.isin(steam_df.name)
    df['in_epic'] = df.name.isin(epic_df.name)

    # Drop duplicates
    df = df.drop_duplicates('name', keep='first')

    # Create unique IDs
    df = df.reset_index(drop=True).reset_index(names='id')

    # Return DataFrame
    return df


def game_table(games_df: pd.DataFrame):
    return games_df[['id', 'name', 'release_date', 'description']].copy()


def genre_table(games_df: pd.DataFrame) -> pd.DataFrame:
    genres = np.unique(';'.join(games_df.genres).split(';'))
    genres = np.sort(genres)
    assert '' not in genres

    return pd.DataFrame({
        'id': list(range(len(genres))),
        'name': genres
    })


def game_has_genre_table(games_df: pd.DataFrame,
                         genres_df: pd.DataFrame) -> pd.DataFrame:
    data = []
    for _, row in tqdm(genres_df.iterrows(),
                       desc='Genres',
                       total=len(genres_df)):
        for _, game in tqdm(games_df.iterrows(),
                            desc='Games',
                            total=len(games_df)):
            if row['name'] in game['genres']:
                data.append({'game_id': game['id'],
                             'genre_id': row['id']})

    return pd.DataFrame(data)


def game_available_at_table(games_df: pd.DataFrame) -> pd.DataFrame:
    data = []

    for _, row in tqdm(games_df.iterrows(),
                       desc='Games',
                       total=len(games_df)):
        for cond, sid in zip([row.in_steam, row.in_epic],
                             [0, 1]):
            if cond:
                data.append({'game_id': row.id,
                             'store_id': sid})

    return pd.DataFrame(data)


def game_runs_on_table(games_df: pd.DataFrame) -> pd.DataFrame:
    df = games_df[['id']].copy().rename(columns=dict(id='game_id'))
    df['platform'] = 'pc'
    return df


def store_table() -> pd.DataFrame:
    return pd.DataFrame({
        'id': [0, 1],
        'name': ['Steam', 'Epic'],
        'website': ['https://store.steampowered.com/',
                    'https://store.epicgames.com/'],
        'logo': ['https://upload.wikimedia.org/wikipedia/'
                 'commons/thumb/8/83/'
                 'Steam_icon_logo.svg/'
                 '512px-Steam_icon_logo.svg.png',
                 'https://upload.wikimedia.org/wikipedia/'
                 'commons/thumb/5/57/'
                 'Epic_games_store_logo.svg/'
                 '648px-Epic_games_store_logo.svg.png']
    })


def collection_and_game_tables(games_df: pd.DataFrame) -> tuple[pd.DataFrame,
                                                                pd.DataFrame]:
    collections = []
    has_game = []
    collection_id = 0

    for u in USERS:
        for c in u['collections']:
            now = datetime.now()

            # Add collection
            collections.append({
                'id': collection_id,
                'name': c['name'],
                'owner_username': u['username'],
                'description': '',
                'created_at': now,
                'last_updated_at': now
            })

            # Add games in this collection
            for g in c['games']:
                now += timedelta(seconds=random.randint(1, 3600))
                gid = games_df[games_df.name == g].id.item()
                has_game.append({
                    'collection_id': collection_id,
                    'game_id': gid,
                    'added_at': now
                })

            collection_id += 1

    return pd.DataFrame(collections), pd.DataFrame(has_game)


if __name__ == '__main__':
    # Garantir que diretório de saída existe
    OUT_DIR.mkdir(exist_ok=True)

    # Carregar DataFrame com todos os jogos
    print('Carregando DataFrame completo...')
    games_df = get_games_df()
    games_df.to_csv('games_dataset.csv', index=False)

    # Salvar tabela dos jogos
    print('Criando tabela `game`...')
    game_table(games_df).to_csv(OUT_DIR.joinpath('game.csv'),
                                index=False)

    # Obter e salvar tabela dos gêneros
    print('Criando tabela `genre`...')
    genre_df = genre_table(games_df)
    genre_df.to_csv(OUT_DIR.joinpath('genre.csv'),
                    index=False)

    # Salvar tabela game_has_genre
    print('Criando tabela `game_has_genre`...')
    game_has_genre_table(
        games_df,
        genre_df).to_csv(OUT_DIR.joinpath('game_has_genre.csv'),
                         index=False)
    del genre_df

    # Salvar tabela store
    print('Criando tabela `store`...')
    store_table().to_csv(OUT_DIR.joinpath('store.csv'),
                         index=False)

    # Salvar tabela game_available_at
    print('Criando tabela `game_available_at`...')
    game_available_at_table(games_df).to_csv(
        OUT_DIR.joinpath('game_available_at.csv'),
        index=False)

    # Salvar tabela game_runs_on
    print('Criando tabela `game_runs_on`...')
    game_runs_on_table(games_df).to_csv(OUT_DIR.joinpath('game_runs_on.csv'),
                                        index=False)

    # Salvar tabelas de coleções
    print('Criando tabelas `collection` e `collection_has_game`...')
    for df, name in zip(collection_and_game_tables(games_df),
                        ['collection.csv', 'collection_has_game.csv']):
        df.to_csv(OUT_DIR.joinpath(name),
                  index=False)

    print('Processo finalizado.')
