/* ******************************************************************************************************************************************************
Customer Demographic Insights
********************************************************************************************************************************************************
Business Question: The marketing team wants to understand our customer base distribution. 
How many customers do we have from each country, and what is the gender breakdown within those countries?

Purpose for a Business Analyst:
-Market Understanding:Provides a foundational view of the customer base, essential for understanding current market penetration and potential expansion opportunities.
-Targeted Marketing: Enables the marketing team to tailor campaigns more effectively by understanding the demographic and geographic composition of customers.
					 For example, specific products or messaging can be directed to certain countries or gender groups.
-Resource Allocation:Informs strategic decisions on where to allocate sales, marketing, or customer service resources based on customer density and demographics.
-Performance Benchmarking:Serves as a baseline for comparing demographic trends against sales performance, identifying regions or segments that are over or underperforming.

SQL Skills: `GROUP BY` (for aggregating by country and gender), `COUNT()` (for counting customers), `ORDER BY` (for sorting results for clarity).
  
*******************************************************************************************************************************************************/

SELECT 
    country AS Country,
    -- How many customers do we have from each country
    COUNT(customer_id) AS No_of_customers,
    -- Gender breakdown within those countries
	gender as Gender,
    -- Percentage contribution of each gender within each country
    CONCAT(
        ROUND(
            (COUNT(customer_id) * 100.0 / SUM(COUNT(customer_id)) OVER (PARTITION BY country)), 2
        ), '%'
    ) AS Percentage_in_Country,
    -- Percentage contribution of each country-gender group to total customers
    CONCAT(
        ROUND(
            (COUNT(customer_key) * 100.0 / SUM(COUNT(customer_key)) OVER ()), 2
        ), '%'
    ) AS Percentage_of_Total
FROM
    gold_dim_customers
-- Filtering out NULLs, empty strings, and 'N/A'
WHERE
    country IS NOT NULL AND country != '' AND country != 'N/A' AND  
    gender IS NOT NULL AND gender != '' AND gender != 'N/A' 
GROUP BY 
	country,gender 
ORDER BY 
	country asc;