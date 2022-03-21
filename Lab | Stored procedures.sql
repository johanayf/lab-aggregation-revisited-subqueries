##In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
##Convert the query into a simple stored procedure. Use the following query:
delimiter $$
create procedure Action_fans()
Begin
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  end;
  $$
  delimiter ;
  call Action_fans();
  
  ##Now keep working on the previous stored procedure to make it more dynamic. 
  ##Update the stored procedure in a such manner that it can take a string argument for the category name and 
  ##return the results for all customers that rented movie of that category/genre. 
  ##For eg., it could be action, animation, children, classics, etc.
  
  drop procedure Cateogry_filter;
  delimiter $$
create procedure Cateogry_filter(in cat char(30))
Begin
select concat(first_name, ' ', last_name) as name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = cat
  group by first_name, last_name, email;
  end;
  $$
  delimiter ;
  call Cateogry_filter('action');
  
  ##Write a query to check the number of movies released in each movie category. 
  select cat.name, count(fc.film_id) as amount 
  from film_category fc
  left join category cat using(category_id)
  group by cat.name;
  
  ##Convert the query in to a stored procedure to filter only those categories 
  ##that have movies released greater than a certain number. 
  ##Pass that number as an argument in the stored procedure.
  drop procedure movie_filter;
  delimiter //
  create procedure movie_filter(in num int)
  begin
select cat.name, count(fc.film_id) as amount 
  from film_category fc
  left join category cat using(category_id)
  group by cat.name
  having amount > num;
  end //
  delimiter ; 
  call movie_filter(66);
  