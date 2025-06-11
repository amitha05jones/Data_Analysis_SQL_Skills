/**************************************************************************************************
Customer Loyalty Segmentation by Tenure and Spend
***************************************************************************************************
Business Question: Marketing leadership wants to understand the structure of our customer base
by categorizing customers into loyalty segments based on their tenure (duration since first order)
and total lifetime spending. Specifically, define segments as:
- 'VIP': Customers with a lifespan of 12 months or more AND total lifetime sales exceeding $5000.
- 'REGULAR': Customers with a lifespan of 12 months or more AND total lifetime sales $5000 or less.
- 'NEW': Customers with a lifespan less than 12 months.

Purpose for a Business Analyst:
- Strategic Segmentation: Classify customers into actionable groups for targeted marketing, sales, and service strategies.
- Value Identification: Quickly identify high-value (VIP) customers for specialized loyalty programs and retention efforts.
- Behavior Analysis: Understand the overall distribution of customer types, aiding in customer lifecycle management and resource allocation.

SQL Skills:
- Common Table Expressions (CTE); JOIN; MIN(), MAX(), SUM() (Aggregate Functions); TIMESTAMPDIFF() (Date Function for Calculating Duration)
- CASE WHEN (Conditional Logic for Segmentation); GROUP BY; COUNT(DISTINCT) (Aggregate Function for Counting Unique Entities)
***************************************************************************************************/

WITH CustomerAggregation AS ( -- Customer Aggregation (short alias for CTE)
    -- Step 1: Calculate key metrics for each customer: first order date, last order date,
    -- total lifetime sales, and lifespan in months.
    SELECT
        c.customer_id AS customerID,        
        c.first_name AS FirstName,       
        MIN(s.order_date) AS FirstOrderDate, 
        MAX(s.order_date) AS LastOrderDate, 
        -- Calculate customer lifespan in full months.
        TIMESTAMPDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS tenure, 
        SUM(s.sales_amount) AS LifetimeSales -- Total lifetime sales 
    FROM
        gold_fact_sales s             
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key 
    WHERE
        s.order_date IS NOT NULL       
        AND s.sales_amount IS NOT NULL   
        AND c.customer_id IS NOT NULL    
    GROUP BY
        c.customer_id,
        c.first_name                   
),
CustomerSegmentation AS ( -- Customer Segmentation (short alias for CTE)
    -- Step 2: Assign a loyalty category to each customer based on their calculated lifespan and total sales.
    SELECT
        customerID,
        FirstName,
        tenure,
        LifetimeSales,
        CASE
            WHEN tenure >= 12 AND LifetimeSales > 5000 THEN 'VIP'
            WHEN tenure >= 12 AND LifetimeSales <= 5000 THEN 'REGULAR'
            WHEN tenure < 12 THEN 'NEW'
            ELSE 'Uncategorized'
        END AS LoyaltyCategory 
    FROM
        CustomerAggregation
)
-- Step 3: Count the number of customers within each defined loyalty category.
SELECT
    LoyaltyCategory AS CustomerCategory,   
    COUNT(DISTINCT customerID) AS NumberOfCustomers -- Count of unique customers in each category
FROM
    CustomerSegmentation                              
GROUP BY
    LoyaltyCategory                         
ORDER BY
    NumberOfCustomers DESC; 