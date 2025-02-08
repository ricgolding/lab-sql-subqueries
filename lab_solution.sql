USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.


SELECT title, number_of_copies FROM (
SELECT f.title, 
count(distinct(inventory_id)) as number_of_copies 
FROM film as f
join inventory as i on f.film_id = i.film_id
group by f.title) as s
where title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.


SELECT title, length
from film
where length > (SELECT avg(length) FROM film)
order by length;


-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT title, actor_first_name, actor_last_name FROM (
SELECT f.title, 
a.first_name as actor_first_name, 
a.last_name as actor_last_name
from actor as a
join film_actor as fa on a.actor_id = fa.actor_id
join film as f on fa.film_id = f.film_id) AS S
WHERE title = 'Alone Trip';

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

select title, category from (
select f.title, c.name as category from film as f
join film_category as fc on f.film_id = fc.film_id
join category as c on c.category_id = fc.category_id) as s3
where category = 'Family';

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, email, country FROM
(SELECT c.first_name, c.email, co.country FROM customer as c
join address as a on c.address_id = a.address_id
join city as ci on a.city_id = ci.city_id
join country as co on ci.country_id = co.country_id) as s2
WHERE country = 'Canada';


-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT 
    a.first_name, 
    a.last_name, 
    COUNT(DISTINCT f.film_id) AS film_count
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f ON fa.film_id = f.film_id
GROUP BY a.first_name, a.last_name
ORDER BY film_count DESC;

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select f.title, c.customer_id 
from film as f
join inventory as i on f.film_id = i.film_id
join rental as r on r.inventory_id = i.inventory_id
join customer as c on r.customer_id = c.customer_id
where c.customer_id = (
select customer_id 
from (
	SELECT 	c.customer_id, 	sum(p.amount) as total_spent 
	from customer as c
	join payment as p on c.customer_id = p.customer_id
	group by c.customer_id
	order by total_spent DESC
	limit 1
    ) as s
);

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.
    

select c.customer_id, 
sum(p.amount) as total_spent
from customer as c 
join payment as p on c.customer_id = p.customer_id 
group by c.customer_id 
having SUM(p.amount) > (select avg(total_spent) from (select c.customer_id, 
		   sum(p.amount) as total_spent
    from customer as c 
    join payment as p on c.customer_id = p.customer_id 
    group by c.customer_id
    ) as subquery
);
