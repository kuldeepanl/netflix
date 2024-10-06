                                       ---Netflix Data Analysis using SQL
use project


select*from netflix
select count(*) from netflix


--1. Count the number of Movies vs TV Shows
select type,COUNT(type) as number_count from netflix group by type

--2. Find the most common rating for movies and TV shows

select type,rating,number_count from
(select type,rating,count(*) as number_count ,
RANK() over(partition by type order by count(*) desc) as rnk
from netflix 
group by type,rating ) as t1 where rnk=1

---- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix
where type='Movie' and release_year=2000 

-- 4. Find the top 5 countries with the most content on Netflix

select top 5 country,count(*) as number_of_content 
from netflix
group by country 
order by number_of_content desc 


---5. Identify the longest movie


SELECT TOP 5
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY duration desc 

---6. Find content added in the last 5 years

select* from netflix   
where date_added >= CAST(DATEADD(YEAR, -5, GETDATE()) AS DATE) 
order by date_added desc

---7Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix where director like '%Rajiv Chilaka%'

---8. List all TV shows with more than 5 seasons
select * from
(select *,concat(substring(duration,1,2),' ') 
as number_of_show  from netflix where type='TV Show') as t1 where number_of_show>5

---9. Count the number of content items in each genre
select genres,count(*) as num_count from
(select trim(value) as genres from netflix 
cross apply string_split(listed_in,',')) 
as t1 
group by genres 
order by num_count desc

---10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

with t1 as (select count(*) num_india from netflix where country='india')

select country,release_year,count(show_id) as total_per_year_release,
round(cast(count(show_id) as float)/(select num_india from t1)*100,2) as avg
 from netflix where country='india' 
group by country,release_year order by avg desc


---11. List all movies that are documentaries
select * from
(select *,trim(value) as genres from netflix cross apply string_split(listed_in,',')) as ti
where type='Movie' and genres='Documentaries'
                                   ---OR
select * from netflix where listed_in like'%Documentaries%'




---12. Find all content without a director
select * from netflix where director is null
---13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select  * from netflix where type='Movie' and cast like'%Salman Khan%'


---14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select top 10 actor_name,count(show_id) as num_movie_per_actore from 
(select *,trim(value) as actor_name
from netflix cross apply string_split(cast,',')) as t1 
where type='Movie' and country='india'  
group by actor_name 
order by num_movie_per_actore desc



---15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

select category,count(show_id) as content_count from 
(select*,
case 
when description like '%kill%' or description like '%violence%' then 'Bad'
else 'good'
end as category
from netflix) as t1 group by category


 ---end report