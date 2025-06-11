/*
===================================================================================================
Top Performing Products (with RANK() and CTE)
===================================================================================================
Business Question:
Product management wants to identify our best-selling products. What are the top 10 products
by total sales_amount across all orders? Also, include their category and subcategory.

Purpose for a Business Analyst:
- Performance Identification: Clearly identifies the highest-revenue generating products, enabling
  product managers to focus on successful items.
- Inventory Optimization: Informs supply chain and inventory management teams about products
  requiring consistent stocking to meet demand.
- Marketing & Promotion Strategy Guides marketing efforts by highlighting products that
  are already performing well or have the potential for further growth through targeted campaigns.


SQL Skills:
- JOIN (to link sales data with product details)
- Aggregate Functions: SUM() (to calculate total sales amount), GROUP BY (to aggregate sales by product)
- Common Table Expressions (CTE) (for structuring intermediate results like total product sales)
- Window Functions: RANK() (for ranking products by sales amount)
- ORDER BY (to sort products for ranking and final output)
- LIMIT (to retrieve only the top N results, in this case, top 10)
===================================================================================================
*/

WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        p.subcategory,
        -- Total sales for each product, category, and subcategory
        SUM(s.sales_amount) AS Total_Revenue,
		-- Rank based on Total_Revenue - RANK() to handle ties
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS Rank_by_Revenue
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_products p ON p.product_key = s.product_key
    GROUP BY
        p.product_id,
        p.product_name,
        p.category,
        p.subcategory
)
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    Total_Revenue,
    Rank_by_Revenue
FROM
    ProductSales
WHERE
    -- Filtering for the top 10 ranks.
    Rank_by_Revenue <= 10
ORDER BY
    Total_Revenue DESC;