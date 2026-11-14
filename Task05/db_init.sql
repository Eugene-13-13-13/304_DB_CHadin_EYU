PRAGMA foreign_keys = ON;
PRAGMA synchronous = OFF;
PRAGMA journal_mode = MEMORY;
PRAGMA temp_store = MEMORY;
PRAGMA cache_size = 100000;

DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;

CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        year INTEGER,
        genres TEXT
        );

CREATE TABLE ratings (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        movie_id INTEGER,
        rating REAL,
        timestamp INTEGER
        );

CREATE TABLE tags (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        movie_id INTEGER,
        tag TEXT,
        timestamp INTEGER
        );

CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        gender TEXT,
        register_date TEXT,
        occupation TEXT
        );

BEGIN TRANSACTION;

INSERT INTO movies (id, title, year, genres) VALUES (1, 'Toy Story', 1995, 'Adventure|Animation|Children|Comedy|Fantasy');