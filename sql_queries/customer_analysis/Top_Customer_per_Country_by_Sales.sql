/*
===================================================================================================
Top Customer per Country by Sales (Window Function & CTE)
===================================================================================================
Business Question:
Sales management wants to recognize top customers in each region. Identify the customer with the
highest total sales_amount for each country. Include their customer_name, country, and total sales_amount.

Purpose for a Business Analyst:
- High-Value Customer Identification: Pinpoints the most valuable customers in specific geographic
  regions, enabling targeted VIP programs, personalized outreach, and relationship management.
- Regional Sales Strategy: Provides insights into which customers are driving revenue in different
  markets, helping regional sales teams focus their efforts.
- Performance Recognition: Supports sales management in recognizing and incentivizing top customers
  and potentially the sales representatives responsible for those accounts.
- Market Opportunity Assessment: Helps understand if certain countries have a higher concentration
  of high-spending customers, indicating strong market opportunities.

SQL Skills:
- Common Table Expressions (CTE) (for calculating total sales per customer)
- Window Functions (specifically `RANK()` for assigning ranks within partitions)
- Partitioning and Ordering: `PARTITION BY` (to rank customers independently within each country)
  `ORDER BY` (to sort customers by sales amount for ranking)
- Aggregate Functions: `SUM()` (to calculate total sales per customer), `GROUP BY` (to aggregate sales by customer)
- JOIN (to link sales data with customer demographics for country information)
===================================================================================================
*/

WITH CustomerTotalSales AS (
    SELECT
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
        c.country,
        -- Total sales for each customer
        SUM(s.sales_amount) AS Total_Sales_Amount
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key
    WHERE
        s.sales_amount IS NOT NULL 
        AND c.country IS NOT NULL  
        AND c.country != 'n/a' 
		AND c.country != ''    
        AND c.customer_key IS NOT NULL 
    GROUP BY
        c.customer_key,
        Customer_Name,
        c.country
),
RankedCustomerSales AS (
    -- Rank customers by their total sales within each country
    SELECT
        customer_key,
        Customer_Name,
        country,
        Total_Sales_Amount,
        -- RANK() assigns a rank within each country based on Total_Sales_Amount and handle ties
        RANK() OVER (PARTITION BY country ORDER BY Total_Sales_Amount DESC) AS sales_rank
    FROM
        CustomerTotalSales
)
-- Select only the top-ranked customer (rank 1) for each country
SELECT
    country,
    Customer_Name,
    Total_Sales_Amount
FROM
    RankedCustomerSales
WHERE
    sales_rank = 1
ORDER BY
    country ASC,
    Total_Sales_Amount DESC; 
