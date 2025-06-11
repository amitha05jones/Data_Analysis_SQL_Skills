/**************************************************************************************************
Products with Sales Decrease from Previous Quarter (CTE, Window Function & Aggregation)
***************************************************************************************************
Business Question: Product management wants to quickly spot products experiencing a decline.
Identify product_name where the total sales_amount in a quarter is lower than the total sales_amount in the immediately preceding quarter.

Purpose for a Business Analyst:
- Performance Monitoring: Provides a critical alert system for product managers to identify underperforming products.
- Proactive Intervention: Enables timely action, such as adjusting marketing campaigns, reassessing pricing, or reviewing inventory strategies, to mitigate further sales decline.
- Strategic Review: Supports deeper dives into why certain products are declining, helping to uncover market shifts, competitive pressures, or product quality issues.
- Inventory Management: Informs supply chain to reduce orders for declining products, preventing overstocking.

SQL Skills:
- Common Table Expressions (CTE); Date Functions: YEAR(), QUARTER(); Aggregation: SUM(), GROUP BY; 
Window Functions: LAG() (for comparing current vs. previous quarter sales); 
Partitioning and Ordering: PARTITION BY, ORDER BY (crucial for time-series window functions);
Filtering: WHERE (for identifying the specific decline condition)
***************************************************************************************************/
WITH ProductRevenueByQuarter AS(
 
SELECT
	p.product_key,
    product_name,
    YEAR(order_date) AS OrderYear,
    QUARTER(order_date) AS OrderQuarter,
    SUM(sales_amount) AS RevenueByQuarter -- Total sales amount for each product by year and quarter.
FROM gold_fact_sales s
    left join
    gold_dim_products p
    ON s.product_key=p.product_key
WHERE
	product_name IS NOT NULL
    AND order_date IS NOT NULL
    AND sales_amount IS NOT NULL
GROUP BY
	product_key,product_name,OrderYear,OrderQuarter)
 
 ,QuarterLag AS
(SELECT 
    -- Calculates the previous quarter's revenue for each product.
	product_name,
    OrderYear,
    OrderQuarter,
    RevenueByQuarter,
    -- LAG(revenue, 1, 0) retrieves the 'revenue' from the row 1 position before the current row
    LAG(RevenueByQuarter,1,0) OVER (PARTITION BY product_name ORDER BY OrderYear, OrderQuarter) AS PrevQuarterRevenue
FROM
	ProductRevenueByQuarter)
    
-- Identifies products where current quarter sales are lower than the previous quarter.
SELECT 
	product_name,
    OrderYear,
    OrderQuarter,
    RevenueByQuarter,
    PrevQuarterRevenue,
    CASE 
		WHEN PrevQuarterRevenue = 0 AND RevenueByQuarter > 0 THEN 'New Sales (No Prev Qtr)' -- First quarter with sales
        WHEN PrevQuarterRevenue = RevenueByQuarter THEN 'Sales Consistent'
		WHEN PrevQuarterRevenue < RevenueByQuarter THEN 'Sales increase'
        WHEN PrevQuarterRevenue > RevenueByQuarter THEN 'Sales descrease'
        ELSE 'Unknown Trend'
	END AS SalesIncOrDec
FROM
	QuarterLag
WHERE 
	PrevQuarterRevenue > RevenueByQuarter -- Filter condition: Current quarter sales are lower than previous quarter
ORDER BY
	product_name,
    OrderYear,
    OrderQuarter;
	
    