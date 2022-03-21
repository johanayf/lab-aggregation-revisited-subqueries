use sakila;
##Select the first name, last name, and email address of all the customers who have rented a movie.
select distinct c.first_name, c.last_name, c.email 
from rental as r
left join customer as c on r.customer_id = c.customer_id;

##What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select c.customer_id, concat(c.first_name, ' ', c.last_name), round(avg(p.amount), 2)
from payment as p
left join customer as c on c.customer_id = p.customer_id
group by p.customer_id;

##Select the name and email address of all the customers who have rented the "Action" movies.
##Write the query using multiple join statements
select concat(c.first_name, ' ', c.last_name) as name, c.email
from customer c 
left join rental using(customer_id)
left join inventory using(inventory_id)
left join film f using(film_id)
left join film_category fc using(film_id)
left join category cat using(category_id)
where cat.name = "Action";
;


##Write the query using sub queries with multiple WHERE clause and IN condition
select concat(first_name, ' ', last_name) as name, email
from customer
where customer_id in (select customer_id from rental where inventory_id in 
(select inventory_id from inventory where film_id in 
(select film_id from film where film_id in 
(select film_id from film_category where category_id in 
(select category_id from category where name = "Action")))));

##Verify if the above two queries produce the same results or not
select * from (select concat(c.first_name, ' ', c.last_name) as name, c.email
from customer c 
left join rental using(customer_id)
left join inventory using(inventory_id)
left join film f using(film_id)
left join film_category fc using(film_id)
left join category cat using(category_id)
where cat.name = "Action") sub where name not in (select concat(first_name, ' ', last_name) as name
from customer
where customer_id in (select customer_id from rental where inventory_id in 
(select inventory_id from inventory where film_id in 
(select film_id from film where film_id in 
(select film_id from film_category where category_id in 
(select category_id from category where name = "Action"))))));
##the resulte are the same! 

##Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
##If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, 
##and if it is more than 4, then it should be high.
select amount, 
case 
	when 0<amount<2 then 'low'
    when 2<amount<4 then 'medium'
    else 'high'
    end 
    as class
    from payment;