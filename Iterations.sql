use sakila;

-- Write a query to find what is the total business done by each store.
select s.store_id, sum(p.amount) as total_bussiness from store as s
	join staff using(store_id)
    join payment as p using(staff_id)
    group by s.store_id;
    
-- Convert the previous query into a stored procedure.
DELIMITER //
CREATE PROCEDURE all_stores_turnover()
Begin

	select s.store_id, sum(p.amount) as total_bussiness from store as s
	join staff using(store_id)
    join payment as p using(staff_id)
    group by s.store_id;

End;
// DELIMITER ;

call all_stores_turnover();

-- Convert the previous query into a stored procedure that takes the input for store_id 
-- and displays the total sales for that store.
DELIMITER //
CREATE PROCEDURE per_store_turnover(in store int)
Begin
	select s.store_id, sum(p.amount) as total_sales from store as s
	join staff using(store_id)
    join payment as p using(staff_id)
    where s.store_id = store
    group by s.store_id;

End;
// DELIMITER ;

call per_store_turnover(1);
call per_store_turnover(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will 
-- store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
DELIMITER //
CREATE PROCEDURE per_store_turnover_result(in store int, out total_sales float)
Begin
	select  sum(p.amount) into total_sales from store as s
	join staff using(store_id)
    join payment as p using(staff_id)
    where s.store_id = store
    group by s.store_id;

End;
// DELIMITER ;

call per_store_turnover_result(1, @total_sales_1);
select @total_sales_1;

call per_store_turnover_result(2, @total_sales_2);
select @total_sales_2;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, 
-- then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input 
-- as the store_id and returns total sales value for that store and flag value.
DELIMITER //
CREATE PROCEDURE store_turnover_flag(in store int, out total_sales float, out total_sales_flag varchar(10))
Begin
	select  sum(p.amount) into total_sales from store as s
	join staff using(store_id)
    join payment as p using(staff_id)
    where s.store_id = store
    group by s.store_id;

	if total_sales > 30000 then set total_sales_flag = 'green_flag';
    else set total_sales_flag = 'red_flag';
    end if;

End;
// DELIMITER ;

call store_turnover_flag(1, @total_sales_1, @total_sales_flag);
select @total_sales_1, @total_sales_flag;

call store_turnover_flag(2, @total_sales_2, @total_sales_flag);
select @total_sales_2, @total_sales_flag;

 
