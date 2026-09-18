import csv
import re
import os

def escape_sql(value):
    if value is None:
        return "NULL"
    if isinstance(value, str):
        return "'" + value.replace("'", "''") + "'"
    return str(value)

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    dataset_dir = os.path.join(base_dir, 'dataset')
    if not os.path.exists(dataset_dir):
        dataset_dir = base_dir

    sql_file = os.path.join(base_dir, 'db_init.sql')

    with open(sql_file, 'w', encoding = 'utf-8') as f:
        f.write("PRAGMA foreign_keys = OFF;\n")
        f.write("PRAGMA synchronous = OFF;\n")
        f.write("PRAGMA journal_mode = MEMORY;\n")
        f.write("PRAGMA temp_store = MEMORY;\n")
        f.write("PRAGMA cache_size = 100000;\n\n")

        f.write("DROP TABLE IF EXISTS movies;\n")
        f.write("DROP TABLE IF EXISTS users;\n")
        f.write("DROP TABLE IF EXISTS ratings;\n")
        f.write("DROP TABLE IF EXISTS tags;\n\n")

        f.write("""CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        year INTEGER,
        genres TEXT
        );\n\n""")

        f.write("""CREATE TABLE ratings (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        movie_id INTEGER,
        rating REAL,
        timestamp INTEGER
        );\n\n""")

        f.write("""CREATE TABLE tags (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        movie_id INTEGER,
        tag TEXT,
        timestamp INTEGER
        );\n\n""")

        f.write("""CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        gender TEXT,
        register_date TEXT,
        occupation TEXT
        );\n\n""")

        f.write("BEGIN TRANSACTION;\n\n")

        movies_path = os.path.join(dataset_dir, 'movies.csv')
        if os.path.exists(movies_path):
            with open(movies_path, 'r', encoding = 'utf-8') as mf:
                reader = csv.reader(mf)
                next(reader)
                for row in reader:
                    movie_id = int(row[0])
                    title_raw = row[1]
                    genres = row[2]
                    year_match = re.search(r'\((\d{4})\)\s*$', title_raw)
                    if year_match:
                        year = year_match.group(1)
                        title = title_raw[:year_match.start()].strip()
                    else:
                        year = "NULL"
                        title = title_raw.strip()
                    f.write(f"INSERT INTO movies (id, title, year, genres) VALUES ({movie_id}, {escape_sql(title)}, {year}, {escape_sql(genres)});\n")

        users_path = os.path.join(dataset_dir, 'users.txt')
        if os.path.exists(users_path):
            with open(users_path, 'r', encoding = 'utf-8') as uf:
                for line in uf:
                    parts = line.strip().split('|')
                    if len(parts) == 6:
                        f.write(f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({parts[0]}, {escape_sql(parts[1])}, {escape_sql(parts[2])}, {escape_sql(parts[3])}, {escape_sql(parts[4])}, {escape_sql(parts[5])});\n")

        ratings_path = os.path.join(dataset_dir, 'ratings.csv')
        if os.path.exists(ratings_path):
            with open(ratings_path, 'r', encoding = 'utf-8') as rf:
                reader = csv.reader(rf)
                next(reader)
                rid = 1
                for row in reader:
                    if len(row) >= 4:
                        f.write(f"INSERT INTO ratings (id, user_id, movie_id, rating, timestamp) VALUES ({rid}, {row[0]}, {row[1]}, {row[2]}, {row[3]});\n")
                        rid += 1

        tags_path = os.path.join(dataset_dir, 'tags.csv')
        if os.path.exists(tags_path):
            with open(tags_path, 'r', encoding = 'utf-8') as tf:
                reader = csv.reader(tf)
                next(reader)
                tid = 1
                for row in reader:
                    if len(row) >= 4:
                        f.write(f"INSERT INTO tags (id, user_id, movie_id, tag, timestamp) VALUES ({tid}, {row[0]}, {row[1]}, {escape_sql(row[2])}, {row[3]});\n")
                        tid += 1

        f.write("COMMIT;\n")

if __name__ == '__main__':
    main()