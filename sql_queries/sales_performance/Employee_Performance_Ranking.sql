/**************************************************************************************************
Sales Representative Performance Ranking (Hypothetical, using Customer Key as stand-in for sales rep)
***************************************************************************************************
Business Question: Sales management requires a comprehensive view of individual sales representative performance to inform strategy, incentive programs, and targeted training.
Specifically, they need to:
1. Rank sales representatives by their total sales amount on a monthly basis.
2. Compare each sales representative's monthly sales against the aggregated total sales for their respective country in that same month.
For the purpose of this demonstration, customer_key is used as a stand-in for a unique sales representative identifier, and sales_amount represents their sales contribution.

Purpose for a Business Analyst:
- Performance Evaluation: Identify top-performing sales representatives and those who may need additional support or training.
- Incentive Programs: Provide data-driven insights for designing fair and effective sales incentive and bonus structures.
- Resource Allocation: Understand sales contribution by individual and by country to allocate resources (e.g., marketing budget, training) more effectively.
- Goal Setting: Enable the setting of realistic and comparative sales targets for individuals and regional teams.

SQL Skills:
- Common Table Expressions (CTE);Date Functions: DATE_FORMAT(); Aggregation: SUM(), GROUP BY; Window Functions: RANK(), SUM() OVER; Partitioning and Ordering: PARTITION BY, ORDER BY ;JOIN
***************************************************************************************************/
WITH CustomerMonthlySales AS (
	-- This CTE calculates the total sales amount for each sales representative (customer_key)
    SELECT
        DATE_FORMAT(s.order_date, '%Y-%m') AS SalesMonth,
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS SalesRepName,
        c.country,
        SUM(s.sales_amount) AS TotalSalesAmount -- Total sales amount for the rep in that month
    FROM
        gold_fact_sales AS s
    JOIN
        gold_dim_customers AS c ON s.customer_key = c.customer_key
	WHERE 
		order_date IS NOT NULL
    GROUP BY
        DATE_FORMAT(s.order_date, '%Y-%m'),
        c.customer_key,
        c.country,
        SalesRepName 
	
)
SELECT
    SalesMonth,
    SalesRepName,
    TotalSalesAmount,
    RANK() OVER (PARTITION BY SalesMonth ORDER BY TotalSalesAmount DESC) AS MonthlySalesRank, -- Rank of the representative by sales amount within that month
    Country,
    SUM(TotalSalesAmount) OVER (PARTITION BY SalesMonth, Country) AS CountryMonthlySales -- Total sales amount for the representative's country in that month
FROM
    CustomerMonthlySales 
ORDER BY
    SalesMonth,
    MonthlySalesRank;
