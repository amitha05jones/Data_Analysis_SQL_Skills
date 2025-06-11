/**************************************************************************************************
Product Co-Purchasing (Market Basket Analysis)
***************************************************************************************************
Business Question: Product development and merchandising teams want to identify
which products are most frequently purchased together in the same order.
Find the top 10 pairs of products that appear most often in the same order_number.

Purpose for a Business Analyst:
- Cross-Selling Opportunities: Helps identify products that can be recommended or bundled together.
- Merchandising Strategy: Guides product placement (online and in-store layout) and promotional strategies.
- Inventory Planning: If two products are always bought together, it can inform stocking decisions.

SQL Skills:
- Common Table Expressions (CTE); Self-JOIN; Aggregation: COUNT(*), GROUP BY; Limiting Results: LIMIT (for top N analysis)
***************************************************************************************************/



WITH productdetails as(
-- Extracts all product details associated with each order number.
SELECT 
	order_number,
    p.product_key,
    product_name
FROM
	gold_fact_sales s
    left join
	gold_dim_products p
    on s.product_key=p.product_key
    WHERE
        s.order_number IS NOT NULL  
        AND p.product_key IS NOT NULL
        AND p.product_name IS NOT NULL)

-- Self-join to find all pairs of products within the same order and count their occurrences.
SELECT 
	P.product_name AS Product_1,
	D.product_name AS Product_2,
    COUNT(P.order_number) CoPurchaseFrequency -- Count how many times this specific pair appears together
FROM 
	productdetails P -- First instance of the CTE productdetails
	JOIN
	productdetails D -- Second instance of the CTE
	ON P.order_number=D.order_number 
WHERE P.product_key < D.product_key  -- Ensure Product1 is different from Product2 AND that each pair (A,B) is counted only once, not (B,A)
GROUP BY
	P.product_name,
	D.product_name
ORDER BY
	CoPurchaseFrequency DESC -- Order by frequency in descending order to get the most common pairs
LIMIT 10; -- Limit to the top 10 pairs as requested
