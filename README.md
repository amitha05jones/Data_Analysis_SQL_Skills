SQL for Business Analyst Portfolio

This repository contains a comprehensive collection of 30+ SQL queries designed to solve real-world business problems across various domains like sales, customer behavior, and product performance. Developed for a Business Analyst role, this project demonstrates proficiency in advanced SQL techniques, including Common Table Expressions (CTEs), Window Functions, Subqueries, Self-Joins, and complex aggregations, all aimed at extracting actionable insights from transactional and dimensional data.

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

### Key Business Problems & SQL Solutions (Highlight Reel)

This section highlights a selection of the most impactful and diverse SQL queries in this repository, showcasing advanced analytical techniques and their direct application to common business challenges. These are designed to provide actionable insights.

### Customer Segmentation & Lifetime Value

These queries focus on understanding customer actions, grouping them into valuable segments, and analyzing their purchasing habits and value over their lifecycle.

1. Comprehensive Customer Overview & Segmentation Report

Business Question: How can we consolidate key customer metrics and segment our customer base for targeted strategies?

Insight: Provides a holistic view of customer demographics, transaction details, and calculated KPIs (total orders, sales, quantity, lifespan, recency, AOV, avg monthly spend). Segments customers into VIP, Regular, New, and by age group for tailored marketing and service.

SQL Skills: CTE, JOIN, CONCAT(), TIMESTAMPDIFF(), CURDATE(), COUNT(DISTINCT), SUM(), MAX(), MIN(), GROUP BY, CASE WHEN, CAST().

Code: [Comprehensive Customer Overview & Segmentation Report](./sql_queries/customer_analysis/Customer_Report.sql)

2. Customer Loyalty Segmentation by Tenure and Spend

Business Question: Marketing leadership wants to understand the structure of our customer base by categorizing customers into loyalty segments based on their tenure (duration since first order) and total lifetime spending.

Insight: Classifies customers into 'VIP', 'REGULAR', or 'NEW' segments, allowing for strategic segmentation, quick identification of high-value customers, and improved customer lifecycle management.

SQL Skills: CTE, JOIN, MIN(), MAX(), SUM(), TIMESTAMPDIFF(), CASE WHEN, GROUP BY, COUNT(DISTINCT).

Code: [Customer Loyalty Segmentation by Tenure and Spend](./sql_queries/customer_analysis/Customer_Loyalty_Segmentation_by_Tenure_Spend.sql)

3. Customer Loyalty Tier Migration Analysis

Business Question: How do customers move between loyalty tiers based on their annual spend?

Insight: Identified customers who upgraded or downgraded loyalty tiers year-over-year, crucial for informing targeted marketing and retention strategies.

SQL Skills: CTE, LAG(), CASE WHEN, Window Functions, DATE_FORMAT(), YEAR(), SUM(), GROUP BY.

Code: [Customer_Loyalty_Tier_Migration](./sql_queries/customer_analysis/Customer_Loyalty_Tier_Migration.sql)

4. Average Order Value by Product Category over Customer Lifespan Quartiles

Business Question: Do customer purchasing behaviors in specific product categories vary based on their tenure with the company?

Insight: Segmented customers into lifespan quartiles (NTILE()) and then calculated the average order value for each product category within these segments, providing deep strategic insights for product development and personalized offerings.

SQL Skills: CTE, NTILE(), DATEDIFF(), MAX(), MIN(), SUM(), AVG(), GROUP BY, JOIN.

Code: [Avg_Order_Value_Lifespan_Quartiles](./sql_queries/customer_analysis/Avg_Order_Value_Lifespan_Quartiles.sql)

5. Average Time Between Orders for Each Customer

Business Question: Customer experience wants to understand typical repurchase intervals.

Insight: Calculated the average number of days between consecutive orders for each customer, informing re-engagement campaigns and customer journey mapping.

SQL Skills: JOIN, LAG(), DATEDIFF(), AVG(), Window Functions (PARTITION BY, ORDER BY), GROUP BY.

Code: [Avg_Time_Between_Orders.sql](./sql_queries/customer_analysis/Avg_Time_Between_Orders.sql)

6. Order History with Previous Order Date for Same Customer

Business Question: Customer service wants to see a customer's order history and quickly identify the date of their previous order.

Insight: Displays each order with the preceding order's date for the same customer, crucial for understanding customer journey linearity and supporting customer service inquiries.

SQL Skills: Window Functions (LAG()), PARTITION BY, ORDER BY, JOIN, CONCAT().

Code: [Order History with Previous Order Date for Same Customer](./sql_queries/customer_analysis/Order_Details_Previous_Order_Date.sql)

### Product Performance & Strategy

These queries analyze individual product performance, identify relationships between products, and support strategic decisions related to product development, merchandising, and sales force effectiveness.

1. Comprehensive Product Performance & Segmentation Report

Business Question: How can we consolidate key product metrics and segment our product portfolio for strategic insights?

Insight: Provides a holistic view of product details, aggregated metrics (total orders, sales, quantity, customers, lifespan), and calculated KPIs (recency, avg order revenue, avg monthly revenue). Segments products into High-Performer, Mid-Range, or Low-Performer for inventory, marketing, and sales focus.

SQL Skills: CTE, JOIN, TIMESTAMPDIFF(), MAX(), COUNT(DISTINCT), SUM(), ROUND(), AVG(), NULLIF(), GROUP BY, CASE WHEN, CAST().

Code: [Comprehensive Product Performance & Segmentation Report](./sql_queries/product_analysis/Product_Report.sql)

2. Product Annual vs. Average & YoY Sales Performance

Business Question: Product management needs a comprehensive view of individual product performance trends.

Insight: Identifies annual sales performance relative to historical average and determines year-over-year sales growth/decline, informing decisions on product investment, marketing focus, or discontinuation.

SQL Skills: CTE, YEAR(), SUM(), GROUP BY, AVG() (Window Function), LAG() (Window Function), Window Functions (PARTITION BY, ORDER BY), CASE WHEN, CAST().

Code:[Product Annual vs. Average & YoY Sales Performance](./sql_queries/product_analysis/ProductPerfTrends_Annual_vs_Average_YoY_Growth.sql)

3. Product Co-Purchasing (Market Basket Analysis)

Business Question: Which products are most frequently purchased together in the same order?

Insight: Identified the top 10 pairs of products commonly bought in the same transaction, directly informing cross-selling strategies, product bundling, and merchandising layouts.

SQL Skills: CTE, Self-JOIN on a fact table, COUNT(*), GROUP BY, WHERE (for unique pair ordering), ORDER BY, LIMIT.

Code: [Product Co-Purchasing (Market Basket Analysis)](./sql_queries/product_analysis/Product_Co_Purchasing_Market_Basket_Analysis.sql)

4. Products with Sales Spikes

Business Question: The supply chain team needs to identify products with unusually high sales on a specific day compared to their average daily sales.

Insight: Found products and order dates where daily sales were more than 3 times their overall average daily sales, crucial for demand forecasting and inventory anomaly detection.

SQL Skills: Subquery, AVG(), SUM(), GROUP BY, JOIN, HAVING.

Code: [Products with Sales Spikes](./sql_queries/product_analysis/Products_With_Sales_Spikes.sql)

5. Products with Sales Decrease from Previous Quarter

Business Question: Product management wants to quickly spot products experiencing a decline.

Insight: Identified products where the total sales amount in a quarter is lower than the total sales amount in the immediately preceding quarter, enabling proactive inventory adjustments and targeted marketing interventions.

SQL Skills: CTE, DATE_FORMAT(), QUARTER(), YEAR(), SUM(), GROUP BY, LAG(), Window Functions (PARTITION BY, ORDER BY), WHERE.

Code: [Products with Sales Decrease from Previous Quarter](./sql_queries/product_analysis/Products_Sales_Decrease_Prev_Quarter.sql)

6. Identifying Top 5 Product Categories by Growth in Latest Quarter

Business Question: The executive team is looking for high-growth areas.

Insight: Identified the top 5 product categories with the highest sales amount growth percentage from the second-to-last quarter to the latest full quarter available in the data, guiding strategic investment decisions.

SQL Skills: CTE, DATE_FORMAT(), QUARTER(), YEAR(), SUM(), GROUP BY, LAG(), Window Functions (PARTITION BY, ORDER BY), ORDER BY, LIMIT.

Code: [Identifying Top 5 Product Categories by Growth in Latest Quarter](./sql_queries/product_analysis/Top_5_Product_Categories_Growth.sql)

### Sales Trend & Forecasting

These queries focus on analyzing sales data over time, identifying trends, calculating growth rates, and monitoring cumulative and individual performance.

1. Employee Performance Ranking (Hypothetical Sales Rep Stand-in)

Business Question: Sales management wants to rank sales representatives by their total sales amount each month and also see their rank compared to the total sales of their country for that month.

Insight: Provided detailed monthly performance rankings for sales representatives, both individually and relative to their regional performance, aiding in performance evaluation and goal setting impacting product sales strategy.

SQL Skills: CTE, DATE_FORMAT(), SUM(), GROUP BY, Window Functions (RANK(), SUM() OVER), PARTITION BY, ORDER BY, JOIN.

Code:  [Employee Performance Ranking (Hypothetical Sales Rep Stand-in)](./sql_queries/sales_performance/Employee_Performance_Ranking.sql)

2. Cumulative Sales by Product Category Over Time

Business Question: Finance needs to monitor the cumulative sales performance of each product category throughout the year.

Insight: For each category, calculates the running total of sales_amount ordered by order_date (monthly granularity), essential for tracking progress against targets and financial forecasting.

SQL Skills: Window Functions (SUM() OVER), DATE_FORMAT(), GROUP BY, PARTITION BY, ORDER BY.

Code: [Cumulative Sales by Product Category Over Time](./sql_queries/sales_reporting/Cumulative_Sales_By_Category.sql)

3. Monthly Sales Trends

Business Question: The sales director needs to visualize sales performance over time.

Insight: Provides total sales_amount and total quantity sold for each month and year, offering a clear chronological overview of sales performance trends.

SQL Skills: DATE_FORMAT(), SUM(), GROUP BY, ORDER BY.

Code: [Monthly Sales Trends](./sql_queries/sales_reporting/Monthly_Sales_Trends.sql)

### Geographic & Demographic Analysis

These queries analyze customer and sales data based on location and demographic attributes, providing insights into market understanding and targeting.

1. Customers with Above-Average Order Count in Their Country

Business Question: Marketing wants to identify highly engaged customers who are outliers within their own geographic region.

Insight: Found customers whose total number of orders is greater than the average number of orders for customers in their respective country, allowing for targeted loyalty initiatives.

SQL Skills: Subquery, JOIN, COUNT(DISTINCT), AVG(), GROUP BY, HAVING.

Code: [Customers with Above-Average Order Count in Their Country](./sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql)

2. Customer Demographic Insights

Business Question: The marketing team wants to understand our customer base distribution.

Insight: Provides the number of customers from each country and the gender breakdown within those countries, fundamental for market understanding and demographic targeting.

SQL Skills: GROUP BY, COUNT(), ORDER BY.

Code: [Customer Demographic Insights](./sql_queries/customer_analysis/Customer_Demographic_Insights.sql)

### Full Query List (For Comprehensive Review)

This section provides a complete listing of all 30+ analytical SQL queries in this repository, organized by their primary business analysis area. Each link directs to the corresponding SQL file for detailed review.

### Customer Analysis
* [Avg_Customer_Order_Value_by_Age_Group.sql](sql_queries/customer_analysis/Avg_Customer_Order_Value_by_Age_Group.sql)
* [Avg_Order_Value_Lifespan_Quartiles.sql](sql_queries/customer_analysis/Avg_Order_Value_Lifespan_Quartiles.sql)
* [Avg_Time_Between_Orders.sql](sql_queries/customer_analysis/Avg_Time_Between_Orders.sql)
* [Customer_Acquisition_Over_Time.sql](sql_queries/customer_analysis/Customer_Acquisition_Over_Time.sql)
* [Customer_Demographic_Insights.sql](sql_queries/customer_analysis/Customer_Demographic_Insights.sql)
* [Customer_Lifetime_Value_by_Acquisition_Month.sql](sql_queries/customer_analysis/Customer_Lifetime_Value_by_Acquisition_Month.sql)
* [Customer_Loyalty_Segmentation_by_Tenure_Spend.sql](sql_queries/customer_analysis/Customer_Loyalty_Segmentation_by_Tenure_Spend.sql)
* [Customer_Loyalty_Tier_Migration.sql](sql_queries/customer_analysis/Customer_Loyalty_Tier_Migration.sql)
* [Customer_Report.sql](sql_queries/customer_analysis/Customer_Report.sql)
* [Customer_Segmentation_by_Engagement.sql](sql_queries/customer_analysis/Customer_Segmentation_by_Engagement.sql)
* [Customers_Above_Avg_Orders.sql](sql_queries/customer_analysis/Customers_Above_Avg_Orders.sql)
* [Identifying_Churned_Customers.sql](sql_queries/customer_analysis/Identifying_Churned_Customers.sql)
* [Most_Frequent_Buyers.sql](sql_queries/customer_analysis/Most_Frequent_Buyers.sql)
* [Order_Details_Previous_Order_Date.sql](sql_queries/customer_analysis/Order_Details_Previous_Order_Date.sql)
* [Top_Customer_per_Country_by_Sales.sql](sql_queries/customer_analysis/Top_Customer_per_Country_by_Sales.sql)

### Product Analysis
* [Best_Selling_Products_by_Quantity_in_Each_Category.sql](sql_queries/product_analysis/Best_Selling_Products_by_Quantity_in_Each_Category.sql)
* [Percentage_of_Total_Category_Sales_for_Each_Product.sql](sql_queries/product_analysis/Percentage_of_Total_Category_Sales_for_Each_Product.sql)
* [ProductPerfTrends_Annual_vs_Average_YoY_Growth.sql](sql_queries/product_analysis/ProductPerfTrends_Annual_vs_Average_YoY_Growth.sql)
* [Product_Co_Purchasing_Market_Basket_Analysis.sql](sql_queries/product_analysis/Product_Co_Purchasing_Market_Basket_Analysis.sql)
* [Product_Profitability_Analysis.sql](sql_queries/product_analysis/Product_Profitability_Analysis.sql)
* [Product_Report.sql](sql_queries/product_analysis/Product_Report.sql)
* [Products_Sales_Decrease_Prev_Quarter.sql](sql_queries/product_analysis/Products_Sales_Decrease_Prev_Quarter.sql)
* [Products_Sold_in_More_Than_Average_Orders.sql](sql_queries/product_analysis/Products_Sold_in_More_Than_Average_Orders.sql)
* [Products_With_Sales_Spikes.sql](sql_queries/product_analysis/Products_With_Sales_Spikes.sql)
* [Top_5_Product_Categories_Growth.sql](sql_queries/product_analysis/Top_5_Product_Categories_Growth.sql)
* [Top_Performing_Products.sql](sql_queries/product_analysis/Top_Performing_Products.sql)
* [Top_Product_Subcategory_per_Country_by_Sales.sql](sql_queries/product_analysis/Top_Product_Subcategory_per_Country_by_Sales.sql)

### Sales Performance
* [Employee_Performance_Ranking.sql](sql_queries/sales_performance/Employee_Performance_Ranking.sql)

### Sales Reporting
* [Cumulative_Sales_By_Category.sql](sql_queries/sales_reporting/Cumulative_Sales_By_Category.sql)
* [Monthly_Running_Total_of_Sales.sql](sql_queries/sales_reporting/Monthly_Running_Total_of_Sales.sql)
* [Monthly_Sales_Trends.sql](sql_queries/sales_reporting/Monthly_Sales_Trends.sql)
* [Quarter_Over_Quarter_Sales_Growth_for_Products.sql](sql_queries/sales_reporting/Quarter_Over_Quarter_Sales_Growth_for_Products.sql)

### How To Use

To explore these SQL solutions and run the queries:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/amitha05jones/Data_Analysis_SQL_Skills.git](https://github.com/amitha05jones/Data_Analysis_SQL_Skills.git)
    ```
 

2.  **Set Up Your Database Environment:**
    * **Install a Relational Database:** You'll need a relational database management system (RDBMS) like MySQL, PostgreSQL, or SQL Server installed locally.
    * **Prepare Data Files:** Ensure you have the `gold_dim_customers.csv`, `gold_dim_products.csv`, and `gold_fact_sales.csv` files placed in a `data/` folder at the root of your cloned repository. (You would need to create these CSVs based on your schema and populate them with sample data).
    * **Execute Setup Script:**
        * Navigate to the `sql_setup/` (or `database_setup/`) directory within this repository.
        * Open the `create_and_load_db.sql` script (or whatever you name it) in your MySQL client (e.g., MySQL Workbench).
        * **Important:** Before running `LOAD DATA LOCAL INFILE`, you might need to enable `LOCAL INFILE` capability in your MySQL client/server. This is typically done by running `SET GLOBAL local_infile=1;` in your MySQL session.
        * Execute the `create_and_load_db.sql` script. This will create the database, define the tables, and load the sample data from the CSV files.

3.  **Execute Queries:**
    * Navigate to the `sql_queries/` directory within this repository. The `.sql` files are organized into subfolders (`customer_analysis`, `product_analysis`, `sales_performance`, `sales_reporting`).
    * Open your preferred SQL client and connect to your `DataWarehouseAnalytics` database.
    * You can now open any `.sql` file and execute the queries against your loaded sample data.

