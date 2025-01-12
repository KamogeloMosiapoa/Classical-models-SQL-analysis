-- Please give an overview of sales for 2004,return the breakdown by product,country and city and include sales values, net profit and cost of sales.
select t1.orderDate, t1.orderNumber, productName, city, country, priceEach, productLine, buyPrice, quantityOrdered
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join products t3
on t2.productCode = t3.productCode
inner join customers t4
on t1.customerNumber = t4.customerNumber
where year(orderDate) = 2004;

-- Give a breakdown of products commonly purchased together
with prod_sales as
( 
select ordernumber, t1.productCode, productLine
from orderdetails t1
inner join products t2
on t1.productCode = t2.productCode
)

select t1.ordernumber, t1.productline as product_1, t2.productline as product_2
from prod_sales t1
left join prod_sales t2
on t1.ordernumber = t2.ordernumber and t1.productline <> t2.productline;

--  a breakdown of sales but also show their credit limit
with sales as
(
select t1.orderNumber, t1.customernumber, productcode, quantityOrdered, priceEach, priceeach * quantityOrdered as sales_value, creditLimit
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join customers t3
on t1.customerNumber = t3.customerNumber
)

select ordernumber, customernumber, 
case when creditlimit < 75000 then 'a:Less than $75k'
when creditlimit between 75000 and 100000 then 'b: $75k - $100k'
when creditlimit between 100000 and 150000 then 'b: $100k - $150k'
when creditlimit > 150000 then 'd:More than $150k'
else 'other'
end as creditlimit_group
, sum(sales_value) as sales_value
from sales 
group by ordernumber, customernumber, creditlimit_group;

-- provide an overview for customer sales, including a column that shows the difference in value from their previous sale.
with main_cte as
(
select ordernumber, orderdate, customernumber, sum(sales_value) as sales_value
from 
(select t1.ordernumber, orderdate, customernumber, productcode, quantityordered * priceeach as sales_value
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber) main
group by ordernumber, orderdate, customernumber
),

sales_query as 
(
select t1.*, customername, row_number() over (partition by customername order by orderdate) as purchase_number, 
lag(sales_value) over (partition by customername order by orderdate) as prev_sales_value
from main_cte t1
inner join customers t2
on t1.customernumber = t2.customernumber
)
select *, sales_value - prev_sales_value as purchase_value_change
from sales_query
where prev_sales_value is not null;

-- Can you show us a view of where the customer of each office are located.
with main_cte as
(
select t1.ordernumber,
t2.productcode, t2.quantityordered, t2.priceeach,
quantityordered * priceeach as sales_value, t3.city as customer_city,
t3.country as customer_country, t4.productline, t6.city as office_city, t6.country as office_country
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join customers t3
on t1.customerNumber = t3.customerNumber
inner join products t4
on t2.productCode = t4.productCode
inner join employees t5
on t3.salesRepEmployeeNumber= t5.employeeNumber
inner join offices t6
on t5.officeCode = t6.officeCode
)

select 
ordernumber, customer_city, customer_country, productline, office_city, office_country, sum(sales_value) as sales_value
from main_cte
group by 
ordernumber, customer_city, customer_country, productline, office_city, office_country;

-- list of affected orders.
select *, date_add(shippeddate, interval 3 day) as latest_arrival,
case when date_add(shippeddate, interval 3 day) > requireddate then 1 else 0 end as late_flag
from orders
where 
(case when date_add(shippeddate, interval 3 day) > requireddate then 1 else 0 end) = 1;
