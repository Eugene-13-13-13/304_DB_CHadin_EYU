```
#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT title, year 
FROM movies 
JOIN ratings ON ratings.movie_id = movies.id 
ORDER BY year, title 
LIMIT 10;
"
echo " "

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT name, register_date 
FROM users 
WHERE substr(name, instr(name, ' ') + 1) LIKE 'A%' 
ORDER BY register_date 
LIMIT 5;
"
echo " "

echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: 
имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. 
Отсортировать данные по имени эксперта, затем названию фильма и оценке. 
В списке оставить первые 50 записей."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT users.name, movies.title, movies.year, ratings.rating, date(ratings.timestamp, 'unixepoch')
FROM ratings, movies, users 
WHERE ratings.user_id = users.id 
AND ratings.movie_id = movies.id
ORDER BY users.name, movies.title, ratings.rating
LIMIT 50;
"
echo " "

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. 
Сортировать по году выпуска, затем по названию фильма, затем по тегу. 
В списке оставить первые 40 записей."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT movies.title, movies.year, tags.tag
FROM movies, tags
WHERE movies.id = tags.movie_id
ORDER BY movies.year, movies.title, tags.tag
LIMIT 40;
"
echo " "

echo "5. Вывести список самых свежих фильмов. 
В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. 
Запрос должен быть универсальным, не зависящим от исходных данных 
(нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT title, year
FROM movies
WHERE year = (SELECT MAX(year) FROM movies)
ORDER BY title;
"
echo " "

echo "6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5).
 Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. 
 Результат отсортировать по году выпуска и названию фильма."
echo -----------------------------------------------------------
sqlite3 movies_rating.db -box -echo "
SELECT movies.title, movies.year, COUNT (*)
FROM movies, ratings, users
WHERE movies.id = ratings.movie_id
AND ratings.user_id = users.id
AND movies.genres LIKE '%Drama%'
AND movies.year > 2005
AND users.gender = 'female'
AND ratings.rating >= 4.5
GROUP BY movies.id, movies.title, movies.year
ORDER BY movies.year, movies.title;
"
echo " "

echo "7. Провести анализ востребованности ресурса - вывести количество пользователей, 
регистрировавшихся на сайте в каждом году. 
Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo -----------------------------------------------------------
echo "Количество пользователей, регистрировавшихся на сайте в каждом году:"
sqlite3 movies_rating.db -box -echo "
SELECT strftime('%Y', register_date), COUNT(*)
FROM users
GROUP BY strftime('%Y', register_date)
ORDER BY strftime('%Y', register_date);
"
echo "Год с наибольшим количеством регистраций:"
sqlite3 movies_rating.db -box -echo "
SELECT strftime('%Y', register_date)
FROM users
GROUP BY strftime('%Y', register_date)
ORDER BY COUNT(*) DESC
LIMIT 1
"
echo "Год с наименьшим количеством регистраций:"
sqlite3 movies_rating.db -box -echo "
SELECT strftime('%Y', register_date)
FROM users
GROUP BY strftime('%Y', register_date)
ORDER BY COUNT(*) ASC
LIMIT 1
"
echo " "
```