-- Bike Store Sales Analysis
-- Skills: aggregation, manipulation, grouping, filtering, subqueries, and joining data

-- Calculates how long it took for each order to ship
SELECT 
    order_id, 
    DATE_DIFF(order_date, shipped_date, 'day') AS day_to_ship 
FROM sales_orders;

-- Calculates the amount of revenue generated from the Santa Cruz Bikes store
SELECT ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS store_revenue
FROM sales_order_items
WHERE order_id IN (
    SELECT order_id FROM sales_orders WHERE store_id = 1
    );

-- Calculates the order total for each order id
SELECT 
    order_id,
    ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS order_total 
FROM sales_order_items
GROUP BY order_id;

-- Counts the number of orders placed at each store
SELECT 
    store_id, 
    COUNT(order_id) AS orders_count
FROM sales_orders
GROUP BY store_id
ORDER BY store_id;

-- Finds all of the customers with a phone number in the database
SELECT * 
FROM sales_customers
WHERE phone NOT LIKE 'null';

-- Finds the number of items in each order
SELECT order_id, SUM(quantity) AS total_items 
FROM sales_order_items
GROUP BY order_id;

-- How much each customer spent across all of their orders
SELECT 
    so.customer_id,
    COUNT(order_id) AS number_of_orders, 
    ROUND(SUM(subquery.order_total), 2) AS total_spent
FROM sales_orders AS so
JOIN (
    SELECT order_id, ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS order_total
    FROM sales_order_items
    GROUP BY order_id
) AS subquery
USING(order_id)
GROUP BY so.customer_id
ORDER BY number_of_orders DESC;

-- List of available inventory across all stores
SELECT
    ss.store_name,
    pp.product_name,
    pc.category_name,
    pp.model_year,
    ps.quantity,
    pp.list_price
FROM production_stocks AS ps
JOIN production_products AS pp
    ON ps.product_id = pp.product_id
JOIN sales_stores AS ss
    ON ps.store_id = ss.store_id
JOIN production_categories AS pc
    ON pp.category_id = pc.category_id;

-- Number of sales each year
SELECT 
    DATE_PART("year", order_date) AS year, 
    COUNT(order_id) AS sales_count
FROM sales_orders
GROUP BY year
ORDER BY year;

-- Number of sales per employee
SELECT 
    first_name || " " || last_name AS employee, 
    COUNT(staff_id) AS sales, 
    sales_staffs.store_id AS store_id
FROM sales_staffs
JOIN sales_orders 
    USING(staff_id)
GROUP BY 
    employee, 
    sales_staffs.store_id
ORDER BY sales DESC
