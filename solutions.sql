-- Netflix Project
create table netflix(
show_id	varchar(10),
type varchar(10),
title VARCHAR(150),
director VARCHAR(210),
casts	VARCHAR(850),
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year	INT,
rating	VARCHAR(10),
duration  VARCHAR(15),	
listed_in	VARCHAR(100),
description VARCHAR(250)
);

SELECT * FROM NETFLIX;
SELECT COUNT(*) as total_rows from netflix;
SELECT DISTINCT TYPE FROM netflix;
select count(type) from netflix;
select count(distinct type ) from netflix;

--15 BUSINESS PROBLEMS

-- 1.Count the number of Movies vs TV shows.

SELECT 
     type,
     COUNT(*) as total_content 
FROM netflix 
group by type;

-- 2.Find the most common rating for Movies and TV shows.


SELECT
     type,
	 rating
from(SELECT 
     type,
	 rating,
	 count(*),
	 rank() over(partition by type order by count(*) desc)
	 as ranking
from netflix 
group by type,rating
) as t1
where ranking =1;

'SELECT 
     type,
	 rating,
	 count(*),
	 rank() over(partition by type order by count(*) desc)
	 as ranking
from netflix 
group by type,rating'

--3.List all the movies released in a specific year(e.g.,2020)

select 
     type,
     title,
	 release_year
from netflix	 
where type='Movie'and release_year=2020
;

--4.Find the top 5 countries with most content on netflix.

select 
     UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	 count(show_id) AS TOTAL_CONTENT
from netflix
group by 1
order by 2 desc
LIMIT 5
;

'select UNNEST(STRING_TO_ARRAY(country,',')) 
as new_country from netflix'

--5.Identify the longest movie.

select type,
       title,
       duration 
from netflix where type='Movie'
and duration = (Select max(duration) from netflix);

--6.Find content added in last five years.

select * 
from netflix 
where TO_DATE(date_added,'MONTH, DD YYYY') >= CURRENT_DATE - INTERVAL'5 years'

--Select CURRENT_DATE - INTERVAL'5 years'

--7.Find all the movie , TV shows by director 'Rajiv Chilaka'

Select type,title,director
from netflix 
where director ILIKE '%Rajiv Chilaka%';

--8.List all tv shows with more than 5 seasons.

Select 
     type,
	 title,
	 duration
from netflix
where type ='TV Show' 
and
duration > '5 Seasons'
order by duration;

--9.Find the number of content items in each genre .
select 
     UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	 count(show_id)
from netflix
group by 1
order by 2;

--10.FInd the average number of content release in India each year . 

Select 
     Extract (YEAR from TO_DATE(date_added,'MONTH, DD YYYY')) as year,
	 COUNT(Show_id) as num_content,
	 COUNT(Show_id)::numeric/(Select count(Show_id) from netflix where country ='India')::numeric *100 
	 as avg_content
from netflix
where country ='India'
group by 1;












