-- ====================================================================
-- SQL RETAIL SALES ANALYSIS PORTFOLIO PROJECT
-- Database: PostgreSQL | Tool: PG admin 4
-- ====================================================================

-- --------------------------------------------------------------------
-- STEP 1: DATABASE & TABLE SETUP
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(25),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- --------------------------------------------------------------------
-- STEP 2: DATA CLEANING (Removing records with critical missing values)
-- --------------------------------------------------------------------
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- --------------------------------------------------------------------
-- STEP 3: EXPLORATORY DATA ANALYSIS (EDA)
-- --------------------------------------------------------------------

-- Check total record count
SELECT COUNT(*) AS total_sale 
FROM retail_sales;

-- Check total unique customer reach
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail_sales;

-- Check available product categories
SELECT DISTINCT category 
FROM retail_sales;


-- --------------------------------------------------------------------
-- STEP 4: SOLVING KEY BUSINESS PROBLEMS
-- --------------------------------------------------------------------

-- Q1: Retrieve all columns for sales made on a specific day (2022-11-05)
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';


-- Q2: Retrieve transactions for 'Clothing' category with quantity >= 4 in November 2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
  AND quantity >= 4;


-- Q3: Calculate the total sales (net sale) and total orders for each category
SELECT 
    category, 
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY 1;


-- Q4: Find the average age of customers who purchased items from the 'Beauty' category
SELECT 
    ROUND(AVG(age), 2) AS average_age 
FROM retail_sales 
WHERE category = 'Beauty';


-- Q5: Find all transactions where the total sale is greater than 1000
SELECT * FROM retail_sales 
WHERE total_sale > 1000;


-- Q6: Find the total number of transactions made by each gender in each category
SELECT 
    category, 
    gender, 
    COUNT(*) AS total_transactions 
FROM retail_sales 
GROUP BY 1, 2 
ORDER BY 1;


-- Q7: Find the best-selling month in each year based on average sales
SELECT year, month, avg_sale 
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS T1
WHERE rank = 1;


-- Q8: Find the top 5 customers based on the highest total sales
SELECT 
    customer_id, 
    SUM(total_sale) AS total_sales 
FROM retail_sales 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5;


-- Q9: Find the number of unique customers who purchased items from each category
SELECT 
    category, 
    COUNT(DISTINCT customer_id) AS unique_customer_count 
FROM retail_sales 
GROUP BY category;


-- Q10: Segregate sales into shifts (Morning, Afternoon, Evening) and find order counts
WITH hourly_sales AS (
    SELECT *,
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift, 
    COUNT(*) AS total_orders 
FROM hourly_sales 
GROUP BY shift;
