use imdb;
#1
SELECT 'Movie' AS Table_Name, COUNT(*) AS Total_Records FROM Movie
UNION ALL
SELECT 'Genre', COUNT(*) FROM Genre
UNION ALL
SELECT 'Director Mapping', COUNT(*) FROM Director_Mapping
UNION ALL
SELECT 'Role Mapping', COUNT(*) FROM Role_Mapping
UNION ALL
SELECT 'Names', COUNT(*) FROM Names
UNION ALL
SELECT 'Ratings', COUNT(*) FROM Ratings;

#2
SELECT 
    'title' AS Column_Name, COUNT(*) AS Null_Count FROM Movie WHERE title IS NULL
UNION ALL
SELECT 
    'year', COUNT(*) FROM Movie WHERE year IS NULL
UNION ALL
SELECT 
    'duration', COUNT(*) FROM Movie WHERE duration IS NULL
UNION ALL
SELECT 
    'country', COUNT(*) FROM Movie WHERE country IS NULL
UNION ALL
SELECT 
    'worlwide_gross_income', COUNT(*) FROM Movie WHERE worlwide_gross_income IS NULL
UNION ALL
SELECT 
    'languages', COUNT(*) FROM Movie WHERE languages IS NULL
UNION ALL
SELECT 
    'production_company', COUNT(*) FROM Movie WHERE production_company IS NULL;

#3
ALTER TABLE Movie CHANGE COLUMN year release_year INT;

SELECT release_year, COUNT(*) AS total_movies
FROM Movie
GROUP BY release_year
ORDER BY release_year;

SELECT 
    YEAR(date_published) AS release_year, 
    MONTH(date_published) AS release_month, 
    COUNT(*) AS total_movies
FROM Movie
GROUP BY YEAR(date_published), MONTH(date_published)
ORDER BY release_year,total_movies DESC;
    
#4
SELECT COUNT(*) AS total_movies
FROM Movie
WHERE country IN ('USA', 'India') 
AND release_year = 2019;

#5
SELECT DISTINCT genre FROM Genre;

#6
SELECT genre, COUNT(movie_id) AS total_movies
FROM Genre
GROUP BY genre
ORDER BY total_movies DESC
LIMIT 1;

#7
SELECT Genre.genre, AVG(Movie.duration) AS avg_duration
FROM Movie, Genre
WHERE Movie.id = Genre.movie_id
GROUP BY Genre.genre
ORDER BY avg_duration DESC;

#8/
SELECT Names.name, COUNT(*) AS movie_count, AVG(Ratings.avg_rating) AS avg_rating
FROM Names, Role_Mapping, Ratings
WHERE Names.id = Role_Mapping.name_id
AND Role_Mapping.movie_id = Ratings.movie_id
AND Role_Mapping.category IN ('actor', 'actress')
AND Ratings.avg_rating < 5
GROUP BY Names.name
HAVING COUNT(*) > 3;

#9
SELECT 
    MIN(avg_rating) AS min_rating, MAX(avg_rating) AS max_rating,
    MIN(total_votes) AS min_votes, MAX(total_votes) AS max_votes,
    MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;

#10
SELECT Movie.title, Ratings.avg_rating
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
ORDER BY Ratings.avg_rating DESC
LIMIT 10;

#11
SELECT ROUND(avg_rating, 1) AS median_rating, COUNT(*) AS num_movies
FROM ratings
GROUP BY ROUND(avg_rating, 1)
ORDER BY median_rating DESC;

#12
SELECT COUNT(*) AS movie_count
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
AND Movie.date_published BETWEEN '2017-03-01' AND '2017-03-31'
AND Movie.country = 'USA'
AND Ratings.total_votes > 1000;

#13
SELECT title, 
       (SELECT genre FROM Genre WHERE Genre.movie_id = Movie.id LIMIT 1) AS genre, 
       (SELECT avg_rating FROM Ratings WHERE Ratings.movie_id = Movie.id) AS average_rating
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
AND Movie.title LIKE 'The %'
AND Ratings.avg_rating > 8
ORDER BY genre, average_rating DESC;

#14
SELECT COUNT(*)
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
AND Movie.release_year BETWEEN '2018-04-01' AND '2019-04-01'
AND Ratings.median_rating = 8;

#15
SELECT 
    (SELECT AVG(Ratings.total_votes) 
     FROM Movie, Ratings 
     WHERE Movie.id = Ratings.movie_id 
     AND Movie.country = 'Germany') AS avg_votes_germany,

    (SELECT AVG(Ratings.total_votes) 
     FROM Movie, Ratings 
     WHERE Movie.id = Ratings.movie_id 
     AND Movie.country = 'Italy') AS avg_votes_italy;

#16
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS birthdate_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_movies_nulls
FROM Names;

#17
SELECT Names.name, COUNT(*) AS movie_count
FROM Names, Role_Mapping, Ratings
WHERE Names.id = Role_Mapping.name_id
AND Role_Mapping.movie_id = Ratings.movie_id
AND Role_Mapping.category = 'actor'
AND Ratings.median_rating >= 8
GROUP BY Names.name
ORDER BY movie_count DESC
LIMIT 2;

#18
SELECT Movie.production_company, SUM(Ratings.total_votes) AS total_votes
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
GROUP BY Movie.production_company
ORDER BY total_votes DESC
LIMIT 3;

#19
SELECT COUNT(*) AS director_count
FROM (
    SELECT Director_Mapping.name_id, COUNT(*) AS movie_count
    FROM Director_Mapping
    GROUP BY Director_Mapping.name_id
    HAVING COUNT(*) > 3
) AS director_subquery;

#20
SELECT Role_Mapping.category, AVG(Names.height) AS avg_height
FROM Names, Role_Mapping
WHERE Names.id = Role_Mapping.name_id
AND Role_Mapping.category IN ('actor', 'actress')
GROUP BY Role_Mapping.category;

#21
SELECT Movie.title, Movie.country, Names.name AS director_name, Movie.release_year
FROM Movie, Director_Mapping, Names
WHERE Movie.id = Director_Mapping.movie_id
AND Director_Mapping.name_id = Names.id
ORDER BY Movie.release_year ASC
LIMIT 10;

#22
SELECT Movie.title, Genre.genre, Ratings.total_votes
FROM Movie, Genre, Ratings
WHERE Movie.id = Ratings.movie_id
AND Movie.id = Genre.movie_id
ORDER BY Ratings.total_votes DESC
LIMIT 5;

#23
SELECT Movie.title, Movie.production_company, Genre.genre, Movie.duration
FROM Movie, Genre
WHERE Movie.id = Genre.movie_id
AND Movie.duration = (SELECT MAX(duration) FROM Movie);

#24
SELECT Movie.title, SUM(Ratings.total_votes) AS total_votes
FROM Movie, Ratings
WHERE Movie.id = Ratings.movie_id
AND Movie.release_year = 2018
GROUP BY Movie.title
ORDER BY total_votes DESC;

#25
SELECT Movie.languages,count(*) as movies_count
from movie
group by movie.languages
order by movies_count desc
limit 1;
