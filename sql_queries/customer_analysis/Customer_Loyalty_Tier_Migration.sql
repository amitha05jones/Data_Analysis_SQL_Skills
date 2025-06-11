/**************************************************************************************************
Customer Loyalty Tier Migration Analysis (Window Function & & Aggregation)
***************************************************************************************************
Business Question: Marketing wants to understand how customers move between loyalty tiers based on their annual spend.
Assign a tier (e.g., 'Bronze' < $2000, 'Silver' $2000-$5000, 'Gold' > $5000) for each year and identify customers who changed their tier from the previous year.

Purpose for a Business Analyst:
- Strategic Segmentation: Classify customers into actionable groups for targeted marketing, sales, and service strategies.
- Value Identification: Quickly identify high-value (VIP) customers for specialized loyalty programs and retention efforts.
- Behavior Analysis: Understand the overall distribution of customer types, aiding in customer lifecycle management and resource allocation.

SQL Skills: Common Table Expressions (CTE), YEAR(), SUM(), GROUP BY, LAG(), Window Functions (PARTITION BY, ORDER BY), CASE WHEN
***************************************************************************************************/

WITH CustomerTier AS(
	-- Calculates annual sales for each customer and assign their loyalty tier for that year.
SELECT 
	c.customer_key,
    CONCAT(first_name,' ',last_name) AS CustomerName,
    YEAR(order_date) AS OrderYear,
    SUM(sales_amount) AS SalesByYear,
    CASE
		WHEN SUM(sales_amount) < 2000 THEN 'Bronze'
        WHEN SUM(sales_amount) BETWEEN 2000 AND 5000 THEN 'Silver'
        WHEN SUM(sales_amount) > 5000 THEN 'Gold'
        ELSE 'Unknown'
	END AS LoyaltyTier -- Current year's loyalty tier
FROM
	gold_fact_sales s
        LEFT JOIN
    gold_dim_customers c ON s.customer_key = c.customer_key
WHERE
	order_date IS NOT NULL
    AND sales_amount IS NOT NULL
GROUP BY
	customer_key,
    CustomerName,
    OrderYear
)
 
,PrevYearTierDetail AS
	-- Gets the previous year's loyalty tier for each customer.
(SELECT 
	CustomerName,
    OrderYear,
    SalesByYear,
    LoyaltyTier ,
     -- retrieves the 'tier_curr' from the previous row (year).
    LAG(LoyaltyTier,1,NULL) OVER (PARTITION BY CustomerName ORDER BY OrderYear) AS PrevYearTier -- Previous year's loyalty tier
FROM
	CustomerTier)

-- Identifies customers who changed their loyalty tier from the previous year.
SELECT 
	CustomerName,
    OrderYear,
    LoyaltyTier,
    PrevYearTier
FROM 
	PrevYearTierDetail
WHERE
	PrevYearTier IS NOT NULL  -- Exclude the first year for each customer(where there's no previous tier)
    AND 
	PrevYearTier != LoyaltyTier -- Filter for rows where the current tier is different from the previous tier
ORDER BY
	CustomerName,
    OrderYear; 