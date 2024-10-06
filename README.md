# Netflix Movies and TV Shows Data Analysis using SQL

![](https://prnewswire2-a.akamaihd.net/p/1893751/sp/189375100/thumbnail/entry_id/0_8k4rhwp5/def_height/2700/def_width/2700/version/100012/type/1)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/kuldeepsharma1998/netflix?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select type,COUNT(type) as number_count
from netflix
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select type,rating,number_count from
(select type,rating,count(*) as number_count ,
RANK() over(partition by type order by count(*) desc) as rnk
from netflix 
group by type,rating ) as t1 where rnk=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
where type='Movie' and release_year=2000 ;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select top 5 country,count(*) as number_of_content 
from netflix
group by country 
order by number_of_content desc ;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
FROM netflix
WHERE type = 'Movie'
ORDER BY duration desc;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select* from netflix   
where date_added >= CAST(DATEADD(YEAR, -5, GETDATE()) AS DATE) 
order by date_added desc;
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix where director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from
(select *,concat(substring(duration,1,2),' ') 
as number_of_show  from netflix where type='TV Show') as t1 where number_of_show>5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select genres,count(*) as num_count from
(select trim(value) as genres from netflix 
cross apply string_split(listed_in,',')) 
as t1 
group by genres 
order by num_count desc;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
with t1 as (select count(*) num_india from netflix
where country='india')
select country,release_year,count(show_id) as total_per_year_release,
round(cast(count(show_id) as float)/(select num_india from t1)*100,2) as avg
 from netflix where country='india' 
group by country,release_year order by avg desc;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select * from
(select *,trim(value) as genres from netflix cross apply string_split(listed_in,',')) as ti
where type='Movie' and genres='Documentaries'
                                   ---OR
select * from netflix where listed_in like'%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select  * from netflix where type='Movie' and cast like'%Salman Khan%';
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select top 10 actor_name,count(show_id) as num_movie_per_actore from 
(select *,trim(value) as actor_name
from netflix cross apply string_split(cast,',')) as t1 
where type='Movie' and country='india'  
group by actor_name 
order by num_movie_per_actore desc;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
select category,count(show_id) as content_count from 
(select*,
case 
when description like '%kill%' or description like '%violence%' then 'Bad'
else 'good'
end as category
from netflix) as t1 group by category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - KULDEEP SHARMA

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/kuldeep-sharma991725)


Thank you for your support, and I look forward to connecting with you!
