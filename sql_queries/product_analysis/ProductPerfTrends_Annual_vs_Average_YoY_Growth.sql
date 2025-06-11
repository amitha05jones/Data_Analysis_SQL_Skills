/**************************************************************************************************
Product Performance Trends: Annual vs. Average & YoY Growth
***************************************************************************************************
Business Question: Product management needs a comprehensive view of individual product performance trends.
For each product, identify its annual sales performance relative to its historical average,
and determine its year-over-year sales growth (or decline).

Purpose for a Business Analyst:
- Performance Monitoring: Quickly identify products that are excelling, stagnating, or declining.
- Strategic Decision-Making: Inform decisions on product investment, marketing focus, or discontinuation.
- Historical Context: Provides valuable context by comparing current performance to past trends.

SQL Skills:
- Common Table Expressions (CTE),YEAR(), SUM(), GROUP BY,AVG() (as a Window Function), LAG() (Window Function), Window Functions (PARTITION BY, ORDER BY)
***************************************************************************************************/

WITH prod_yr_rev AS(
-- Calculates the total sales revenue for each product per year.
SELECT 
    year(order_date) AS OrderYear ,
    product_name AS ProductName , 
    SUM(sales_amount) AS Total_revenue
FROM
    gold_fact_sales gfs
        LEFT JOIN
    gold_dim_products gdp ON gfs.product_key = gdp.product_key
where year(order_date) is not null
Group by year(order_date), product_name
order by product_name,year(order_date))  

SELECT 
	OrderYear, 
    ProductName, 
    Total_revenue, 
     -- Calculates the product's overall average annual revenue across all years.
    cast(avg(Total_revenue) over (partition by ProductName) as signed) as AvgAnnualRevenue ,
    -- Calculates the difference between current annual revenue and the product's average annual revenue.
	Total_revenue - cast(avg(Total_revenue) over (partition by ProductName) as signed) as DiffFromAvg,
    -- Categorize current annual performance relative to the product's overall average.
    CASE
		WHEN Total_revenue - cast(avg(Total_revenue) over (partition by ProductName) as signed) < 0 then 'Below avg'
        WHEN Total_revenue - cast(avg(Total_revenue) over (partition by ProductName) as signed) = 0 THEN 'Avg'
        ELSE 'Above avg'
	END AS PerformanceCategory,
    -- Get the sales revenue from the previous year for the same product.
    LAG(Total_revenue) over (partition by ProductName order by OrderYear) as PrevYearRevenue,
    -- Calculate the absolute difference in sales from the previous year.
    Total_revenue - LAG(Total_revenue) over (partition by ProductName order by OrderYear)  AS DiffFromPrevYear,
    -- Categorize the year-over-year growth trend.
    CASE
		WHEN Total_revenue - LAG(Total_revenue) over (partition by ProductName order by OrderYear) > 0 THEN '+VE'
        WHEN Total_revenue - LAG(Total_revenue) over (partition by ProductName order by OrderYear) < 0 THEN '-VE'
        ELSE 'No change'
	END AS YoYTrend
FROM prod_yr_rev; -- Reference the CTE