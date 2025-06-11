
/**************************************************************************************************
Cumulative Sales by Product Category Over Time (Window Function)
***************************************************************************************************
Business Question: Finance needs to monitor the cumulative sales performance of each product category throughout the year.
For each category, calculate the running total of sales_amount ordered by order_date (monthly granularity).

Purpose for a Business Analyst:
- Financial Monitoring: Provides a clear view of how sales are accumulating for each product category over time, allowing finance to track progress against targets.
- Trend Analysis: Helps identify growth or stagnation patterns within categories throughout a year or across multiple years.
- Performance Evaluation: Enables comparison of cumulative performance between different product categories.
- Budgeting & Forecasting: Supports more accurate future sales projections and budget allocations.

SQL Skills:
- Common Table Expressions (CTE); JOIN; Aggregation: SUM(), GROUP BY;  Date Functions:DATE_FORMAT();  Window Functions: SUM() OVER (PARTITION BY ... ORDER BY ...) for running totals
***************************************************************************************************/


WITH MonthlyRevenue AS (
SELECT 
	category,
    DATE_FORMAT(order_date, '%Y-%m') AS Order_month,
    -- total sales for each product category per month.
    SUM(sales_amount) AS Rev_by_month
FROM gold_fact_sales s
    left join
    gold_dim_products p
    ON s.product_key=p.product_key
WHERE
	category IS NOT NULL
    AND order_date IS NOT NULL
    AND sales_amount IS NOT NULL
GROUP BY
	category,
    Order_month )
    
SELECT 
	category,
    Order_month,
    Rev_by_month,
    -- running total (cumulative sum) of sales for each category.
    SUM(Rev_by_month) OVER (
			PARTITION BY category -- Partition by category to get cumulative sum per category
			ORDER BY Order_month  -- -- Order by the chronologically sortable date 
		) AS CumulativeSalesByCategory
FROM 
	MonthlyRevenue
;