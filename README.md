# Classical-models-SQL-analysis
![classic model car banner without company wording](https://github.com/user-attachments/assets/41ec4575-6154-41f6-93f7-25cbd6b742ff)

## Project overview
This project involves analyzing data to gain insights into sales performance, customer behavior, inventory patterns, and customer segmentation for Classic Models using SQL.It processes data from the Classic Models database to generate visualizations and reports that aid in decision-making. .The project explores the practical use of SQL and Excel to address business-related queries and reveal insights.

---

## Objectives

- Data Cleaning: Identify and resolve records with missing or null values to ensure data quality.
- Data Exploration: Use SQL to explore and understand the dataset.
- Insights Generation: Answer business-driven questions through SQL queries to derive actionable.

## Tools

- SQL- used for data analyses
- Excel- used to create pivot tables annd visualizations to further answer business related questions.

## Project structure.

### Data cleaning 
- Checked for null or missing values across all columns using SQL queries.
- Removed rows containing null values to maintain data integrity.
- Replaced blanks prior to ctreaing pivot tables on Excel.

### Data exploration.
- Key Queries:
    - Counted total transactions and unique customers.
    - Identified distinct product categories.
    - Aggregated transaction data to analyze customer demographics and high-value transactions.

 ---
## Data Cleaning 
### Steps Undertaken
1) Detecting Nulls:Used SQL queries with OR conditions and CASE statements to find missing values in key columns.
2) Removing Null Records:Deleted rows with null values using the DELETE statement to ensure data consistency.
3) Validation:Verified the updated record count to confirm successful cleanup.

## Exploratory Data Analysis
EDA involved exploring the Netflix data to answer key questions, such as:
- Give an overview of sales for 2004,return the breakdown by product,country and city,and include sales values, net profit and cost of sales.
- Give a breakdown of products commonly purchased together,and any products rarely purchased together.
- What is the sales overview by country.
- Provide a breakdown of sales but also show their credit limit. I want a high value view to see if we get higher sales for customers who have a higher credit limit which would be expected.
- Please provide an overview for customer sales, including a column that shows the difference in value from their previous sale.
- Can you show us a view of where the customers of each office are located.
- Provide a list of affected orders.

### Sample Queries:
```
select t1.orderDate, t1.orderNumber, productName, city, country, priceEach, productLine, buyPrice, quantityOrdered
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join products t3
on t2.productCode = t3.productCode
inner join customers t4
on t1.customerNumber = t4.customerNumber
where year(orderDate) = 2004
```

```
select *, date_add(shippeddate, interval 3 day) as latest_arrival,
case when date_add(shippeddate, interval 3 day) > requireddate then 1 else 0 end as late_flag
from orders
where 
(case when date_add(shippeddate, interval 3 day) > requireddate then 1 else 0 end) = 1
```

---
## Insights and conclusion
- Trucks and busses and Classic cars have a 52.17% chance likelyhood of being purchased together, whereas Trains and Planes have only 0.78% likelyhood making them the least purchased as a pair.
- Higher sales do not come from customers with the most credit limit of +$150k, most sales are made by customers with a credit limit between $100k and $150k.
- Returning customers do not usually spend more on their second purchase.
- USA has the most sales relative to Classic Car offices in other countries.
