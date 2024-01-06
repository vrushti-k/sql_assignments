/*Q1.Compute new cases for each day. */

-- use test2;

select date, sum(num_of_new_cases_per_state) as total_new_cases
from (select date, state, total_cases, lag(total_cases) over w as 'prev_day_cases',
total_cases-lag(total_cases) over w as 'num_of_new_cases_per_state' 
from test2.statistics
window w as (partition by state order by date)) as t
group by date;

/*Q2.To account for "administrative weekends" with fewer reports or missing data, 
compute the smoothed rolling average between two preceding days and two following days. */

select *,
avg(total_cases) over w as '5-day avg cases',
sum(total_cases) over w as '5-day total cases',
count(total_cases) over w as 'count_cases',
avg(total_deaths) over w as '5-day avg deaths',
sum(total_deaths) over w as '5-day total deaths',
count(total_deaths) over w as 'count_deaths'
from statistics
window w as (partition by state order by date rows between 2 preceding and 2 following);


/*Q3. Fetch latest available per state data from statistics. Note that states may have different latest submission dates. (hint: ROW_NUMBER())*/

create temporary table tmp2 
select * from (
select *, row_number() over(partition by state order by date desc) as group_position
from statistics ) as t 
where t.group_position = 1;
select * from tmp2;

/*Q4.Use the "latest data" derived from the above query and demographic information to compute the mortality per 100,000 population.*/


select tmp2.state, total_deaths, population, ((100000*total_deaths)/population) as mortality_rate from tmp2
inner join demographics
on tmp2.state = demographics.state;

/*Q5.Find the biggest spike in new deaths per country. Sort them by the most recent date, then by the count of new deaths. (hint: RANK())*/

select * from (
select *, rank() over(partition by state order by new_deaths DESC, date DESC) as ranking
from (
select *, 
total_deaths-lag(total_deaths) over w as new_deaths
from statistics as t
window w as (partition by state order by date)) as t2
)as t3
where t3.ranking = 1;
