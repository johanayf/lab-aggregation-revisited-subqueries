##Write a query to find what is the total business done by each store.
select c.store_id, round(sum(p.amount)) as total_sales
from payment p
left join customer c using(customer_id)
group by c.store_id;

##Convert the previous query into a stored procedure.
delimiter //
create procedure store_sales()
begin
select c.store_id, round(sum(p.amount)) as total_sales
from payment p
left join customer c using(customer_id)
group by c.store_id;
end
//
delimiter ;
call store_sales();

##Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
delimiter //
create procedure store_sales_filter(in id_store int)
begin
select c.store_id, round(sum(p.amount)) as total_sales
from payment p
left join customer c using(customer_id)
group by c.store_id
having c.store_id = id_store;
end
//
delimiter ;
call store_sales_filter(2);

##Update the previous query. Declare a variable total_sales_value of float type, 
##that will store the returned result (of the total sales amount for the store). 
##Call the stored procedure and print the results.
drop procedure store_sales_filter1;
delimiter //
create procedure store_sales_filter1(in id_store int, out total_sales_value varchar(20))
begin
##declare total_sales_value varchar(20) default "";
select round(sum(p.amount)) into total_sales_value 
from payment p
left join customer c using(customer_id)
group by c.store_id
having c.store_id = id_store;
end
//
delimiter ;
call store_sales_filter1(1, @total_sales_value);
select @total_sales_value;


##In the previous query, add another variable flag. 
##If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
##Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
drop procedure store_sales_filter2;
delimiter //
create procedure store_sales_filter2(in id_store int, out total_sales_value varchar(20), out sales_type varchar(20))
begin
select round(sum(p.amount)) as amount into total_sales_value
from payment p
left join customer c using(customer_id)
group by c.store_id
having c.store_id = id_store;
select case 
when total_sales_value>30000 then "green_flag"
else "red_flag" 
end
as salestype into sales_type;
end
//
delimiter ;
call store_sales_filter2(1, @x, @y);
select @x, @y;
