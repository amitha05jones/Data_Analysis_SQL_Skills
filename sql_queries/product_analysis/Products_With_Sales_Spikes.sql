/**************************************************************************************************
Products with Sales Spikes (Subquery & Aggregation)
***************************************************************************************************
Business Question: The supply chain team needs to identify products with unusually high sales on a specific day compared to their average daily sales.
Find product_name and order_date where the daily sales_amount for a product is more than 3 times its overall average daily sales_amount.

Purpose for a Business Analyst:
- Anomaly Detection: Pinpoint unusual sales fluctuations that deviate significantly from a product's typical performance.
- Supply Chain Planning: Alert the supply chain team to potential sudden demand surges, helping to prevent stock-outs or optimize logistics.
- Root Cause Analysis: Trigger investigation into the reasons behind spikes (e.g., promotional activities, news events, competitor issues).
- Demand Forecasting Refinement: Provide data points for improving future demand models by understanding spike characteristics.

SQL Skills:
- Common Table Expressions (CTE); Aggregation: SUM(), AVG(), GROUP BY; Subquery (for calculating overall average daily sales); JOIN; WHERE (for threshold comparison)
***************************************************************************************************/

WITH ProductSalesByDate AS 	
-- Calculates the total sales amount for each product on each specific order date.
(SELECT 
	p.product_key,
    product_name,
    order_date,
    SUM(sales_amount) AS RevenueByDate -- Total sales revenue for that product on that day
FROM
	gold_fact_sales S
    LEFT JOIN 
    gold_dim_products p
    ON s.product_key=p.product_key
WHERE
	order_date IS NOT NULL
    AND sales_amount IS NOT NULL
GROUP BY
	p.product_key,
    product_name,
    order_date)
	
-- Joins the daily sales with the overall average daily sales for each product,
-- then filter for sales spikes based on the 3x threshold.
SELECT 
	ps.product_name,
    CAST(AvgDailySales AS DECIMAL(10,2)) AS AvgDailySales,
    order_date SpikeDate,
    RevenueByDate AS SpikeRevenue
FROM
    ProductSalesByDate ps 
    JOIN 
    -- Inline Subquery: Calculates the overall average daily sales for each product.
    -- This average is calculated across all days a product had sales.
    (SELECT psd.product_name,
			AVG(RevenueByDate) AS AvgDailySales -- Overall average daily sales for the product
		FROM ProductSalesByDate psd -- References the initial CTE
        GROUP BY
			product_name) AS AvgSalesByProd 
	ON ps.product_name=AvgSalesByProd.product_name -- Join daily sales to overall average sales by product name
-- Filter condition: Daily sales amount is MORE THAN 3 times the average daily sales.
WHERE RevenueByDate >( 3 * AvgDailySales ) 
ORDER BY product_name; -- Order by product name for readability


