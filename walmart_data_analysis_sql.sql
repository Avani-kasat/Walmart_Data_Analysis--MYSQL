create database if not exists WalmartSales;

create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15)  not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9),
gross_income decimal(10,2) not null,
rating float(4,1) 
);
select * from sales;

alter table sales add column time_of_day varchar(20);
select * from sales;
update sales set time_of_day=(CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END);
  select * from sales;
  
  select date,dayname(date) from sales;
  alter table sales add column day_name varchar(20);
  update sales set day_name=(dayname(date));
  select * from sales;
  
  select date,monthname(date) from sales;
  alter table sales add column month_name varchar(20);
  update sales set month_name=(monthname(date));
  select * from sales;
  
  /*
  Product Related Analysis
1)How many unique product lines does the data have?
2)What is the most common payment method?
3)What is the most selling product line?
4)What is the total revenue by month?
5)What month had the largest COGS?
6)What product line had the largest revenue?
7)What is the city with the largest revenue?
8)What product line had the largest VAT?
9)Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
10)Which branch sold more products than average product sold?
11)What is the most common product line by gender?
12)What is the average rating of each product line?
  */
  select distinct(city) as distinct_cities from sales;
  select distinct(city),branch from sales;
  select count(distinct(product_line)) from sales;
  select payment_method,count(payment_method) as count from sales group by payment_method order by count desc;
  select product_line,count(product_line) as count from sales group by product_line order by count desc;
  select distinct(month_name) from sales;
  select month_name as month, SUM(total) as total_revenue from sales group by month_name;
  select month_name,sum(cogs) as cogs_value from sales group by month_name order by cogs_value desc;
  select product_line,sum(total) as revenue from sales group by product_line order by revenue desc;
  select city,sum(total) as revenue from sales group by city order by revenue desc;
  select product_line,AVG(VAT) as vat from sales group by product_line order by vat desc;
  SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

SELECT
	product_line,ROUND(AVG(rating), 2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

/*
Customer Related Analysis
1)How many unique customer types does the data have?
2)How many unique payment methods does the data have?
3)What is the most common customer type?
4)Which customer type buys the most?
5)What is the gender of most of the customers?
6)What is the gender distribution per branch?
7)Which time of the day do customers give most ratings?
8)Which time of the day do customers give most ratings per branch?
9)Which day fo the week has the best avg ratings?
10)Which day of the week has the best average ratings per branch?
*/
SELECT DISTINCT customer_type FROM sales;
SELECT DISTINCT payment_method FROM sales;
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_cnt DESC;
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "A"
GROUP BY day_name
ORDER BY total_sales DESC;
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "B"
GROUP BY day_name
ORDER BY total_sales DESC;
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

/*
Sales Realted Analysis
1)Number of sales made in each time of the day per weekday
2)Which of the customer types brings the most revenue?
3)Which city has the largest tax percent/ VAT (Value Added Tax)?
4)Which customer type pays the most in VAT?
*/
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

SELECT
	city,
    ROUND(AVG(VAT), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

SELECT
	customer_type,
	AVG(VAT) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;