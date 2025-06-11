/*
===================================================================================================
Product Profitability Analysis
===================================================================================================
Business Question:
Product managers need to assess product profitability. For each product category, calculate the
average cost, average sales_amount (per unit sold), and the average profit_margin (calculated as
(sales_amount - cost) / sales_amount * 100).

Purpose for a Business Analyst:
- Profitability Assessment: Provides a clear view of which product categories are most profitable,
  guiding strategic decisions on where to invest resources and optimize offerings.
- Pricing Strategy: Informs pricing adjustments and promotional strategies by understanding
  the underlying cost structure and profitability of different categories.
- Error Handling Demonstration: Shows ability to write robust queries that account for
  potential data quality issues (like zero values in denominators).

SQL Skills:
- JOIN (to link sales data with product details for cost and category)
- Aggregate Functions: AVG(), SUM() (for calculating averages and totals)
- GROUP BY (to aggregate metrics by product category)
- Error Handling: NULLIF() (to prevent division by zero for sales_amount or quantity)
- Data Type Conversion: CAST() (to ensure accurate decimal calculations for percentages)
===================================================================================================
*/

SELECT
    category,
    CAST(AVG(cost) AS DECIMAL(10,2)) AS avg_cost,
    -- Handle division by zero for sales_amount / quantity
    CAST(AVG(s.sales_amount / NULLIF(s.quantity, 0)) AS DECIMAL(10,2)) AS avg_sales_amount_per_unit,
    -- Handle division by zero for profit_margin calculation
    CONCAT(CAST(AVG(
        (s.sales_amount - p.cost) / NULLIF(CAST(s.sales_amount AS DECIMAL(10,2)), 0) * 100
    ) AS DECIMAL(10,2)),'%')  AS Profit_margin_percentage 
FROM
    gold_fact_sales s
LEFT JOIN
    gold_dim_products p ON s.product_key = p.product_key
WHERE
    s.sales_amount IS NOT NULL 
    AND s.quantity IS NOT NULL 
GROUP BY
    category
ORDER BY
    category;