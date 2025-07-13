Select * from netflix_raw

-- Remove Duplicates

Select show_id, count(*) 
from netflix_raw
group by show_id
having count(*) >1

Select * from netflix_raw
where UPPER(title) in (
select UPPER(title)
from netflix_raw
group by upper(title)
having count(*)>1
)
order by title


--- New Table For director, Country, Cast

-- Director
Select show_id, trim(value) as director
into netflix_directors
from netflix_raw
cross apply string_split(director, ',')

Select * from netflix_directors

--- Country 
Select show_id, trim(value) as country
into netflix_Country
from netflix_raw
cross apply string_split(country, ',')

Select * from netflix_Country

-- Cast
SELECT show_id, LTRIM(RTRIM(value)) AS cast
INTO netflix_cast
FROM netflix_raw
CROSS APPLY STRING_SPLIT(CAST(cast AS VARCHAR(MAX)), ',');


-- Listed IN
SELECT show_id, LTRIM(RTRIM(value)) AS genre
INTO netflix_genre
FROM netflix_raw
CROSS APPLY STRING_SPLIT(CAST(listed_in AS VARCHAR(MAX)), ',');

Select * from netflix_genre


--- populate missing values in Country, Duration Columns
insert into netflix_Country
Select show_id, m.country
from netflix_raw nr
inner join (
Select director, country
from netflix_Country nc
inner join netflix_directors nd on nc.show_id = nd.show_id
group by director, country
) m on nr.director=m.director
where nr.country is null


Select director, country
from netflix_Country nc
inner join netflix_directors nd on nc.show_id = nd.show_id
group by director, country
------------------------------------------------

Select * from netflix_raw where duration is null

with cte as (
Select *
,ROW_NUMBER() over(partition by title, type order by show_id) as rn
from netflix_raw
)
Select show_id, type,title,cast(date_added as date) as date_added, release_year
,rating, case when duration is null then rating else duration end as duration, description
into netflix
from cte
where rn=1 and date_added is null

Select * from netflix