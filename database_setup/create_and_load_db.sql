/*
=============================================================
Create Database and Tables (for MySQL Workbench)
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates tables
    within this database, logically grouped under a 'gold' prefix.
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Drop the 'DataWarehouseAnalytics' database if it exists
-- In MySQL, 'SCHEMA' is synonymous with 'DATABASE'.
DROP DATABASE IF EXISTS DataWarehouseAnalytics;

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;

-- Use the newly created database for subsequent operations
USE DataWarehouseAnalytics;

-- Create Tables
-- In MySQL, you typically create tables directly within the selected database.
-- We'll use 'gold_' as a prefix for table names.

CREATE TABLE gold_dim_customers(
	customer_key INT,
	customer_id INT,
	customer_number VARCHAR(50),
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	country VARCHAR(50),
	marital_status VARCHAR(50),
	gender VARCHAR(50),
	birthdate DATE,
	create_date DATE
);

CREATE TABLE gold_dim_products(
	product_key INT ,
	product_id INT ,
	product_number VARCHAR(50) ,
	product_name VARCHAR(50) ,
	category_id VARCHAR(50) ,
	category VARCHAR(50) ,
	subcategory VARCHAR(50) ,
	maintenance VARCHAR(50) ,
	cost INT,
	product_line VARCHAR(50),
	start_date DATE 
);

CREATE TABLE gold_fact_sales(
	order_number VARCHAR(50),
	product_key INT,
	customer_key INT,
	order_date DATE,
	shipping_date DATE,
	due_date DATE,
	sales_amount INT,
	quantity TINYINT,
	price INT 
);

-- Truncate tables (optional, if you're re-running this on existing tables to clear them)
TRUNCATE TABLE gold_dim_customers;
TRUNCATE TABLE gold_dim_products;
TRUNCATE TABLE gold_fact_sales;

-- Load data from CSV files
-- IMPORTANT: For LOAD DATA LOCAL INFILE to work, you might need to enable it
-- in your MySQL client/server configuration: SET GLOBAL local_infile=1;
-- Adjust the file paths below to be relative to where your script is being run from,
-- or absolute paths on the user's system where they've cloned the 'data' folder.
-- Assuming CSVs are in a 'data' folder at the root of the repo, and this script is in 'database_setup/'.

LOAD DATA LOCAL INFILE '../data/gold.dim_customers.csv'
INTO TABLE gold_dim_customers
CHARACTER SET UTF8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' -- Use '\r\n' for Windows line endings if '\n' doesn't work
IGNORE 1 LINES; -- Skips the header row

LOAD DATA LOCAL INFILE '../data/gold.dim_products.csv'
INTO TABLE gold_dim_products
CHARACTER SET UTF8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' -- Use '\r\n' for Windows line endings if '\n' doesn't work
IGNORE 1 LINES; -- Skips the header row

LOAD DATA LOCAL INFILE '../data/gold.fact_sales.csv'
INTO TABLE gold_fact_sales
CHARACTER SET UTF8
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' -- Use '\r\n' for Windows line endings if '\n' doesn't work
IGNORE 1 LINES; -- Skips the header row