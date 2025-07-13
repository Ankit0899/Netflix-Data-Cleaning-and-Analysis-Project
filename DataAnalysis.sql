Select * from netflix

-- Netflix Data Analysis

/* 1. For Each director count the no of movies and tv shows created by them in separate columns for directors who have
created tv shows and movies both */

Select nd.director 
,count(distinct case when n.type='Movie' then n.show_id end) as no_of_movies
,count(distinct case when n.type='TV Show' then n.show_id end) as no_of_tvshow
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
group by nd.director
having count(distinct n.type)>1


-- 2. Which country has highest number of comedy movies (Comedies)
Select top 1 nc.country, count(distinct ng.show_id) as no_of_movies
from netflix_genre ng 
inner join netflix_Country nc ON ng.show_id=nc.show_id
inner join netflix n on ng.show_id=nc.show_id
where ng.genre='Comedies' and n.type='Movie'
group by nc.country
order by no_of_movies desc


-- 3. For each Year (as per date added to netflix), which director has maximum number of movies released
with cte as (
Select  nd.director,year(date_added) as date_year, COUNT(n.show_id) as no_of_movies 
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
group by nd.director, year(date_added)
)
Select *
, ROW_NUMBER() over(partition by date_year order by no_of_movies desc)as rn
from cte
order by date_year