-- I created the database with the statement: 
-- CREATE DATABASE "Bicycles";

-- I switched to the "Bicycles" database using the pgAdmin 4 interface

-- Run the code below to create database schemas and tables

-- Schema Setup transaction
BEGIN;

-- Creating the production schema
CREATE SCHEMA production;

-- Creating the sales schema
CREATE SCHEMA sales;

-- Commit transaction
COMMIT;

-- Table Creation (Part 1) transaction
BEGIN;

-- Creating the brands table
CREATE TABLE production.brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(50)
);

-- Creating the categories table
CREATE TABLE production.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Creating the products table
CREATE TABLE production.products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT,
    brand_id INTEGER,
    category_id INTEGER,
    model_year INTEGER,
    list_price DECIMAL(8,2),
    FOREIGN KEY (brand_id) REFERENCES production.brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES production.categories(category_id)
);

-- Commit transaction
COMMIT;

-- Table Creation (Part 2) transaction
BEGIN;

-- Creating the customers table
CREATE TABLE sales.customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(14),
    email VARCHAR,
    street VARCHAR,
    city VARCHAR(50),
    state CHAR(2),
    zip_code CHAR(5) -- Using CHAR instead of INTEGER to preserve zip codes with leading zeros
);

-- Creating the stores table
CREATE TABLE sales.stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(50),
    phone VARCHAR(14),
    email VARCHAR,
    street VARCHAR,
    city VARCHAR(50),
    state CHAR(2),
    zip_code CHAR(5) -- Using CHAR instead of INTEGER to preserve zip codes with leading zeros
);

-- Creating the stocks table
CREATE TABLE production.stocks (
    store_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES sales.stores(store_id),
    FOREIGN KEY (product_id) REFERENCES production.products(product_id)
);


-- Creating the staff table
CREATE TABLE sales.staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR,
    phone VARCHAR(14),
    active INTEGER,
    store_id INTEGER,
    manager_id INTEGER,
    FOREIGN KEY (store_id) REFERENCES sales.stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES sales.staff(staff_id)
); 

-- Commit transaction
COMMIT;

-- Table Creation (Part 3) transaction
BEGIN;

-- Creating the orders table
CREATE TABLE sales.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_status INTEGER,
    order_date TIMESTAMPTZ,
    required_date TIMESTAMPTZ,
    shipped_date TIMESTAMPTZ,
    store_id INTEGER,
    staff_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES sales.customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES sales.stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES sales.staff(staff_id)
);

-- Creating the order_items table
CREATE TABLE sales.order_items (
    order_id INTEGER,
    item_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    list_price DECIMAL(8,2),
    discount DECIMAL(2,2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES sales.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES production.products(product_id)
);


-- Commit transaction
COMMIT;

-- Adding Constraints transaction
BEGIN;

-- Adding check constraints for state and zip_code
ALTER TABLE sales.customers
    ADD CONSTRAINT state_length_and_format_check CHECK (LENGTH(state) = 2 AND state ~ '^[A-Za-z]{2}$');

ALTER TABLE sales.customers
    ADD CONSTRAINT zip_code_length_and_format_check CHECK (LENGTH(zip_code) = 5 AND zip_code ~ '^[0-9]+$');

ALTER TABLE sales.stores
    ADD CONSTRAINT state_length_and_format_check CHECK (LENGTH(state) = 2 AND state ~ '^[A-Za-z]{2}$');

ALTER TABLE sales.stores
    ADD CONSTRAINT zip_code_length_and_format_check CHECK (LENGTH(zip_code) = 5 AND zip_code ~ '^[0-9]+$');

-- Commit transaction
COMMIT;

-- Loading data into database with PSQL command: 
/*

\copy production.brands FROM '/Users/rebekahfowler/Downloads/Bike Store Data/production/brands.csv' DELIMITER ',' CSV HEADER;

\copy production.categories FROM '/Users/rebekahfowler/Downloads/Bike Store Data/production/categories.csv' DELIMITER ',' CSV HEADER;

\copy production.products FROM '/Users/rebekahfowler/Downloads/Bike Store Data/production/products.csv' DELIMITER ',' CSV HEADER;

\copy sales.customers FROM '/Users/rebekahfowler/Downloads/Bike Store Data/sales/customers.csv' DELIMITER ',' CSV HEADER;

\copy sales.stores FROM '/Users/rebekahfowler/Downloads/Bike Store Data/sales/stores.csv' DELIMITER ',' CSV HEADER;

\copy sales.staff FROM '/Users/rebekahfowler/Downloads/Bike Store Data/sales/staff.csv' DELIMITER ',' CSV HEADER NULL AS 'null';

\copy sales.orders FROM '/Users/rebekahfowler/Downloads/Bike Store Data/sales/orders.csv' DELIMITER ',' CSV HEADER  NULL AS 'null';

\copy production.stocks FROM '/Users/rebekahfowler/Downloads/Bike Store Data/production/stocks.csv' DELIMITER ',' CSV HEADER;

*/