/*
===================================================================================================
Customer Acquisition Over Time
===================================================================================================
Business Question:
Management wants to understand customer growth. How many new customers were acquired (based on
their 'create_date') each year and month? Results should be ordered chronologically.

Purpose for a Business Analyst:
- Track Growth Trends: Monitor customer acquisition rates over time to identify periods of growth or decline.
- Assess Campaign Effectiveness: Evaluate the impact of marketing campaigns on new customer acquisition.
- Inform Resource Planning: Aid strategic planning for customer onboarding and service based on customer influx.
- Benchmark Performance: Establish baselines for acquisition targets and industry comparison.

SQL Skills:
- Date Functions: YEAR() , MONTH()
- Aggregate Functions: COUNT(DISTINCT) (for counting unique new customers)
- GROUP BY (to aggregate by year and month)
- ORDER BY (for chronological sorting)
===================================================================================================
*/

SELECT
    YEAR(create_date) AS Acquisition_Year,  
    MONTH(create_date) AS Acquisition_Month, 
    COUNT(DISTINCT customer_id) AS Number_of_New_Customers
FROM
    gold_dim_customers
WHERE
    create_date IS NOT NULL 
GROUP BY
    Acquisition_Year,
    Acquisition_Month
ORDER BY
    Acquisition_Year ASC,   
    Acquisition_Month ASC;  
