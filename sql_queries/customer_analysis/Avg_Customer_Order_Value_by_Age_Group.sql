/*
===================================================================================================
Average Customer Order Value by Age Group (Aggregation & CTE)
===================================================================================================
Business Question:
Marketing wants to tailor campaigns to different age groups. Determine the average sales_amount
per order (Average Order Value) for customers grouped by their age_group (e.g., 'Under 20',
'20-29', '30-39', '40-49', '50 and above').

Purpose for a Business Analyst:
- Tailored Marketing Strategies: Enables marketing teams to create age-specific campaigns,
  product recommendations, and messaging based on purchasing power and habits within each group.
- Product Development Insights: Informs product teams about which age demographics are driving
  higher value orders, guiding product development and feature prioritization.


SQL Skills:
- Common Table Expressions (CTE) (for structuring intermediate results like customer age)
- Date Functions: TIMESTAMPDIFF(), '2015-01-01' as current date (for calculating age from birthdate)
- JOIN (to link customer demographics with sales data)
- Aggregate Functions: AVG() (to calculate average order value), GROUP BY (to group by age group)
- Conditional Logic: CASE WHEN (to categorize customers into predefined age groups)
===================================================================================================
*/
 
WITH CustomerAgeAndOrderDetails AS (
SELECT 
	c.customer_key,
    timestampdiff(year,birthdate,'2015-01-01') as Age,
    CASE
		WHEN timestampdiff(year,birthdate,'2015-01-01') < 20 then 'Under 20'
        WHEN timestampdiff(year,birthdate,'2015-01-01') BETWEEN 20 AND 29 THEN '20-29'
        WHEN timestampdiff(year,birthdate,'2015-01-01') BETWEEN 30 AND 39 THEN '30-39'
        WHEN timestampdiff(year,birthdate,'2015-01-01') BETWEEN 40 AND 49 THEN '40-49'
        WHEN timestampdiff(year,birthdate,'2015-01-01') >= 50 THEN '50 and Above'
            ELSE 'Unknown'
	END AS Age_category,
    order_number,
    sales_amount
FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key
WHERE 
	c.customer_key IS NOT NULL AND
    first_name IS NOT NULL AND
    birthdate IS NOT NULL
    )
    
SELECT 
    Age_category,
    COUNT(distinct customer_key) AS No_of_cus,
    CAST(SUM(sales_amount)/COUNT(DISTINCT order_number) AS DECIMAL (10,2)) AS Avg_order_value
FROM
	CustomerAgeAndOrderDetails
GROUP BY
	Age_category;