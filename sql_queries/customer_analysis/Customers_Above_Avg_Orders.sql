/**************************************************************************************************
Customers with Above-Average Order Count in Their Country
***************************************************************************************************
Business Question: Marketing wants to identify highly engaged customers who are outliers within their own geographic region.
Find customers whose total number of orders is greater than the average number of orders for customers in their respective country.

Purpose for a Business Analyst:
- High-Value Customer Identification: Pinpoints exceptionally engaged customers who are performing above their regional peers.
- Targeted Marketing: Enables marketing to design exclusive campaigns, loyalty programs, or personalized offers for these top-tier regional customers.
- Regional Performance Benchmarking: Provides insights into regional differences in customer engagement and identifies potential best practices from regions with many high-order customers.
- Anomaly Detection: Highlights customers who might be unexpectedly active, prompting further investigation.

SQL Skills:
- Common Table Expressions (CTE); Joining: JOIN; Aggregation: COUNT(DISTINCT), AVG(), GROUP BY; Subquery (for calculating country-level average); 
Filtering: WHERE (for comparison against subquery result)
***************************************************************************************************/


WITH CustomerOrderSummary AS (
    -- Total number of unique orders for each individual customer.
    SELECT
        c.customer_key,                           
        CONCAT(c.first_name, ' ', c.last_name) AS CustomerFullName, 
        c.country,                       
        COUNT(DISTINCT s.order_number) AS CustomerOrderCount 
    FROM
        gold_fact_sales s                      
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key 
    WHERE
        s.order_number IS NOT NULL             
        AND c.customer_key IS NOT NULL           
        AND c.country IS NOT NULL                
    GROUP BY
        c.customer_key,
        CustomerFullName,
        c.country
)
-- Joining customer order counts with country average order counts (BY subquery).
SELECT
    cos.CustomerFullName,               
    cos.country,                        
    cos.CustomerOrderCount,             
    country_avg.AverageOrdersPerCountry 
FROM
    CustomerOrderSummary cos            
JOIN (
    -- Inline Subquery: Calculates the average order count across all customers for each country.
    SELECT
        country,
        CEIL(AVG(CustomerOrderCount)) AS AverageOrdersPerCountry
    FROM
        CustomerOrderSummary 
    GROUP BY
        country
) AS country_avg ON cos.country = country_avg.country -- Join on 'country'
WHERE
    cos.CustomerOrderCount > country_avg.AverageOrdersPerCountry -- Filter: Customer's order count must be greater than their country's average
ORDER BY
    cos.country ASC,                    
    cos.CustomerOrderCount DESC; 
