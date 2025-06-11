/*
===================================================================================================
Order Details with Previous Order Date for Same Customer (Window Function)
===================================================================================================
Business Question:
Customer service wants to see a customer's order history and quickly identify the date of their
previous order. For each order, display the order_number, order_date, customer_name, and the
order_date of the customer's immediately preceding order.

Purpose for a Business Analyst:
- Customer Service Enhancement: Directly supports customer service representatives by providing quick
  access to a customer's purchasing timeline, improving efficiency in handling inquiries about
  past orders or recent activity.
- Churn Prevention: By identifying gaps between orders, analysts can spot potential signs of
  disengagement or churn, allowing for proactive outreach or re-engagement strategies.
- Repurchase Pattern Analysis: Helps in understanding typical buying cycles for different
  customers or product types, which can inform marketing automation and inventory planning.
- Customer Journey Mapping: Contributes to a more detailed understanding of the customer
  journey, identifying common sequences or deviations in purchasing behavior.

SQL Skills:
- Window Functions (specifically LAG() for accessing preceding row data)
- Partitioning and Ordering: PARTITION BY, ORDER BY (crucial for ensuring correct chronological
  sequence within each customer's orders)
- JOIN (to link sales with customer details for customer_name)
- CONCAT() (for customer name formatting)
===================================================================================================
*/

WITH CustomerOrderHistory AS (
    -- unique order details for each customer, ensuring valid data
    SELECT DISTINCT
        s.order_number,
        s.order_date,
        s.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key
    WHERE
        s.order_date IS NOT NULL  
        AND s.customer_key IS NOT NULL 
)

SELECT
    order_number,
    Customer_Name,
    order_date,
    -- LAG() to get the previous order_date for the same customer
    LAG(order_date) OVER (
        PARTITION BY customer_key -- Partition by customer to apply LAG within each customer's orders
        ORDER BY order_date ASC    -- Order chronologically to find the *preceding* one
    ) AS Previous_Order_Date
FROM
    CustomerOrderHistory
ORDER BY
    Customer_Name ASC, 
    order_date ASC; 
    