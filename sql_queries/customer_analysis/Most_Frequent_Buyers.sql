/*
===================================================================================================
Top 3 Most Frequent Buyers (by Quantity)
===================================================================================================
Business Question:
Who are our most frequent buyers? 
Identify the top 3 customers who have purchased the highest total quantity of products. 

Purpose for a Business Analyst:
- Identify High-Value Customers: Pinpoints customers who contribute significantly through
  high purchase volume, enabling targeted loyalty programs or exclusive offers.
- Personalized Marketing: Provides a direct list for marketing teams to create personalized
  campaigns that reward frequent purchasers and encourage continued engagement.
- Resource Focus: Helps sales and customer service teams prioritize and nurture relationships
  with the most active segment of the customer base.
- Behavioral Insights: Offers insights into the purchasing habits of your most engaged customers,
  which can be used to understand and promote similar behaviors across the customer base.

SQL Skills:
- JOIN (to link sales data to customer information)
- Aggregate Functions: SUM() (to calculate total quantity purchased per customer)
- GROUP BY (to aggregate quantity by customer)
- ORDER BY (to sort customers by total quantity in descending order)
- LIMIT (to retrieve only the top N results)
===================================================================================================
*/

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name, 
    country,
    -- total quantity purchased.
    SUM(s.quantity) AS Total_Quantity_Purchased 
FROM
    gold_fact_sales s
LEFT JOIN
    gold_dim_customers c ON s.customer_key = c.customer_key
WHERE
    s.quantity IS NOT NULL AND s.quantity > 0 
GROUP BY
    c.customer_id,
    Customer_Name ,
    country
ORDER BY
    Total_Quantity_Purchased DESC
-- top 3 customers 
LIMIT 3;
