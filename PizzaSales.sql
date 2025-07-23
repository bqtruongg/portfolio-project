-- 1. Total Revenue: The sum of the total price of all pizza orders.
-- 2. Average Order Value: The average amount spent per order, calculated by dividing the total revenue by 
-- the total number of orders.
-- 3. Total Pizzas Sold: The sum of the quantities of all pizzas sold.
-- 4. Total Orders: The total number of orders placed.
-- 5. Average Pizzas Per Order: The average number of pizzas sold per order, calculated by
-- dividing the total number of pizzas sold by the total number of orders.

-----------------------------------------------------------------------------------------------------------------------
SELECT * 
FROM PizzaDB..pizza_sales

-- 1. Total Revenue
SELECT SUM(total_price) as TotalRevenue
FROM PizzaDB..pizza_sales

-- 2. Average Order
--SELECT SUM(total_price) as TotalRevenue,
--SELECT COUNT(DISTINCT(order_id))
--FROM PizzaDB..pizza_sales
SELECT	SUM(total_price) as TotalRevenue, 
		COUNT(DISTINCT(order_id)) as TotalOrders, 
		SUM(total_price)/COUNT(DISTINCT(order_id)) as AverageOrder
FROM PizzaDB..pizza_sales

-- 3. Total Pizzas Sold
SELECT SUM(quantity) as TotalPizzaSould
FROM PizzaDB..pizza_sales

-- 4. Total Orders
SELECT COUNT(DISTINCT(order_id)) as TotalOrders
FROM PizzaDB..pizza_sales

-- 5. Average Pizzas Per Order
SELECT SUM(quantity) as TotalPizzaSould, 
		COUNT(DISTINCT(order_id)) as TotalOrders,
		CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10,2)) as AveragePizzasPerOrder
FROM PizzaDB..pizza_sales

-- Daily Trend
SELECT DATENAME(DW, order_date) as OrderDay, COUNT(DISTINCT order_id) as TotalOrders
FROM PizzaDB..pizza_sales
GROUP BY DATENAME(DW, order_date)

-- Hourly Trend
SELECT DATEPART(HOUR, order_time) as OrderHours, COUNT(DISTINCT order_id) as TotalOrders
FROM PizzaDB..pizza_sales
GROUP BY DATEPART(HOUR, order_time)

-- Percentage of Sales by Pizza Category
WITH TotalSales AS (
    SELECT SUM(total_price) AS grand_total
    FROM PizzaDB..pizza_sales
	WHERE MONTH(order_date) = 1
)

SELECT 
    pizza_category,
    SUM(total_price) AS TotalSales,
    ROUND(SUM(total_price) * 100.0 / grand_total, 2) AS PercentageOfSales
FROM 
    PizzaDB..pizza_sales, TotalSales
WHERE MONTH(order_date) = 1
GROUP BY 
    pizza_category, grand_total

-- Percentage of Sales by Pizza Size
WITH TotalSales AS (
    SELECT SUM(total_price) AS grand_total
    FROM PizzaDB..pizza_sales
)

SELECT 
    pizza_size,
    SUM(total_price) AS TotalSales,
    ROUND(SUM(total_price) * 100.0 / grand_total, 2) AS PercentageOfSales
FROM 
    PizzaDB..pizza_sales, TotalSales
GROUP BY 
    pizza_size, grand_total
ORDER BY grand_total DESC

-- Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as TotalPizzasSold
FROM PizzaDB..pizza_sales
GROUP BY pizza_category

-- Top 5 Best Sellers by Total Pizzas Sold
SELECT  TOP 5 pizza_name, SUM(quantity) as TotalPizzaSold
FROM PizzaDB..pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC

-- Bottom 5 Worst Sellers by Total Pizzas Sold
SELECT  TOP 5 pizza_name, SUM(quantity) as TotalPizzaSold
FROM PizzaDB..pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC