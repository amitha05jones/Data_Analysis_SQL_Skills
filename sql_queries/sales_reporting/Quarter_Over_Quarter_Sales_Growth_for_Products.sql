/*
===================================================================================================
Quarter-over-Quarter Sales Growth for Products (Window Function & Aggregation)
===================================================================================================
Business Question:
Product managers need to identify products showing significant sales growth. Calculate the total
sales_amount for each product by quarter and then compute the quarter-over-quarter (QoQ) sales
growth percentage.

Purpose for a Business Analyst:
- Product Growth Tracking: Provides a direct measure of product performance acceleration or
  deceleration on a quarterly basis, which is a key metric for product health.
- Strategic Product Decisions: Informs product managers about which products are gaining
  traction and which are losing momentum, guiding decisions on investment, marketing, or
  discontinuation.
- Forecasting Accuracy: Improves accuracy of future sales forecasts for individual products
  by incorporating recent growth trends.

SQL Skills:
- Date Functions: QUARTER(), YEAR() (for extracting and formatting quarterly periods)
- Aggregate Functions: SUM() (to calculate total sales per product per quarter), GROUP BY (to aggregate sales)
- Window Functions: LAG() (to retrieve sales from the previous quarter for comparison)
- Partitioning and Ordering: PARTITION BY (to calculate QoQ growth independently for each product),
  ORDER BY (to ensure correct chronological ordering for LAG() function)
- Arithmetic Operations (for calculating growth percentage, including handling division by zero)
===================================================================================================
*/

WITH ProductQuarterlySales AS (
    -- total sales amount for each product by year and quarter
    SELECT
        p.product_key,
        p.product_name,
        YEAR(s.order_date) AS order_year,
        QUARTER(s.order_date) AS order_quarter,
        SUM(s.sales_amount) AS Quarterly_Revenue 
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_products p ON s.product_key = p.product_key
    WHERE
        s.order_date IS NOT NULL  
        AND s.sales_amount IS NOT NULL 
        AND p.product_key IS NOT NULL 
    GROUP BY
        p.product_key,
        p.product_name,
        order_year,
        order_quarter
),
LaggedProductSales AS (
    -- previous quarter's revenue for each product
    SELECT
        product_key,
        product_name,
        order_year,
        order_quarter,
        Quarterly_Revenue,
        LAG(Quarterly_Revenue, 1, 0) OVER (
            PARTITION BY product_key -- Partition by product to compare quarters for the same product
            ORDER BY order_year ASC, order_quarter ASC -- Order chronologically
        ) AS Previous_Quarter_Revenue 
    FROM
        ProductQuarterlySales
)
-- Quarter-over-Quarter Sales Growth Percentage
SELECT
    product_name,
    order_year,
    order_quarter,
    Quarterly_Revenue,
    Previous_Quarter_Revenue,
    -- Percentage_sales_growth, handling division by zero previous revenue
    CASE
        WHEN Previous_Quarter_Revenue = 0 THEN 'No Prev Qtr Data '
        ELSE CONCAT(
            CAST(
                ( (Quarterly_Revenue - Previous_Quarter_Revenue) / Previous_Quarter_Revenue ) * 100
            AS DECIMAL(10, 2)), ' %'
        )
    END AS QoQ_Sales_Growth_Percentage 
FROM
    LaggedProductSales
WHERE
    Previous_Quarter_Revenue IS NOT NULL OR Quarterly_Revenue IS NOT NULL 
ORDER BY
    product_name ASC,
    order_year ASC,
    order_quarter ASC; 