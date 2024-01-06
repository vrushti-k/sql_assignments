-- Q1. Find the titles of all movies directed by Steven Spielberg.

select title from Movie
where director = 'Steven Spielberg';

-- Q2. Find the movies names that contain the word "THE"

select title from Movie
where title like '%the%';

-- Q3. Find those rating records higher than 3 stars before 2011/1/15 or after 2011/1/20 

select * from Rating
where stars>3 and (ratingDate<'2011/1/15' or ratingDate>'2011/1/20');
    
/* Q4. Some reviewers did rating on the same movie more than once. 
How many rating records are there with different movie and different reviewer's rating? */

#select distinct rID, mID from Rating;
select count(distinct rID, mID) from Rating;

-- Q5. Which are the top 3 records with the highest ratings?

select * from Rating
order by stars desc limit 3;

-- Q6. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select distinct year from Movie inner join Rating
on Movie.mID = Rating.mID
where Rating.stars = 4 or Rating.stars = 5
order by year;

-- Q7. Find the titles of all movies that have no ratings.

select title from Movie left join Rating
on Movie.mID = Rating.mID
where stars is null
;

/* Q8. Some reviewers didn't provide a date with their rating. 
 Find the names of all reviewers who have ratings with a NULL value for the date. */

select name from Reviewer inner join Rating
on Reviewer.rID = Rating.rID
where ratingDate is null;
 
/* Q9. Write a query to return the ratings data in a more readable format in only one field(column): 
"reviewer name, movie title, stars, ratingDate". 
Assign a new name to the new column as "Review_details"
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
Hint: join three tables, using join twice. 
Hint: use CONCAT_WS(separator, string1, string2) instead of CONCAT() for creating new column because of NULL values */

select concat_ws(', ', name, title, stars, ratingDate) as Review_details
from Rating
join Movie
  on Rating.mID = Movie.mID
join Reviewer
  on Reviewer.rID = Rating.rID
order by name, title, stars;
