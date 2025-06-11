/**************************************************************************************************
Average Order Value by Product Category over Customer Lifespan Quartiles (CTE & Aggregation)
***************************************************************************************************
Business Question: Product strategy wants to see if customers behave differently as they age with the company.
Segment customers into quartiles based on their lifespan and then calculate the average order value
for each product category within these quartiles.

Purpose for a Business Analyst:
- Customer Segmentation: Provides a nuanced way to segment customers based on their journey with the company.
- Behavioral Insight: Reveals if purchasing behavior (specifically Average Order Value per product category) changes as customers mature.
- Tailored Strategies: Informs product development, marketing campaigns, and customer retention efforts by identifying which products resonate with customers at different stages of their lifecycle.

SQL Skills:
- Common Table Expressions (CTE),Window Function - NTILE(), MAX(), MIN() ,Date Functions: DATEDIFF(), Aggregation: SUM(), AVG(), GROUP BY , JOIN,  Data Filtering: WHERE
***************************************************************************************************/

WITH CustomerLifespan AS (
    -- Calculates each customer's lifespan in days, from their creation date to their latest order date.
    SELECT
        c.customer_key,
        MIN(order_date) AS customer_creation_date,
        MAX(s.order_date) AS latest_order_date,
        DATEDIFF(MAX(s.order_date), MIN(order_date)) AS lifespan_in_days
    FROM
        gold_fact_sales s 
    JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key 
    WHERE
        c.create_date IS NOT NULL
        AND s.order_date IS NOT NULL
    GROUP BY
        c.customer_key,
        c.create_date
)
,LifespanQuartile AS (
    -- Assigns a lifespan quartile to each customer based on their calculated lifespan.
    SELECT
        customer_key,
        lifespan_in_days,
        NTILE(4) OVER (ORDER BY lifespan_in_days ASC) AS lifespan_quartile -- Divides customers into 4 equal-sized groups (quartiles) based on lifespan.
    FROM
        CustomerLifespan 
	WHERE 
		lifespan_in_days != 0
),
OrderValues AS (
    -- Calculates the total sales value for each individual order.
    
    SELECT
        order_number,
        customer_key,
        product_key,
        SUM(sales_amount) AS total_order_value
    FROM
        gold_fact_sales 
    WHERE
        sales_amount IS NOT NULL
    GROUP BY -- This aggregates individual sales line items into a single total per order.
        order_number,
        customer_key,
        product_key
)
-- Calculates the Average Order Value for each Product Category within each Customer Lifespan Quartile.
SELECT
    p.category AS ProductCategory,
    clq.lifespan_quartile,
    CAST(AVG(ov.total_order_value) AS DECIMAL(10,2)) AS AverageOrderValue
FROM
    OrderValues ov
JOIN
    LifespanQuartile clq ON ov.customer_key = clq.customer_key
JOIN
    gold_dim_products p ON ov.product_key = p.product_key 
WHERE
    p.category IS NOT NULL
GROUP BY
    p.category,
    clq.lifespan_quartile
ORDER BY
    clq.lifespan_quartile ASC,
    p.category ASC;
