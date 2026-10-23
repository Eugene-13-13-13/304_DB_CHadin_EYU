#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. 
Устранить дубликаты, проверить отсутствие пар с самим собой. 
Для каждой пары должны быть указаны имена пользователей и название фильма, который они оценили.
В списке оставить первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT u1.name AS user1, 
       u2.name AS user2, 
       m.title AS movie
FROM ratings AS r1
JOIN ratings AS r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id
JOIN users AS u1 ON u1.id = r1.user_id
JOIN users AS u2 ON u2.id = r2.user_id
JOIN movies AS m ON m.id = r1.movie_id
LIMIT 100;
"
echo " "

echo "2. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, 
имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
WITH first_ratings AS (
	SELECT user_id, 
	       MIN(timestamp) AS first_timestamp 
	FROM ratings
	GROUP BY user_id
)
SELECT movies.title,
       users.name,
       ratings.rating,
       date(ratings.timestamp, 'unixepoch')
FROM first_ratings
JOIN ratings ON first_ratings.user_id = ratings.user_id AND first_ratings.first_timestamp = ratings.timestamp
JOIN movies ON movies.id = ratings.movie_id
JOIN users ON users.id = ratings.user_id
ORDER BY ratings.timestamp ASC
LIMIT 10; 
"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. 
Общий список отсортировать по году выпуска и названию фильма. 
В зависимости от рейтинга в колонке \"Рекомендуем\" для фильмов должно быть написано \"Да\" или \"Нет\"."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
WITH avg_ratings AS (
  SELECT movie_id, 
         AVG(rating) AS avg_rating
  FROM ratings
  GROUP BY movie_id
),
extrems AS (
  SELECT MIN(avg_rating) AS min_rating,
         MAX(avg_rating) AS max_rating
  FROM avg_ratings
)
SELECT movies.title, movies.year, avg_ratings.avg_rating,
CASE
    WHEN avg_ratings.avg_rating = extrems.max_rating THEN 'Да'
    ELSE 'Нет'
    END AS "Рекомендуем"
FROM avg_ratings
JOIN extrems ON avg_ratings.avg_rating = extrems.min_rating OR avg_ratings.avg_rating = extrems.max_rating
JOIN movies ON movies.id = avg_ratings.movie_id
ORDER BY movies.year ASC,
         movies.title ASC;
"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, 
которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT COUNT(ratings.rating), 
       AVG(ratings.rating)
FROM ratings
JOIN users ON users.id = ratings.user_id
WHERE users.gender = 'male' 
  AND strftime('%Y', ratings.timestamp, 'unixepoch') BETWEEN '2011' AND '2014';
"
echo " "

echo "5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. 
Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT movies.title,
       movies.year,
       AVG(ratings.rating) AS avg_rating,
       COUNT(DISTINCT ratings.user_id) AS users_count
FROM movies
JOIN ratings ON ratings.movie_id = movies.id
GROUP BY movies.id
ORDER BY movies.year ASC,
         movies.title ASC
LIMIT 20;
"
echo " "

echo "6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. 
Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
WITH RECURSIVE split AS (
    SELECT movies.id AS movie_id,
           '' AS genre,
           movies.genres || '|' AS rest
    FROM movies
    UNION ALL
    SELECT split.movie_id,
           substr(split.rest, 1, instr(split.rest, '|') - 1),
           substr(split.rest, instr(split.rest, '|') + 1)
    FROM split
    WHERE split.rest <> ''
)
SELECT split.genre,
       COUNT(*) AS movie_count
FROM split
WHERE split.genre <> ''
GROUP BY split.genre
ORDER BY movie_count DESC
LIMIT 1;
"
echo " "

echo "7. Вывести список из 10 последних зарегистрированных пользователей в формате 
\"Фамилия Имя|Дата регистрации\" (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT substr(users.name, instr(users.name, ' ') + 1) || ' '
       || substr(users.name, 1, instr(users.name, ' ') - 1) || '|'
       || users.register_date AS \"Фамилия Имя|Дата регистрации\"
FROM users
ORDER BY users.register_date DESC
LIMIT 10;
"
echo " "

echo "8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "
WITH RECURSIVE years AS (
    SELECT 2006 AS year
    UNION ALL
    SELECT years.year + 1
    FROM years
    WHERE years.year < CAST(strftime('%Y', 'now') AS INTEGER)
)
SELECT years.year,
       CASE CAST(strftime('%w', printf('%04d-08-01', years.year)) AS INTEGER)
            WHEN 0 THEN 'Воскресенье'
            WHEN 1 THEN 'Понедельник'
            WHEN 2 THEN 'Вторник'
            WHEN 3 THEN 'Среда'
            WHEN 4 THEN 'Четверг'
            WHEN 5 THEN 'Пятница'
            WHEN 6 THEN 'Суббота'
       END AS day_of_the_week
FROM years;
"
echo " "