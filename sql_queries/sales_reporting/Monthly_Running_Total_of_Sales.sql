
/*
===================================================================================================
Monthly Running Total of Sales (Window Function)
===================================================================================================
Business Question:
The finance department needs to see the cumulative sales growth. Calculate the running total of
sales_amount month-over-month.

Purpose for a Business Analyst:
- Financial Performance Tracking: Provides a clear view of cumulative revenue generation,
  essential for finance teams to monitor progress against annual targets and budgets.
- Trend Analysis: Helps identify acceleration or deceleration in sales accumulation throughout
  the year, informing strategic adjustments.
- Forecasting & Planning: Supports more accurate financial forecasting by showing the trajectory
  of sales over time.

SQL Skills:
- Date Functions:  (to extract and format month and year for grouping and ordering)
- Aggregate Functions: SUM() (used both as a regular aggregate and as a window function)
- Window Functions: SUM() OVER (ORDER BY sales_year_month) (to calculate the running/cumulative
  total across ordered rows)
- GROUP BY (to aggregate daily sales into monthly totals before applying the running total)
- ORDER BY (crucial within the window function to define the order of summation)
===================================================================================================
*/

WITH Monthly_Revenue AS (
    -- Calculating total sales amount for each month and year
    SELECT
        YEAR(order_date) AS Sale_Year, 
        MONTH(order_date) AS Sale_Month, 
        SUM(sales_amount) AS Monthly_Total_Revenue
    FROM
        gold_fact_sales
    WHERE
        order_date IS NOT NULL 
    GROUP BY
        Sale_Year,
        Sale_Month
)
SELECT
    Sale_Year,
    Sale_Month,
    Monthly_Total_Revenue,
    -- Calculating running total of monthly revenue
    SUM(Monthly_Total_Revenue) OVER (ORDER BY Sale_Year ASC, Sale_Month ASC) AS Running_Total_Sales
FROM
    Monthly_Revenue
ORDER BY
    Sale_Year ASC, 
    Sale_Month ASC;