/*
===================================================================================================
Monthly Sales Trends
===================================================================================================
Business Question:
The sales director needs to visualize sales performance over time. Provide the total sales_amount
and total quantity sold for each month and year. Order the results chronologically.

Purpose for a Business Analyst:
- Performance Monitoring: Essential for regularly tracking and reporting sales performance
  over time, identifying growth, stagnation, or decline.
- Trend Identification: Helps to uncover seasonal patterns, long-term trends, or anomalies
  in sales behavior, crucial for strategic forecasting and planning.
- Budgeting & Forecasting Input: Provides foundational data for building accurate sales
  forecasts and informing annual or quarterly budgeting processes.


SQL Skills:
- Date Functions: YEAR(),MONTH()(to extract month and year from order_date)
- Aggregate Functions: SUM() (to calculate total sales amount and total quantity sold)
- GROUP BY (to aggregate sales data by month and year)
- ORDER BY (to ensure the results are presented chronologically)
===================================================================================================
*/

SELECT
    YEAR(order_date) AS Sales_Year,  
    MONTH(order_date) AS Sales_Month,  
    -- Total sales_amount and total quantity sold for each month and year.
    SUM(sales_amount) AS Total_Revenue,
    SUM(quantity) AS Total_Quantity_Sold
FROM
    gold_fact_sales
WHERE
    order_date IS NOT NULL 
GROUP BY
    Sales_Year, 
    Sales_Month  
ORDER BY
    -- Results chronologically.
    Sales_Year ASC,  
    Sales_Month ASC; 