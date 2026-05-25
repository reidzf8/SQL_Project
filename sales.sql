CREATE DATABASE Retail_Sales_Analysis;

CREATE TABLE Sales_Analysis (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT, 
	gender VARCHAR (10),
	age	INT, 
	category VARCHAR (15),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM sales_analysis
LIMIT 10;

SELECT COUNT(*) FROM sales_analysis;

-- Data Cleaning
SELECT * FROM sales_analysis
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

DELETE FROM sales_analysis
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Data Exploraion 
-- How many sales we have?\
SELECT COUNT(*) as total_sale From sales_analysis;

-- How many uniuque customer we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM sales_analysis;

SELECT DISTINCT category FROM sales_analysis;

-- Business Key Problem 
-- My Analysis  Findings
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- 1. Tulis kueri SQL untuk mengambil semua kolom untuk penjualan yang dilakukan pada '2022-11-05':

SELECT * FROM sales_analysis
WHERE sale_date = '2022-11-05';

-- 2. Tulis kueri SQL untuk mengambil semua transaksi di mana kategorinya adalah 'Pakaian' dan kuantitas yang terjual lebih dari 4 pada bulan November 2022:

SELECT * FROM sales_analysis
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy >= 4;

-- 3. Tulis kueri SQL untuk menghitung total penjualan (total_sale) untuk setiap kategori.

SELECT category, SUM(total_sale) as Net_sale
FROM sales_analysis
GROUP BY 1;

-- 4. Tulis kueri SQL untuk menemukan usia rata-rata pelanggan yang membeli barang dari kategori 'Kecantikan'.

SELECT ROUND(AVG(age)) as Avg_Age
FROM sales_analysis
WHERE category = 'Beauty';

-- 5. Tulis kueri SQL untuk menemukan semua transaksi di mana total_sale lebih besar dari 1000.

SELECT * FROM sales_analysis
WHERE total_sale > 1000;

-- 6. Tulis kueri SQL untuk menemukan jumlah total transaksi (transaction_id) yang dilakukan oleh setiap jenis kelamin di setiap kategori.

SELECT category, gender, COUNT(*) as total_transaction
FROM sales_analysis
GROUP BY category, gender
ORDER BY 1;

-- 7. Tulis kueri SQL untuk menghitung rata-rata penjualan untuk setiap bulan. Cari tahu bulan penjualan terbaik setiap tahunnya

SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale, 
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)
	ORDER BY AVG(total_sale) DESC) as rank
FROM sales_analysis
GROUP BY 1, 2
)
WHERE rank = 1

-- 8. Tulis kueri SQL untuk menemukan 5 pelanggan teratas berdasarkan total penjualan tertinggi

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Tulis kueri SQL untuk menemukan jumlah pelanggan unik yang membeli barang dari setiap kategori.

SELECT category, COUNT(DISTINCT customer_id) as unique_customer
FROM sales_analysis
GROUP BY 1;

-- 10. Tulis kueri SQL untuk membuat setiap shift dan jumlah pesanan (Contoh Pagi <12, Siang Antara 12 & 17, Malam >17)

WITH hourly_sale
AS
(
SELECT *, 
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM sales_analysis
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)