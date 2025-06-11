/*
===================================================================================================
Top 5 Best-Selling Products by Quantity in Each Category (Window Function & CTE)
===================================================================================================
Business Question:
Product procurement wants to understand which products are selling best within each product category
to optimize inventory. Identify the top 5 product_name and their total quantity sold for each category.

Purpose for a Business Analyst:
- Inventory Optimization: Directly supports procurement and supply chain teams by identifying
  high-demand products within specific categories, enabling smarter stocking decisions and reducing
  both overstocking and stockouts.
- Merchandising Decisions: Informs merchandising and retail display strategies by
  highlighting popular items that should be prominently featured.
- Supplier Relationship Management: Offers data to negotiate better terms with suppliers
  for consistently top-selling products.

SQL Skills:
- Common Table Expressions (CTE) (for calculating total quantity sold per product per category)
- JOIN (to link sales data with product details for categories)
- Aggregate Functions: SUM() (to calculate total quantity sold), GROUP BY (to aggregate by product and category)
- Window Functions: RANK() (for ranking products within each category)
- Partitioning and Ordering: PARTITION BY (to rank products independently within each category),
  ORDER BY (to sort products by quantity for ranking)
===================================================================================================
*/

with QuantityByProduct AS (

SELECT 
	category, 
    p.product_key, 
    product_name, 
    SUM(quantity) as TotalQuantitySold
    
FROM gold_fact_sales s
    left join
    gold_dim_products p
    ON s.product_key=p.product_key
    
WHERE
	quantity IS NOT NULL
    AND category IS NOT NULL
    AND product_name IS NOT NULL
	
GROUP BY category, 
    p.product_key, 
    product_name)
    
SELECT * FROM (
			SELECT 
				category, 
				product_name, 
				TotalQuantitySold, 
				RANK() OVER (PARTITION BY category ORDER BY TotalQuantitySold DESC) AS CategoryProductRank
			FROM
				QuantityByProduct
			ORDER BY 
				category) t
			WHERE CategoryProductRank <=5 ;