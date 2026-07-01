-- Databricks notebook source
---Specifying the database and schema to be used
USE CATALOG brightcoffee;
USE SCHEMA shop;


-----Previewing dataset
SELECT * 
FROM sales;

----Describing the data types and check for nulls in each column
DESCRIBE TABLE brightcoffee.shop.sales;

----Finding unique store locations
SELECT DISTINCT store_location
FROM brightcoffee.shop.sales;

---Finding all unique product types
SELECT DISTINCT product_type
FROM brightcoffee.shop.sales;

----Finding all unique product details
SELECT DISTINCT product_detail
FROM brightcoffee.shop.sales;

---Finding all unique product categories
SELECT DISTINCT product_category
FROM brightcoffee.shop.sales;

---Finding the total number of transactions
SELECT COUNT (DISTINCT transaction_id) AS Total_transactions
FROM brightcoffee.shop.sales

---Data range of dataset
SELECT MIN(transaction_date) AS earliest_date,
       MAX(transaction_date) AS latest_date
FROM brightcoffee.shop.sales;


---Checking for duplicates
SELECT
        transaction_id,
        COUNT(*)
FROM   brightcoffee.shop.sales
GROUP BY transaction_id
HAVING COUNT(*) >1;

---Remove time stamp
SELECT transaction_time,
       DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time
FROM brightcoffee.shop.sales;

---Transactions per day
SELECT transaction_date,
    COUNT(DISTINCT transaction_id) AS Total_transactions
FROM brightcoffee.shop.sales
GROUP BY transaction_date;

-----Transactions per month
SELECT MONTHNAME(transaction_date) AS month,
COUNT (DISTINCT transaction_id)  AS Total_transactions
FROM brightcoffee.shop.sales
GROUP BY month;

---Revenue per month
SELECT MONTHNAME(transaction_date) AS month,
  SUM(unit_price * transaction_qty)    AS Total_transactions
FROM brightcoffee.shop.sales
GROUP BY month;

---Changing unit price data type from string to bigint
SELECT MONTHNAME(transaction_date) AS month,
ROUND(SUM(CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.')AS DOUBLE)),2) AS Revenue
FROM brightcoffee.shop.sales
GROUP BY month;

SELECT 
ROUND(SUM(CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.')AS DOUBLE)),2) AS Revenue
FROM brightcoffee.shop.sales;

----Extracting transaction hours to idendify peak business traffic
SELECT HOUR(transaction_time) AS transaction_hour,
   COUNT(transaction_id) AS total_transactions
FROM  brightcoffee.shop.sales
GROUP BY HOUR (transaction_time)
ORDER BY transaction_hour ASC;

----Organising days of the week(Mond-Sun)
SELECT DAYNAME(transaction_date) AS day_name,
  WEEKDAY(transaction_date) AS weekday_number
FROM brightcoffee.shop.sales
GROUP BY DAYNAME(transaction_date),
 WEEKDAY(transaction_date)
ORDER BY weekday_number ASC;




----Counting the number of rows in the table and checking for duplicate transaction_IDs
SELECT COUNT(Transaction_id)  AS Trans_ID_Count,
       COUNT(DISTINCT transaction_id) AS Dist_Trans_ID_Count
FROM sales;

----Finding rows containing nulls
SELECT *
FROM sales
WHERE transaction_id IS NULL
      OR transaction_date IS NULL
      OR transaction_time IS NULL
      OR transaction_qty IS NULL
      OR unit_price IS NULL
      OR store_location IS NULL
      OR store_location IS NULL
      OR product_ID IS NULL
      OR product_category IS NULL
      OR product_type  IS NULL
      OR product_detail IS NULL;

-----Calculating products which generate the most revenue
SELECT 
    product_category,
    product_type,
    ROUND(SUM(CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)), 2) AS Revenue,
    SUM(transaction_qty) AS total_Units_Sold
FROM brightcoffee.shop.sales
GROUP BY product_category, product_type
ORDER BY Revenue DESC;

----Check min,max and average
SELECT ROUND(SUM(CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.')AS DOUBLE)),2) AS Revenue,
    MIN(CAST(REPLACE(unit_price,',','.')AS DOUBLE)) AS min_price,
    MAX(CAST(REPLACE(unit_price,',','.')AS DOUBLE)) AS max_price,        
    ROUND (AVG(CAST(REPLACE(unit_price,',','.')AS DOUBLE)),2) AS avg_price,
    MIN(transaction_qty)   AS min_qty,
    MAX(transaction_qty)     AS max_qty
FROM brightcoffee.shop.sales;



----CASE Statements (Buckets)
SELECT transaction_time,
       DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time,
       CASE
         WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
         WHEN HOUR(transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
         WHEN HOUR(transaction_time) BETWEEN 13 AND 10 THEN 'Late Afternoon'
          ELSE 'Evening'
        END AS time_bucket
FROM brightcoffee.shop.sales;


SELECT DAYNAME(transaction_date),
       DAYOFWEEK(transaction_date),
        CASE
          WHEN DAYNAME(transaction_date) IN('Sat','Sun') THEN 'Weekend'
           ELSE 'Weekday'
        END AS day_type
FROM  brightcoffee.shop.sales;


---------------------------------------------------------------------------------------------------
--FINAL BIG QUERY

SELECT transaction_id,
       transaction_date,
       DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time, ----Clean time(Removes timestamp formatting)
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,
       DAYNAME(transaction_date)  AS day_name,  -----Dayname (Mond,Tue,Wed,...)
       MONTHNAME(transaction_date) AS month_name, ----- Monthname (Jan,Febr,Mar,...)
       DAYOFMONTH(transaction_date) AS day_number, -----Day of month (1-31)
       CASE
          WHEN DAYNAME(transaction_date) IN('Sat','Sun') THEN 'Weekend'
           ELSE 'Weekday'
        END AS day_type ,        ----Weekend vs Weekday

        CASE
         WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
         WHEN HOUR(transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
         WHEN HOUR(transaction_time) BETWEEN 13 AND 10 THEN 'Late Afternoon'
          ELSE 'Evening'
        END AS time_bucket,        ----Time bucket

        CASE
         WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early month'
         WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid month'
         ELSE 'Month end'
         END AS month_period,    ----Month period bucket

CASE
  WHEN (CAST(transaction_qty AS DOUBLE)* CAST(REPLACE(unit_price,',','.')AS DOUBLE)) <=50 THEN 'Cheap Spend'
  WHEN (CAST(transaction_qty AS DOUBLE)* CAST(REPLACE(unit_price,',','.')AS DOUBLE)) BETWEEN 51 AND 200 THEN 'Low Spend'
  WHEN (CAST(transaction_qty AS DOUBLE)* CAST(REPLACE(unit_price,',','.')AS DOUBLE)) BETWEEN 201 AND 300 THEN 'Low Spend'
  ELSE 'Expensive Spend'
END AS spend_bucket,

  CASE
     WHEN transaction_qty BETWEEN 1 AND 2 THEN 'Personal order'
     WHEN transaction_qty BETWEEN 3 AND 5 THEN 'Small group order'
     ELSE 'Bulk order'
    END AS order_size_category,

CAST(REPLACE(unit_price,',','.')AS DOUBLE) AS clean_unit_price, ---Clean numeric price
ROUND((CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',','.')AS DOUBLE)),2) AS Revenue, ---Revenue per row
HOUR(transaction_time) AS transaction_hour,
WEEKDAY(transaction_date) AS weekday_number
FROM   brightcoffee.shop.sales;









