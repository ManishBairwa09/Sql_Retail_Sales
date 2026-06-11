# 🛒 Retail Sales Analysis — SQL Project

![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-blue?style=flat&logo=postgresql)
![Level](https://img.shields.io/badge/Level-Beginner-green?style=flat)
![Database](https://img.shields.io/badge/Database-p1__retail__db-orange?style=flat)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)

---

## 📌 Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

A end-to-end SQL project that demonstrates core data analyst skills — from setting up a database to cleaning data and answering real business questions using structured queries.

> **Goal**: Analyze retail sales data to uncover insights around customer behavior, product performance, and sales trends.

---

## 🎯 Objectives

| # | Objective |
|---|-----------|
| 1 | Set up and populate a retail sales database |
| 2 | Clean data by identifying and removing null records |
| 3 | Perform Exploratory Data Analysis (EDA) |
| 4 | Answer business questions using SQL queries |

---

## 🗂️ Database Schema

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales (
    transactions_id   INT PRIMARY KEY,
    sale_date         DATE,
    sale_time         TIME,
    customer_id       INT,
    gender            VARCHAR(10),
    age               INT,
    category          VARCHAR(35),
    quantity          INT,
    price_per_unit    FLOAT,
    cogs              FLOAT,
    total_sale        FLOAT
);
```

---

## 🧹 Data Exploration & Cleaning

```sql
-- Total records
SELECT COUNT(*) FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Unique categories
SELECT DISTINCT category FROM retail_sales;

-- Check for nulls
SELECT * FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Remove null records
DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
   OR gender IS NULL OR age IS NULL OR category IS NULL
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

---

## 📊 Business Questions & Queries

### 1. Sales on a Specific Date
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2. Clothing Sales in Nov-2022 (qty ≥ 4)
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

### 3. Total Sales per Category
```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
```

### 4. Average Customer Age in Beauty Category
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5. High-Value Transactions (> 1000)
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 6. Transactions by Gender & Category
```sql
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

### 7. Best Selling Month Each Year
```sql
SELECT year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date)  AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale)               AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t1
WHERE rank = 1;
```

### 8. Top 5 Customers by Total Sales
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### 9. Unique Customers per Category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### 10. Orders by Time Shift
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12              THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## 📈 Key Findings

- 👥 **Customer Demographics** — Customers span diverse age groups across Clothing and Beauty categories
- 💰 **High-Value Transactions** — Several transactions exceeded 1000, pointing to premium buying behavior
- 📅 **Sales Trends** — Monthly analysis reveals clear peak seasons for targeted campaigns
- 🏆 **Top Customers** — A small segment drives a disproportionate share of total revenue

---

## 📁 Project Structure

```
Sql_Retail_Sales/
│
├── Retail_sales_1st.sql                 # All queries — setup, cleaning, analysis
├── SQL - Retail Sales Analysis_utf.csv  # Raw dataset
└── README.md                            # Project documentation
```

---

## 🚀 How to Use

```bash
# 1. Clone the repo
git clone https://github.com/ManishBairwa09/Sql_Retail_Sales.git

# 2. Open PostgreSQL and create the database
CREATE DATABASE p1_retail_db;

# 3. Run the SQL file
psql -U postgres -d p1_retail_db -f Retail_sales_1st.sql
```

---

## 🛠️ Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Query%20Language-lightgrey?style=flat)

---

## 🙋‍♂️ Author

**Manish Bairwa**  
🐙 [GitHub](https://github.com/ManishBairwa09)

---

⭐ If you found this project helpful, please give it a star!
