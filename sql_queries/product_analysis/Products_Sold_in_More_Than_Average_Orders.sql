/*
===================================================================================================
Products Sold in More Than Average Number of Orders (Subquery)
===================================================================================================
Business Question:
Product marketing wants to find products that are broadly distributed across orders. Identify
product_name and category for products that have been sold in more than the average number of
unique orders across all products.

Purpose for a Business Analyst:
- Identify Widely Adopted Products: Helps pinpoint products that have broad reach across
  the customer base, indicating strong foundational products or successful entry-level items.
- Cross-Selling & Bundling Opportunities: Products that appear in a high number of unique
  orders might be excellent candidates for bundling or cross-selling with other items, as
  they already demonstrate widespread appeal and integration into customer purchases.
- Inventory & Logistics Planning: Understanding products with high order count  can inform warehousing 
  and distribution strategies to ensure consistent availability.

SQL Skills:
- Subquery (to calculate the overall average number of unique orders per product)
- Aggregate Functions: AVG() (for average order count), COUNT(DISTINCT) (for counting unique orders per product)
- GROUP BY (to aggregate product-level metrics)
- Filtering: HAVING 
- JOIN (to link sales data with product details for product name and category)
===================================================================================================
*/

WITH ProductOrderCounts AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        -- number of unique orders for each product
        COUNT(DISTINCT s.order_number) AS Unique_Order_Count 
    FROM
        gold_fact_sales s
    LEFT JOIN
        gold_dim_products p ON s.product_key = p.product_key
    WHERE
        s.order_number IS NOT NULL 
        AND p.product_key IS NOT NULL 
    GROUP BY
        p.product_key,
        p.product_name,
        p.category
    HAVING
        COUNT(DISTINCT s.order_number) > 0 
)
SELECT
    product_name,
    category,
    Unique_Order_Count
FROM
    ProductOrderCounts
WHERE
    -- Filtering products where their unique order count is greater than
    -- the overall average unique order count across all products.
    Unique_Order_Count > (
        SELECT
            AVG(Unique_Order_Count)
        FROM
            ProductOrderCounts
    )
ORDER BY
    Unique_Order_Count DESC;
    