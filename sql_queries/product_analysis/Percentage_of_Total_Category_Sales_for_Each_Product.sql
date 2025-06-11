/*
===================================================================================================
Percentage of Total Category Sales for Each Product (Window Function)
===================================================================================================
Business Question:
Product strategists need to understand each product's contribution within its category. Calculate
the percentage of total sales_amount that each product_name contributes to its respective
category's total sales.

Purpose for a Business Analyst:
- Category Health Assessment: Provides a granular view of how individual products perform
  relative to their category, highlighting dominant products and those with lower contribution.
- Product Portfolio Optimization Helps product strategists identify products that are
  overperforming or underperforming within their segments, guiding decisions on investment,
  discontinuation, or re-prioritization.
- Merchandising & Placement: Informs decisions on product placement, promotions, and
  marketing focus within retail or online categories.


SQL Skills:
- JOIN (to link sales data with product details for category information)
- Aggregate Functions: SUM() (to calculate total sales per product and total sales per category)
- Window Functions: SUM() OVER (PARTITION BY category) (to calculate the total sales for each
  product's category, enabling percentage calculation)
- Arithmetic Operations (for calculating the percentage)
===================================================================================================
*/

WITH ProductTotalSales AS (
    -- Step 1: Calculate the total sales for each individual product.
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        SUM(s.sales_amount) AS ProductTotalSalesAmount -- Total sales for this specific product
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_products p ON s.product_key = p.product_key
    WHERE
        s.sales_amount IS NOT NULL 
        AND p.category IS NOT NULL  
        AND p.product_name IS NOT NULL 
    GROUP BY
        p.product_key,
        p.product_name,
        p.category
),
CategoryTotalSales AS (
    -- Step 2: Calculate the total sales for each product category using the product totals.
    SELECT
        pts.product_name,
        pts.category,
        pts.ProductTotalSalesAmount,
        -- Sum of all  products within the same category.
        SUM(pts.ProductTotalSalesAmount) OVER (PARTITION BY pts.category) AS CategoryTotalSalesAmount
    FROM
        ProductTotalSales pts 
)
-- Percentage of category sales contributed by each product.

SELECT
    cts.category,                  
    cts.product_name,              
    cts.ProductTotalSalesAmount,    
    cts.CategoryTotalSalesAmount,   
    CASE
        WHEN cts.CategoryTotalSalesAmount = 0 THEN '0.00 %' -- To Avoid division by zero
        ELSE CONCAT(
                CAST(
                    (cts.ProductTotalSalesAmount / cts.CategoryTotalSalesAmount) * 100
                AS DECIMAL(10, 2)), 
            ' %'
            )
    END AS PercentageOfCategorySales 
FROM
    CategoryTotalSales cts 
ORDER BY
    cts.category ASC,                 
    PercentageOfCategorySales DESC;
    
