
#Analysis of film catalog and inventory data for business analytics
#Demo of SQL queries and data manipulation
#Use the Sakila dataset 


#1a. Display the first and last names of all actors from the table actor.

use Sakila;

select first_name, last_name 
from actor
;

#1b. Display the first and last name of each actor in a single column in 
#upper case letters. Name the column Actor Name.

select 
    concat(first_name, ' ', last_name) as 'Actor Name'
from actor
;

#2a. Find the ID number, first name, and last name 
#of an actor, of whom you know only the first name, "Joe." 

select
	 actor_id,
     first_name,
     last_name
from actor
where first_name='Joe'
;

#2b. Find all actors whose last name contain the letters GEN:
select
	 actor_id,
     first_name,
     last_name
from actor
where last_name like '%GEN%'
;

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
select
	 actor_id,
     first_name,
     last_name
from actor
where last_name like '%LI%'
group by last_name, first_name
order by last_name, first_name
;

#2d. Using IN, display the country_id and country columns of 
#the following countries: Afghanistan, Bangladesh, and China:

select
	country_id,
    country
from country
where country in('Afghanistan', 'Bangladesh', 'China')
;

#3a. Create a column in the table actor named description and use the data type 
#BLOB.

alter table actor add column description blob ;
select * from actor;

#3b. Entering descriptions 
#for each actor is too much effort. Delete the description column.

alter table actor drop column description;
select * from actor;

#accidentally mispelled description as descriptiom
#delete that column as well

alter table actor drop column descriptiom;
select * from actor;


#4a. List the last names of actors, as well as how many actors 
#have that last name.

select 
	count(actor_id) as 'Number of Actors',
    last_name
from actor
group by last_name
;


#4b. List last names of actors and the number of actors who have
#that last name, but only for names that are shared by at least two actors

select 
	actor_id,
	count(last_name) 'Number of Actors',
    last_name
from actor
group by last_name
having count(last_name) >= 2
;


#4c. The actor HARPO WILLIAMS was accidentally entered in the actor 
#table as GROUCHO WILLIAMS. Write a query to fix the record.

update actor
set last_name = 'Williams', first_name= 'Harpo'
WHERE last_name = 'Williams' and first_name = 'Groucho';

#check
select *
	from actor
where first_name='Harpo';

#4d. It turns out that GROUCHO was the correct name. In 
#a single query, if the first name of the actor is currently HARPO, 
#change it to GROUCHO.

update actor
set first_name='Groucho'
WHERE last_name = 'Williams' and first_name = 'Harpo';

#5a. Cannot locate the schema of the address table so re-create it.

CREATE TABLE address1 (
  address_id int(5) NOT NULL AUTO_INCREMENT,
  address varchar(50) DEFAULT NULL,
  address2 varchar(50),
  district varchar(20),
  city_id int(5),
  postal_code varchar(10),
  phone varchar(20),
  location GEOMETRY,
  last_update TIMESTAMP,
  primary key (address_id)
);

#check
select * from address1;

#6a. Use JOIN to display the first and last names, as well as 
#the address, of each staff member. Use the tables staff and address:


select
    staff.first_name, 
    staff.last_name, 
	address.address, 
    address.address2
from staff
inner join address on staff.address_id=address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff 
#member in August of 2005. Use tables staff and payment.

select
	staff.first_name,
    staff.last_name,
    sum(payment.amount) 'Total Amount $'
from staff
inner join payment on staff.staff_id=payment.staff_id
where payment_date = '08/01/2005 00:00:00' and '08/31/2005 23:59:59'
group by staff.staff_id;

#6c. List each film and the number of actors who are listed for that
#film. Use tables film_actor and film. 

select
	film.title,
	count(film_actor.actor_id) 'Number of Actors'
from film_actor
inner join film on film.film_id = film_actor.film_id
group by film.film_id, film.title;


#6d. Number of copies of the film Hunchback Impossible existing in the
#inventory system?

select
    count(film_id)
    from inventory
    where film_id in 
		(
			select film_id
				from film
				where title='Hunchback Impossible'
                );
                
#There are 6 copies of Hunchback Impossible


#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically 
#by last name:

select 
    customer.first_name,
    customer.last_name,
   	sum(payment.amount) as 'Total Amount Paid'
from customer
join payment on customer.customer_id=payment.customer_id
group by payment.customer_id
order by customer.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also 
#soared in popularity. Use subqueries to display the titles of movies starting 
#with the letters K and Q whose language is English.

select title
    from film 
		where language_id 
        in ( 
			select language_id 
            from language
            where name = 'English' 
            )
            and title like 'K%' or title like 'Q%'; 

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name,
	   last_name
		from actor 
			where actor_id
            in (
               select actor_id
               from film_actor
				where film_id 
                in (
					select film_id
						   from film
                           where title = 'Alone Trip'
				   )
				);
              
#7c. Run an email marketing campaign in Canada, for which 
#the names and email addresses will be needed 
#of all Canadian customers. Use joins to retrieve this 
#information.


#Using a subquery
select first_name,
	   last_name,
       email
       from customer
       where address_id 
       in (
		select address_id
			from address
			where city_id
            in (
				select 
					   city_id
					   from city
                       where country_id
                       in (
							select country_id
								from country
								where country = 'Canada'
						  )
                 )
			);

#Using Joins

SELECT  u.first_name, u.last_name, u.email
FROM  customer u
INNER JOIN address a  ON u.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country o ON c.country_id = o.country_id
where o.country = 'Canada';




#7d. Sales have been lagging among young families, so target all family 
#movies for a promotion. Identify all movies categorized as family films.

select title
       from film
       where film_id 
       in (
		select film_id
			from film_category
			where category_id
            in (
				select category_id
					   from category
                       where name = 'Family'
			   )
		  );

#7e. Display the most frequently rented movies in descending order.

        
SELECT  title, count(i.film_id) as 'Number of rentals'
FROM    film f
INNER JOIN inventory i  ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
group by f.title
order by count(i.film_id) desc;


#7f. Write a query to display how much business, in dollars, each store brought in.

#Calculate gross so no deductions

SELECT  i.store_id, sum(p.amount) as 'Gross $'
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
group by i.store_id
order by sum(p.amount);


#7g. Write a query to display for each store its store ID, city, and country.
            
  
SELECT store_id, city, country
from country o 
inner join city c on o.country_id = c.country_id
inner join address a on c.city_id = a.city_id
inner join store s on a.address_id = s.address_id
;


#7h. List the top five genres in gross revenue in descending order. 

            
#Gross revenue is prior to any deductions

SELECT c.name, sum(p.amount)
FROM category c
INNER JOIN film_category f  ON c.category_id = f.category_id
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
group by c.name
order by count(c.category_id) desc
limit 5;


#8a. Want an easy way of viewing
#the top five genres by gross revenue. Using the solution from the query above to 
#create a view. 

CREATE VIEW  GrossRev AS
SELECT c.name, sum(p.amount) 'Gross Revenue'
FROM category c
INNER JOIN film_category f  ON c.category_id = f.category_id
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
group by c.name
order by count(c.category_id) desc
limit 5;

#8b. Display the view created in 8a.
select * from GrossRev;

#8c. I no longer need the view GrossRev. Write a query to delete it.
DROP VIEW GrossRev;




