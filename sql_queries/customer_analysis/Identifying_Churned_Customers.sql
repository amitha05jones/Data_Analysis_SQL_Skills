/*
===================================================================================================
Identifying Churned Customers (Hypothetical)
===================================================================================================
Business Question:
A "churned" customer is defined as someone whose 'last_order_date' is more than 12 months ago.
List the customer_name, country, last_order_date, and the number of months since their last
order for all customers meeting this "churned" definition.

Purpose for a Business Analyst:
- Churn Risk Management: Directly identifies customers who have disengaged, allowing for immediate
  intervention or re-engagement campaigns.
- Retention Strategy: Informs the development of proactive retention strategies by
  understanding the characteristics of customers who churn.
- Segment-Specific Analysis: Enables further analysis of churned customers by
  demographic or geographic segments to uncover root causes.
- KPI Monitoring: Supports the tracking of a critical customer health metric (churn rate).

SQL Skills:
- JOIN (to combine customer and sales data)
- Aggregate Functions: MAX() (to find the last order date for each customer)
- Date Functions: TIMESTAMPDIFF() WITH '2015-01-01' AS Currentdate (for calculating months since last order)
- GROUP BY (to aggregate sales data by customer)
- Filtering: HAVING (to apply the churn definition based on aggregated last order date)
===================================================================================================
*/
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    c.country AS Customer_Country, 
    MAX(s.order_date) AS Last_Order_Date,
    -- Months since last order
    TIMESTAMPDIFF(MONTH, MAX(s.order_date), '2015-01-01') AS Months_Since_Last_Order
FROM
    gold_fact_sales s
LEFT JOIN
    gold_dim_customers c ON s.customer_key = c.customer_key
WHERE
    s.order_date IS NOT NULL 
    AND c.customer_key IS NOT NULL
GROUP BY
    c.customer_key, 
    Customer_Name, 
    Customer_Country 
HAVING
    -- A customer is churned if their last order date was more than 12 months ago
    Months_Since_Last_Order > 12
ORDER BY
    Months_Since_Last_Order DESC, 
    Customer_Name ASC;