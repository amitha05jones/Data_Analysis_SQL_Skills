/**************************************************************************************************
Average Time Between Orders for Each Customer (Window Function & Aggregation)
***************************************************************************************************
Business Question: Customer experience wants to understand typical repurchase intervals.
For each customer, calculate the average number of days between their consecutive orders.

Purpose for a Business Analyst:
- Customer Behavior Analysis: Provides insights into how frequently customers repurchase, identifying fast vs. slow repeat buyers.
- Churn Prediction: Helps in identifying customers whose interval between orders is increasing significantly, potentially indicating churn risk.
- Campaign Timing: Informs marketing and customer service teams on optimal timing for follow-up communications, promotions, or re-engagement campaigns.
- Loyalty Program Effectiveness: Assesses if loyalty programs or specific product types influence repurchase frequency.

SQL Skills:
- Common Table Expressions (CTE),JOIN, Window Functions: LAG() (for identifying previous order date), AVG() (for calculating average within a partition)
,Date Functions: DATEDIFF() (for calculating time differences in days),Grouping: GROUP BY (for initial customer order details),Filtering: WHERE
****************************************************************************************************/

WITH CusOrderDetails AS(
SELECT DISTINCT --  ExtractS unique order details for each customer
    c.customer_key,
    CONCAT(first_name, ' ', last_name) AS CustomerName,
    order_number,
    order_date
FROM
    gold_fact_sales s
        LEFT JOIN
    gold_dim_customers c ON s.customer_key = c.customer_key
WHERE
    s.order_number IS NOT NULL
	AND c.customer_key IS NOT NULL
	AND order_date IS NOT NULL
ORDER BY
	CustomerName)
    
, lagorderdates AS -- Calculate the date of the previous order and the difference in days.
(
SELECT
	*,
    --  retrieves the order_date from the previous row.
    LAG(order_date,1,'Only one order') OVER (PARTITION BY CustomerName ORDER BY order_date) AS PrevOrder,
    -- DATEDIFF calculates the number of days between the current and previous order.
    DATEDIFF(order_date,LAG(order_date) OVER (PARTITION BY CustomerName ORDER BY order_date)) AS DiffBetweenOrders
FROM
	CusOrderDetails
    )
    
SELECT DISTINCT -- DISTINCT because the AVG() OVER (PARTITION BY) would return the same average for every row of a customer
		CustomerName,
        -- Calculates the average number of days between orders for each customer.
        CAST(AVG(DiffBetweenOrders) OVER (PARTITION BY CustomerName) AS SIGNED) AS AvgDaysBetweenOrders
FROM
	lagorderdates
WHERE 
	DiffBetweenOrders IS NOT NULL -- Exclude the first order of each customer 
ORDER BY
    CustomerName; -- Final ordering for clear presentation
    