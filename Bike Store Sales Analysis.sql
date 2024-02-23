-- Bike Store Sales Analysis

-- Query 1: Calculates how long it took for each order to ship
SELECT 
    order_id, 
    EXTRACT(DAY FROM (shipped_date - order_date)) AS day_to_ship 
FROM sales.orders;

-- Query 2: Calculates the amount of revenue generated from the Santa Cruz Bikes store
SELECT ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS store_revenue
FROM sales.order_items
WHERE order_id IN (
    SELECT order_id FROM sales.orders WHERE store_id = 1
);

-- Query 3: Calculates the order total for each order id
SELECT 
    order_id,
    ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS order_total 
FROM sales.order_items
GROUP BY order_id;

-- Query 4: Counts the number of orders placed at each store
SELECT 
    store_id, 
    COUNT(order_id) AS orders_count
FROM sales.orders
GROUP BY store_id
ORDER BY store_id;

-- Query 5: Finds all of the customers with a phone number in the database
SELECT * 
FROM sales.customers
WHERE phone IS NOT NULL;

-- Query 6: Finds the number of items in each order
SELECT order_id, SUM(quantity) AS total_items 
FROM sales.order_items
GROUP BY order_id;

-- Query 7: How much each customer spent across all of their orders
SELECT 
    so.customer_id,
    COUNT(so.order_id) AS number_of_orders, 
    ROUND(SUM(subquery.order_total), 2) AS total_spent
FROM sales.orders AS so
JOIN (
    SELECT order_id, ROUND(SUM((list_price - (list_price * discount)) * quantity), 2) AS order_total
    FROM sales.order_items
    GROUP BY order_id
) AS subquery
ON so.order_id = subquery.order_id
GROUP BY so.customer_id
ORDER BY number_of_orders DESC;

-- Query 8: List of available inventory across all stores
SELECT
    ss.store_name,
    pp.product_name,
    pc.category_name,
    pp.model_year,
    ps.quantity,
    pp.list_price
FROM production.stocks AS ps
JOIN production.products AS pp
    ON ps.product_id = pp.product_id
JOIN sales.stores AS ss
    ON ps.store_id = ss.store_id
JOIN production.categories AS pc
    ON pp.category_id = pc.category_id;

-- Query 9: Number of sales each year
SELECT 
    DATE_PART('year', order_date) AS year, 
    COUNT(order_id) AS sales_count
FROM sales.orders
GROUP BY year
ORDER BY year;

-- Query 10: Number of sales per employee
SELECT 
    CONCAT(first_name, ' ', last_name) AS employee, 
    COUNT(sales_staff.staff_id) AS sales, 
    sales_staff.store_id AS store_id
FROM sales.staff AS sales_staff
JOIN sales.orders 
    ON sales_staff.staff_id = sales.orders.staff_id
GROUP BY 
    employee, 
    sales_staff.store_id
ORDER BY sales DESC;