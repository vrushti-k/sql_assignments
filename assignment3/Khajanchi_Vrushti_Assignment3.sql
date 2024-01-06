/*1.Find the names of aircraft such that all pilots certified to operate them have salaries more than $80,000. */

use flights;
select a.aname from aircraft as a 
where a.aid = all(
select c.aid 
from certified as c 
join employees as e 
on c.eid = e.eid 
where e.salary > 80000);

/*2.Find the names of employees whose salary is less than the price of the cheapest route from Bangalore to Frankfurt. */

select ename from employees
where salary<(
	select min(price)
    from flight
    where origin = 'Bangalore' and destination='Frankfurt'
    );

/*3.For all aircraft with cruising range over 1,000 miles,
find the name of the aircraft and the average salary of all pilots certified for this aircraft.*/

select aname, avg(salary) from aircraft 
join certified
	on aircraft.aid = certified.aid
join employees
on certified.eid = employees.eid
where cruisingrange>1000
group by aname;


/*4.Identify the routes that can be piloted by every pilot who makes more than $70,000.
(In other words, find the routes with distance less than the least cruising range of aircrafts driven by pilots who make more than $70,000) */
drop table tmp2;
create temporary table tmp2
select employees.eid, employees.ename,salary, min(aircraft.cruisingrange) as cruising_range from employees
join certified
on certified.eid = employees.eid
join aircraft
on aircraft.aid = certified.aid
where salary>70000
group by eid;
select * from tmp2;

select * from flight
where distance < any(
select cruising_range from tmp2);


/*5. Print the names of pilots who can operate planes with cruising range greater than 3,000 miles but are not certified on any Boeing aircraft. */

select distinct ename from aircraft as a
join certified as c
	on a.aid = c.aid
join employees as e
	on c.eid = e.eid
where cruisingrange>3000 and aname not in ('Boeing');

-- SELECT e.ename, a.cruisingrange, a.aname 
# OR 
select distinct e.ename FROM employees e INNER JOIN certified c 
USING(eid) INNER JOIN aircraft a USING(aid) 
WHERE a.cruisingrange > 3000 AND e.eid NOT IN (
SELECT DISTINCT e.eid FROM aircraft a INNER JOIN certified e USING(aid) 
WHERE a.aname LIKE '%Boeing%');


/*6. Compute the difference between the average salary of a pilot and the average salary of all employees (including pilots).*/

set @avg_pilot = (select avg(salary) from employees as e where e.eid in (select distinct certified.eid from certified));
set @avg_emp = (select avg(salary) from employees as e);
select (@avg_pilot - @avg_emp) as diff;


/*7. Print the name and salary of every non-pilot whose salary is more than the average salary for pilots.*/

select ename, salary from employees where employees.eid not in (select distinct eid from certified) and employees.salary>@avg_pilot;