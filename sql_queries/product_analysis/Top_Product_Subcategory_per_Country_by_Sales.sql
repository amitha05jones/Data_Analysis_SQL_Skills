/*
===================================================================================================
Top Product Subcategory per Country by Sales (Window Function & CTE)
===================================================================================================
Business Question:
Regional product teams want to know which product subcategories are most popular in their
respective countries. For each country, identify the top 3 subcategory by total sales_amount.

Purpose for a Business Analyst:
- Regional Product Strategy: Provides granular insights into subcategory performance at a
  country level, enabling regional teams to tailor product offerings and marketing efforts.
- Localized Merchandising: Informs decisions on product assortment, inventory levels, and
  promotional activities specific to the preferences of each country.
- Competitive Landscape Analysis: Allows for understanding local market dynamics and
  how product popularity varies geographically, which can inform competitive strategies.

SQL Skills:
- Common Table Expressions (CTE) (for calculating total sales per subcategory per country)
- JOIN (to link sales, product, and customer demographic data)
- Aggregate Functions: SUM() (to calculate total sales amount), GROUP BY (to aggregate by country and subcategory)
- Window Functions: RANK()(for ranking subcategories independently within each country)
- Partitioning and Ordering: PARTITION BY (to define the scope of ranking by country),
  ORDER BY (to sort subcategories by sales amount for ranking)
===================================================================================================
*/
 
 WITH CountrySubcategorySales AS 
 (SELECT 
		country,
        subcategory,
        -- total sales amount for each product subcategory within each country.
        SUM(sales_amount) AS TotalRevenue
	FROM
        gold_fact_sales s 
	LEFT JOIN
		gold_dim_products 	P
        ON s.product_key=p.product_key
    LEFT JOIN
        gold_dim_customers c ON s.customer_key = c.customer_key 
WHERE
	country IS NOT NULL and country != 'n/a'
GROUP BY
	country,
        subcategory
	)
    
,RankedSubcategories AS(
SELECT 
	country,
	subcategory,
    TotalRevenue,
	RANK() OVER (PARTITION BY country ORDER BY TotalRevenue DESC) AS SubcategoryRank
FROM
	CountrySubcategorySales)
    
SELECT 
	country,
	subcategory,
    TotalRevenue,
    SubcategoryRank
FROM
	RankedSubcategories
WHERE 
    -- top 3 subcategories for each country.
	SubcategoryRank <= 3;
    
