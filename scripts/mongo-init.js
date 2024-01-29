db.createCollection('users');
db.users.createIndex({'username': 1});
db.users.insertMany([
    {
        "username": "gabriel_augusto",
        "password": "$2y$10$32cH7aRVfeOlxMZTwyjwVOx3ujgIanfzbQ8xdj2IdMX2PGwlnjhoS",
        "display_name": "Gabriel Augusto",
        "avatar_url": null,
        "creation_date": new Date("2000-01-01"),
        "dob": new Date(""),
        "email": "gabriel_augusto@email.com",
        "phone": "+5581999999999",
        "biography": "",
        "last_access": new Date(),
        "n_collections": 1,
        "n_games": 5,
        "n_friends": 3
    },
    {
        "username": "hyan_batista",
        "password": "$2y$10$668Vhu9Cno6NpVZkvbQ.9e6NLJZulgvnOTwuCoLGrhjPMkoIZ7Az2",
        "display_name": "Hyan Batista",
        "avatar_url": null,
        "creation_date": new Date("2000-01-01"),
        "dob": new Date(""),
        "email": "hyan_batista@email.com",
        "phone": "+5581999999999",
        "biography": "",
        "last_access": new Date(),
        "n_collections": 3,
        "n_games": 9,
        "n_friends": 2
    },
    {
        "username": "moesio_filho",
        "password": "$2y$10$ks5MHg2hJ72YqQihcpTJ2e7TDKgXsUgrtkbduL0P6gXj2XCBLUdsq",
        "display_name": "Moésio Filho",
        "avatar_url": null,
        "creation_date": new Date(),
        "dob": new Date("2000-01-01"),
        "email": "moesio_filho@email.com",
        "phone": "+5581999999999",
        "biography": "",
        "last_access": new Date(),
        "n_collections": 2,
        "n_games": 10,
        "n_friends": 3
    },
    {
        "username": "henrique_sabino",
        "password": "$2y$10$qtwgKDcQnxn5ZkY0Tv.lMe733mqtWBWPzSMMalvWFEhnsPM/yqm0y",
        "display_name": "Henrique Sabino",
        "avatar_url": null,
        "creation_date": new Date(),
        "dob": new Date("2000-01-01"),
        "email": "henrique_sabino@email.com",
        "phone": "+5581999999999",
        "biography": "",
        "last_access": new Date(),
        "n_collections": 2,
        "n_games": 8,
        "n_friends": 3
    },
    {
        "username": "samuel_vidal",
        "password": "$2y$10$6JKX17FsVzk9/5OWj/UFKOGJp9Pfe2JBnN.0WUdoNGyur8dswejOC",
        "display_name": "Samuel Vidal",
        "avatar_url": null,
        "creation_date": new Date(),
        "dob": new Date("2000-01-01"),
        "email": "samuel_vidal@email.com",
        "phone": "+5581999999999",
        "biography": "",
        "last_access": new Date(),
        "n_collections": 4,
        "n_games": 12,
        "n_friends": 3
    }
]);
