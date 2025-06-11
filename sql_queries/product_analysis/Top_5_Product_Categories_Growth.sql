/**************************************************************************************************
Identifying Top 5 Product Categories by Growth in Latest Quarter (Window Function & CTE)
***************************************************************************************************
Business Question: The executive team is looking for high-growth areas.
Identify the top 5 product categories with the highest sales_amount growth percentage from the second-to-last quarter to the latest full quarter available in the data.

Purpose for a Business Analyst:
- Strategic Investment: Guides executive decisions on where to allocate resources (e.g., R&D, marketing budget) to capitalize on high-growth areas.
- Market Opportunity Identification: Highlights emerging trends and product categories that are gaining significant traction.
- Performance Benchmarking: Provides a metric for comparing the relative success and momentum of different product categories.
- Portfolio Management: Informs decisions about which product categories to prioritize for future development or expansion.

SQL Skills:
- Common Table Expressions (CTE);Date Functions: YEAR(), QUARTER(); Aggregation: SUM(), GROUP BY
- Window Functions: LAG() (for comparing sales across quarters), ROW_NUMBER() (for ranking top N)
- Partitioning and Ordering: PARTITION BY, ORDER BY (crucial for time-series and ranking)
- Filtering: WHERE
- Ranking: LIMIT (for top N results)
- Robustness: CASE WHEN (for handling division by zero in growth percentage calculation)
***************************************************************************************************/

WITH OrderDetails AS
	-- Prepares order details with subcategory and quarter context.
(SELECT 
	p.product_key,
    subcategory,
    order_number,
    YEAR(order_date) AS OrderYear,
    Quarter(order_date) AS OrderQuarter,
    sales_amount
FROM
	gold_fact_sales S
    LEFT JOIN 
    gold_dim_products p
    ON s.product_key=p.product_key
WHERE
	subcategory IS NOT NULL AND subcategory != ''
    AND order_date IS NOT NULL
    AND sales_amount IS NOT NULL)
 
,RankQuarterByLatest AS 
	-- Calculates total sales per subcategory per quarter and rank the quarters.
(SELECT
	subcategory,
	OrderYear,
	OrderQuarter,
	SUM(sales_amount) AS SalesPerQuarter,
    -- ROW_NUMBER() ranks quarters for each subcategory, with 1 being the most recent. 
    -- It handles ties by assigning arbitrary unique ranks, ensuring exactly 5 products are returned.
    ROW_NUMBER() OVER (PARTITION BY subcategory ORDER BY OrderYear DESC, -- Order by year and quarter descending (most recent first)
	OrderQuarter DESC) AS RankByQuarter
FROM
	OrderDetails
GROUP BY
	subcategory,
	OrderYear,
	OrderQuarter
)
  
, PrevQuarterSalesDetails AS
	-- Extract the latest and second-to-last quarter sales for each subcategory.
(SELECT 
	subcategory,
    OrderYear,
	OrderQuarter,
	SalesPerQuarter AS LatestQuarterSales,
    -- gets the sales from the immediately preceding quarter.
    LAG(SalesPerQuarter,1,NULL) OVER (
		PARTITION BY subcategory 
		ORDER BY OrderYear,OrderQuarter -- Order chronologically (ascending) for LAG to work correctly
    ) AS SecondlastQSales
FROM
	RankQuarterByLatest
WHERE 
	RankByQuarter <=2)
    
-- Calculates growth percentage and identifies the top 5 subcategories by growth.
SELECT 
	subcategory,
	LatestQuarterSales,
    SecondlastQSales,
    CASE
        WHEN SecondlastQSales IS NULL THEN NULL -- Cannot calculate growth from NULL 
        ELSE 
        -- Calculates Growth Percentage: (Current - Previous) / Previous * 100
		CAST(((LatestQuarterSales-SecondlastQSales)/SecondlastQSales) * 100 AS DECIMAL(10,2)) END AS QuarterGrowthPercentage
FROM
	PrevQuarterSalesDetails
WHERE
	SecondlastQSales IS NOT NULL -- Only considers subcategories that have sales in the second-to-last quarter
ORDER BY 
	QuarterGrowthPercentage DESC  -- Order by growth percentage in descending order
LIMIT 5 -- Select only the top 5 subcategories with the highest growth 
;
 
