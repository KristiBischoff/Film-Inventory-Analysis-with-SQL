
#Analysis of film catalog and inventory data
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
;

#2d. Using IN, display the country_id and country columns of 
#the following countries: Afghanistan, Bangladesh, and China:

select
	country_id,
    country
from country
where country in('Afghanistan', 'Bangladesh', 'China')
;

#3a. You want to keep a description of each actor. You don't 
#think you will be performing queries on a description, so create a 
#column in the table actor named description and use the data type 
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

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! In 
#a single query, if the first name of the actor is currently HARPO, 
#change it to GROUCHO.

update actor
set first_name='Groucho'
WHERE last_name = 'Williams' and first_name = 'Harpo';

#5a. Cannot locate the schema of the address table so re-create it.


#6a. Use JOIN to display the first and last names, as well as 
#the address, of each staff member. Use the tables staff and address:


#6b. Use JOIN to display the total amount rung up by each staff 
#member in August of 2005. Use tables staff and payment.


#6c. List each film and the number of actors who are listed for that
#film. Use tables film_actor and film. Use inner join.


#6d. How many copies of the film Hunchback Impossible exist in the
#inventory system?


#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically 
#by last name:


