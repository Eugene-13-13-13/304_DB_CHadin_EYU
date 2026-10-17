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
	SELECT user_id, MIN(timestamp) AS first_timestamp 
	FROM ratings
	GROUP BY user_id
)
SELECT movies.title,
	users.name,
	ratings.rating,
	date(ratings.timestamp, 'unixepoch')
FROM first_ratings
JOIN ratings ON first_ratings.user_id = ratings.user_id 
    AND first_ratings.first_timestamp = ratings.timestamp
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

"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, 
которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "

"
echo " "

echo "5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. 
Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "

"
echo " "

echo "6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. 
Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "

"
echo " "

echo "7. Вывести список из 10 последних зарегистрированных пользователей в формате 
\"Фамилия Имя|Дата регистрации\" (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "

"
echo " "

echo "8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "

"
echo " "