PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO users (occupation_id, surname, name, email, gender, register_date)
VALUES ((SELECT occupation_id FROM occupations WHERE occupation = 'student'), 'Чадин', 'Евгений', 'hgspdojkf@mail.ru', 'male', date('now')),
       ((SELECT occupation_id FROM occupations WHERE occupation = 'student'), 'Челнаков', 'Дмитрий', 'yfgyef2jkf@mail.ru', 'male', date('now')),
       ((SELECT occupation_id FROM occupations WHERE occupation = 'student'), 'Сульдина', 'Алина', 'hgs5r73f@gmail.com', 'female', date('now')),
       ((SELECT occupation_id FROM occupations WHERE occupation = 'student'), 'Федорова', 'Дарья', 'hgsp47sdf@mail.ru', 'female', date('now')),
       ((SELECT occupation_id FROM occupations WHERE occupation = 'student'), 'Тужилкин', 'Егор', 'guhugrfe3dojkf@gmail.com', 'male', date('now'));

INSERT INTO movies (title, year)
VALUES ('Форсаж', 2001),
       ('Такси', 1998),
       ('Крестный отец', 1972);
INSERT INTO movie_genres (movie_id, genre_id)
VALUES ((SELECT movie_id FROM movies WHERE title = 'Форсаж' AND year = 2001), (SELECT genre_id FROM genres WHERE genre = 'Action')),
       ((SELECT movie_id FROM movies WHERE title = 'Такси' AND year = 1998), (SELECT genre_id FROM genres WHERE genre = 'Comedy')),
       ((SELECT movie_id FROM movies WHERE title = 'Крестный отец' AND year = 1972), (SELECT genre_id FROM genres WHERE genre = 'Drama'));

INSERT INTO tags (user_id, movie_id, tag)
VALUES ((SELECT user_id FROM users WHERE surname = 'Чадин' AND name = 'Евгений' AND occupation_id = (SELECT occupation_id FROM occupations WHERE occupation = 'student')),
        (SELECT movie_id FROM movies WHERE title = 'Форсаж' AND year = 2001), 'Вин Дизель мой любимый актер!'),
    ((SELECT user_id FROM users WHERE surname = 'Чадин' AND name = 'Евгений' AND occupation_id = (SELECT occupation_id FROM occupations WHERE occupation = 'student')),
        (SELECT movie_id FROM movies WHERE title = 'Такси' AND year = 1998), 'Очень смешной фильм!'),
    ((SELECT user_id FROM users WHERE surname = 'Чадин' AND name = 'Евгений' AND occupation_id = (SELECT occupation_id FROM occupations WHERE occupation = 'student')),
        (SELECT movie_id FROM movies WHERE title = 'Крестный отец' AND year = 1972), 'Очень хороший фильм, всем советую!');

COMMIT;