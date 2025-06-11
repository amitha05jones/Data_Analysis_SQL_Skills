SQL for Business Analyst Portfolio
This repository contains a collection of SQL queries designed to solve real-world business problems across various domains like sales, customer behavior, and product performance. Developed for a Business Analyst role, this project demonstrates proficiency in advanced SQL techniques, including Common Table Expressions (CTEs), Window Functions, Subqueries, Self-Joins, and complex aggregations, all aimed at extracting actionable insights from transactional and dimensional data.

Database Schema
This project utilizes a foundational e-commerce database schema comprising three tables:

gold_dim_customers

Contains customer demographic information.

| Column          | Type      | Description                                |
|-----------------|-----------|--------------------------------------------|
| `customer_key`  | INT       | Unique identifier for customer             |
| `customer_id`   | INT       | Public-facing customer ID                  |
| `customer_number`| VARCHAR   | Alphanumeric customer identifier           |
| `first_name`    | VARCHAR   | Customer's first name                      |
| `last_name`     | VARCHAR   | Customer's last name                       |
| `country`       | VARCHAR   | Customer's country of residence            |
| `marital_status`| VARCHAR   | Customer's marital status                  |
| `gender`        | VARCHAR   | Customer's gender                          |
| `birthdate`     | DATE      | Customer's date of birth                   |
| `create_date`   | DATE      | Date customer account was created (acquisition) |

gold_dim_products

Contains product details.

| Column          | Type      | Description                                |
|-----------------|-----------|--------------------------------------------|
| `product_key`   | INT       | Unique identifier for product              |
| `product_id`    | INT       | Public-facing product ID                   |
| `product_number`| VARCHAR   | Alphanumeric product identifier            |
| `product_name`  | VARCHAR   | Name of the product                        |
| `category_id`   | VARCHAR   | Identifier for the product category        |
| `category`      | VARCHAR   | Broad product category (e.g., 'Electronics') |
| `subcategory`   | VARCHAR   | Specific product subcategory (e.g., 'Laptops') |
| `maintenance`   | VARCHAR   | Maintenance information (e.g., 'Low', 'High') |
| `cost`          | INT       | Manufacturing or acquisition cost of the product |
| `product_line`  | VARCHAR   | Product line (e.g., 'Premium', 'Basic')    |
| `start_date`    | DATE      | Date product became available              |

gold_fact_sales

Contains sales transaction data.

| Column         | Type     | Description                                  |
|----------------|----------|----------------------------------------------|
| `order_number` | VARCHAR  | Unique identifier for each order             |
| `product_key`  | INT      | Foreign key linking to `gold_dim_products`   |
| `customer_key` | INT      | Foreign key linking to `gold_dim_customers`  |
| `order_date`   | DATE     | Date the order was placed                    |
| `shipping_date`| DATE     | Date the order was shipped                   |
| `due_date`     | DATE     | Due date for payment                         |
| `sales_amount` | INT      | Sales amount for the line item/product in the order |
| `quantity`     | TINYINT  | Quantity of the product sold in the line item |



Key Business Problems & SQL Solutions
This section highlights a selection of the most impactful SQL queries in this repository, showcasing diverse analytical challenges and the SQL techniques used to solve them, categorized by their primary business focus.

Customer Behavior & Segmentation

These queries focus on understanding customer actions, grouping them into valuable segments, and analyzing their purchasing habits over their lifecycle.

Customer Loyalty Tier Migration Analysis

Business Question: How do customers move between loyalty tiers based on their annual spend?

Insight: Identified customers who upgraded or downgraded loyalty tiers year-over-year, crucial for informing targeted marketing and retention strategies.

SQL Skills: CTE, LAG(), CASE WHEN, Window Functions, DATE_FORMAT(), YEAR(), SUM(), GROUP BY.

Code:  [`sql_queries/customer_analysis/Customer_Loyalty_Tier_Migration.sql`](./sql_queries/customer_analysis/Customer_Loyalty_Tier_Migration.sql)

Average Order Value by Product Category over Customer Lifespan Quartiles

Business Question: Do customer purchasing behaviors in specific product categories vary based on their tenure with the company?

Insight: Segmented customers into lifespan quartiles (NTILE()) and then calculated the average order value for each product category within these segments, providing deep strategic insights for product development and personalized offerings.

SQL Skills: CTE, NTILE(), DATEDIFF(), MAX(), MIN(), SUM(), AVG(), GROUP BY, JOIN.

Code: [`sql_queries/customer_analysis/Avg_Order_Value_Lifespan_Quartiles.sql`](./sql_queries/customer_analysis/Avg_Order_Value_Lifespan_Quartiles.sql)

Average Time Between Orders for Each Customer

Business Question: Customer experience wants to understand typical repurchase intervals.

Insight: Calculated the average number of days between consecutive orders for each customer, informing re-engagement campaigns and customer journey mapping.

SQL Skills: CTE, LAG(), DATEDIFF(), AVG(), Window Functions, GROUP BY, JOIN.

Code: [`sql_queries/customer_analysis/Avg_Time_Between_Orders.sql`](./sql_queries/customer_analysis/Avg_Time_Between_Orders.sql)

Customers with Above-Average Order Count in Their Country

Business Question: Marketing wants to identify highly engaged customers who are outliers within their own geographic region.

Insight: Found customers whose total number of orders exceeded the average order count for customers in their respective countries, allowing for targeted loyalty initiatives.

SQL Skills: Subquery, JOIN, COUNT(DISTINCT), AVG(), GROUP BY, HAVING.

Code: [`sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql`](./sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql)

Product Performance & Strategy

These queries analyze individual product performance, identify relationships between products, and support strategic decisions related to product development, merchandising, and sales force effectiveness.

Product Co-Purchasing (Market Basket Analysis)

Business Question: Which products are most frequently purchased together in the same order?

Insight: Identified the top 10 pairs of products commonly bought in the same transaction, directly informing cross-selling strategies, product bundling, and merchandising layouts.

SQL Skills: CTE, Self-JOIN on a fact table, COUNT(*), GROUP BY, WHERE (for unique pair ordering), ORDER BY, LIMIT.

Code: [`sql_queries/product_analysis/Product_Co_Purchasing_Market_Basket_Analysis.sql`](./sql_queries/product_analysis/Product_Co_Purchasing_Market_Basket_Analysis.sql)

Products with Sales Spikes

Business Question: The supply chain team needs to identify products with unusually high sales on a specific day compared to their average daily sales.

Insight: Found products and order dates where daily sales were more than 3 times their overall average daily sales, crucial for demand forecasting and inventory anomaly detection.

SQL Skills: Subquery, AVG(), SUM(), GROUP BY, JOIN, WHERE (for thresholding).

Code: [`sql_queries/product_analysis/Products_With_Sales_Spikes.sql`](./sql_queries/product_analysis/Products_With_Sales_Spikes.sql)

Employee Performance Ranking (Sales Rep Stand-in)

Business Question: Sales management wants to rank sales representatives by their total sales each month and compare their rank to the total sales of their country.

Insight: Provided detailed monthly performance rankings for sales representatives, both individually and relative to their regional performance, aiding in performance evaluation and goal setting impacting product sales strategy.

SQL Skills: CTE, RANK(), SUM() OVER, PARTITION BY, ORDER BY, JOIN, DATE_FORMAT().

Code: [`sql_queries/sales_performance/Employee_Performance_Ranking.sql`](./sql_queries/sales_performance/Employee_Performance_Ranking.sql)

Time-Series Analysis

These queries focus on analyzing data over time, identifying trends, calculating growth rates, and monitoring cumulative performance.

Products with Sales Decrease from Previous Quarter

Business Question: Product management wants to quickly spot products experiencing a decline in sales.

Insight: Identified products where the total sales amount in a quarter was lower than the immediately preceding quarter, enabling proactive inventory adjustments and targeted marketing interventions.

SQL Skills: CTE, LAG(), QUARTER(), YEAR(), SUM(), GROUP BY, Window Functions, WHERE, CASE WHEN.

Code: [`sql_queries/product_analysis/Products_Sales_Decrease_Prev_Quarter.sql`](./sql_queries/product_analysis/Products_Sales_Decrease_Prev_Quarter.sql)

Identifying Top 5 Product Categories by Growth in Latest Quarter

Business Question: The executive team is looking for high-growth areas within the product portfolio.

Insight: Identified the top 5 product categories with the highest sales growth percentage from the second-to-last quarter to the latest full quarter, guiding strategic investment decisions.

SQL Skills: CTE, LAG(), ROW_NUMBER(), SUM(), GROUP BY, Window Functions, CASE WHEN (for division-by-zero handling), ORDER BY, LIMIT.

Code: [`sql_queries/product_analysis/Top_5_Product_Categories_Growth.sql`](./sql_queries/product_analysis/Top_5_Product_Categories_Growth.sql)

Cumulative Sales by Product Category Over Time

Business Question: Finance needs to monitor the cumulative sales performance of each product category throughout the year.

Insight: Provided a running total of sales for each product category month-over-month, essential for tracking progress against targets and financial forecasting.

SQL Skills: CTE, SUM() OVER, DATE_FORMAT(), GROUP BY, PARTITION BY, ORDER BY.

Code: [`sql_queries/sales_reporting/Cumulative_Sales_By_Category.sql`](./sql_queries/sales_reporting/Cumulative_Sales_By_Category.sql)

Full Query List (For Comprehensive Review)

This section provides a complete listing of all 30+ analytical SQL queries in this repository, organized by their primary business analysis area. Each link directs to the corresponding SQL file for detailed review.

Customer Segmentation & Lifetime Value

Customer Demographic Insights: [Customer Demographic Insights](sql_queries/customer_analysis/Customer_Demographic_Insights.sql)


Customer Segmentation by Engagement (Lifespan & Recency): [Customer Segmentation by Engagement (Lifespan & Recency)](sql_queries/customer_analysis/Customer_Segmentation_by_Engagement.sql)


Customer Acquisition Over Time: [Customer Acquisition Over Time](sql_queries/customer_analysis/Customer_Acquisition_Over_Time.sql)


Identifying Churned Customers (Hypothetical): [Identifying Churned Customers (Hypothetical)](sql_queries/customer_analysis/Identifying_Churned_Customers.sql)


Top 3 Most Frequent Buyers (by Quantity): [Top 3 Most Frequent Buyers (by Quantity)](sql_queries/customer_analysis/Most_Frequent_Buyers.sql)


Customer's First and Last Order Dates (Window Function & CTE): [Customer's First and Last Order Dates (Window Function & CTE)](sql_queries/customer_analysis/Customer_First_and_Last_Order_Dates.sql)


Order Details with Previous Order Date for Same Customer (Window Function): [Order Details with Previous Order Date for Same Customer (Window Function)](sql_queries/customer_analysis/Order_Details_Previous_Order_Date.sql)


Average Customer Order Value by Age Group (Aggregation & CTE):[Average Customer Order Value by Age Group (Aggregation & CTE)](sql_queries/customer_analysis/Avg_Customer_Order_Value_by_Age_Group.sql)


Customer Lifetime Value (LTV) by Acquisition Month (Window Function & CTE): [Customer Lifetime Value (LTV) by Acquisition Month (Window Function & CTE)](sql_queries/customer_analysis/Customer_Lifetime_Value_by_Acquisition_Month.sql)

Customers with Above-Average Order Count in Their Country (Subquery & Aggregation): [Customers with Above-Average Order Count in Their Country (Subquery & Aggregation)](sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql)


Average Time Between Orders for Each Customer (Window Function & Aggregation): [Average Time Between Orders for Each Customer (Window Function & Aggregation)](sql_queries/customer_analysis/Avg_Time_Between_Orders.sql)


Customer Loyalty Tier Migration Analysis (Window Function & Aggregation): [Customer Loyalty Tier Migration Analysis (Window Function & Aggregation)](sql_queries/customer_analysis/Customer_Loyalty_Tier_Migration.sql)


Comprehensive Customer Overview & Segmentation Report: [Comprehensive Customer Overview & Segmentation Report](sql_queries/customer_analysis/Customer_Report.sql)


Customer Loyalty Segmentation by Tenure and Spend: [Customer Loyalty Segmentation by Tenure and Spend](sql_queries/customer_analysis/Customer_Loyalty_Segmentation_by_Tenure_Spend.sql)


Average Order Value by Product Category over Customer Lifespan Quartiles (CTE & Aggregation): [Average Order Value by Product Category over Customer Lifespan Quartiles (CTE & Aggregation)](sql_queries/customer_analysis/Avg_Order_Value_Lifespan_Quartiles.sql)

Product Performance & Strategy

Product Co-Purchasing (Market Basket Analysis): [Product Co-Purchasing (Market Basket Analysis)](sql_queries/product_analysis/Product_Co_Purchasing_Market_Basket_Analysis.sql)

Product Profitability by Category

Inventory Turnover Rate by Product

Top Selling Products by Region

Products with Sales Decrease from Previous Quarter

Products with Sales Spikes

Identifying Top 5 Product Categories by Growth in Latest Quarter: [Identifying Top 5 Product Categories by Growth in Latest Quarter (Window Function & CTE)](sql_queries/product_analysis/Top_5_Product_Categories_Gr.sql)



[Top Performing Products](sql_queries/product_analysis/Top_Performing_Products.sql)

[Product Profitability Analysis](sql_queries/product_analysis/Product_Profitability_Analysis.sql)

[Order Pattern Analysis](sql_queries/product_analysis/Order_Pattern_Analysis.sql)

[Products Sold in More Than Average Number of Orders (Subquery)](sql_queries/product_analysis/Products_Sold_in_More_Than_Average_Orders.sql)

[Top Product Subcategory per Country by Sales (Window Function & CTE)](sql_queries/product_analysis/Top_Product_Subcategory_per_Country_by_Sales.sql)

[Percentage of Total Category Sales for Each Product (Window Function)](sql_queries/product_analysis/Percentage_of_Total_Category_Sales_for_Each_Product.sql)

[Top 5 Best-Selling Products by Quantity in Each Category (Window Function & CTE)](sql_queries/product_analysis/Top_5_Best_Selling_Products_by_Quantity_in_Each_Category.sql)

[Products with Sales Decrease from Previous Quarter (CTE, Window Function & Aggregation)](sql_queries/product_analysis/Products_Sales_Decrease_Pre.sql)


[Products with Sales Spikes (Subquery & Aggregation)](sql_queries/product_analysis/Products_With_Sales_Spikes.sql)

[Product Annual vs. Average & YoY Sales Performance](sql_queries/product_analysis/Product_Performance_Trends_Annual_vs_Average_YoY_Growth.sql)

[Comprehensive Product Performance & Segmentation Report](sql_queries/product_analysis/Product_Report.sql)

[Monthly Sales Trends](sql_queries/sales_reporting/Monthly_Sales_Trends.sql)

[Geographic Sales Performance](sql_queries/sales_reporting/Geographic_Sales_Performance.sql)

[Monthly Running Total of Sales (Window Function)](sql_queries/sales_reporting/Monthly_Running_Total_of_Sales.sql)


[Quarter-over-Quarter Sales Comparison](sql_queries/sales_reporting/Quarter_Over_Quarter_Sales_Comparison.sql)

[Sales Funnel Conversion Rates (Hypothetical Stages)](sql_queries/sales_performance/Sales_Funnel_Conversion_Rates.sql)


[Employee Performance Ranking (Hypothetical Sales Rep Stand-in)](sql_queries/sales_performance/Employee_Performance_Rankin.sql)


[Top Customer per Country by Sales (Window Function & CTE)](sql_queries/customer_analysis/Top_Customer_per_Country_by_Sales.sql)



Sales Trend & Forecasting

Cumulative Sales by Product Category Over Time: [Cumulative Sales by Product Category Over Time (Window Function)](sql_queries/sales_reporting/Cumulative_Sales_By_Category.sql)

Monthly Sales Growth Rate

Average Sales Cycle Length: [Average Sales Cycle Length](sql_queries/sales_performance/Average_Sales_Cycle_Length.sql)

Sales Performance by Weekday/Time of Day: [Sales Performance by Weekday/Time of Day](sql_queries/sales_reporting/Sales_Performance_by_Weekday_Time_of_Day.sql)

Employee Performance Ranking

Quarter-over-Quarter Sales Comparison: [Quarter-over-Quarter Sales Growth for Products (Window Function & Aggregation)](sql_queries/sales_reporting/Quarter_Over_Quarter_Sales_Growth_for_Products.sql)

Sales Funnel Conversion Rates (Hypothetical Stages)

Geographic & Demographic Analysis

Customers with Above-Average Order Count in Their Country: [Customers with Above-Average Order Count in Their Country](sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql)

Top 5 Countries by Total Sales: [Top 5 Countries by Total Sales](sql_queries/sales_reporting/Top_5_Countries_by_Total_Sales.sql)

Customer Demographics by Product Category Preference : [Customer Demographics by Product Category Preference](sql_queries/customer_analysis/Customer_Demographics_by_Product_Category_Preference.sql)


How To Use
To explore these SQL solutions:

Clone the Repository:

git clone https://github.com/amitha05jones/Data_Analysis_SQL_Skills.git

Navigate to the sql_queries Directory: The .sql files are organized within subfolders based on their analytical domain. You will need to create these subfolders (customer_analysis, product_analysis, sales_performance, sales_reporting) in your local repository and place the corresponding .sql files into them.

Execute Queries: These queries are written in standard SQL and should be compatible with most relational database management systems (like MySQL, PostgreSQL, SQL Server) that support the specified functions. You can execute them in your preferred SQL client after setting up the database schema.

Technologies Used
SQL (Standard SQL): Core language for data extraction and analysis.

Git: Version control system for tracking changes.

GitHub: Cloud-based platform for hosting the project repository.

This project is a testament to applying analytical rigor and SQL proficiency to real-world business challenges, making data actionable for strategic decision-making.
