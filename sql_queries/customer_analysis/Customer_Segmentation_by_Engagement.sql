/*
===================================================================================================
Customer Segmentation by Engagement (Lifespan & Recency)
===================================================================================================
Business Question:
Marketing wants to segment customers based on their engagement. Specifically, they define
"Dormant Loyalists" as customers who have made at least 5 orders, have a lifespan (time
between first and last order) of 12 months or more, but whose recency (months since last
order) is 6 months or more. The query should show their customer_name, total_orders,
total_sales, lifespan, and recency.

Purpose for a Business Analyst:
- Targeted Marketing Campaigns: Enables the marketing team to precisely identify a specific
  segment of customers ("Dormant Loyalists") who were once active but have become less
  engaged. This allows for highly targeted re-engagement campaigns to reactivate them.
- Retention Strategy Development: Provides critical data points for developing strategies
  to prevent further disengagement or churn among loyal customers who are becoming dormant.


SQL Skills:
- JOIN (to combine customer and sales data)
- Aggregate Functions: MIN(), MAX(), COUNT(DISTINCT) (for calculating first/last order, total orders)
- Date Functions: TIMESTAMPDIFF(), CURDATE() (for calculating lifespan and recency)
- GROUP BY (to aggregate metrics at the customer level)
- Conditional Logic: CASE WHEN (to define and categorize customer segments based on criteria)
===================================================================================================
*/

WITH CustomerOrderSummary AS (
    -- Base Query to get customer and order details
    SELECT
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        s.order_number,
        s.order_date,
        s.sales_amount 
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key
    WHERE
        s.order_date IS NOT NULL 
),
CustomerAggregates AS (
    --  Aggregate customer-level metrics
    SELECT
        customer_key,
        customer_name,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales, 
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        TIMESTAMPDIFF(MONTH, MAX(order_date), CURDATE()) AS recency
    FROM
        CustomerOrderSummary
    GROUP BY
        customer_key,
        customer_name
)
--  Segments and filter for "Dormant Loyalists"
SELECT
    customer_name,
    total_orders,
    total_sales,
    lifespan,
    recency,
    CASE
        WHEN total_orders > 4 AND lifespan >= 12 AND recency >= 6 THEN 'Dormant Loyalists'
        ELSE 'Other Segment' 
    END AS customer_segment
FROM
    CustomerAggregates
WHERE
    total_orders > 4
    AND lifespan >= 12
    AND recency >= 6
ORDER BY
    total_sales DESC; 
