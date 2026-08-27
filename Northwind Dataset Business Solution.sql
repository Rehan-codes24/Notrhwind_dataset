--  							
use northwind_data;
select * from orders;
select * from order_details;
 -- 									BUSINESS QUESTIONS 
 
-- Q1. List all orders (in descending order_id), showing "Not Shipped Yet" wherever shipped_date is NUL

SELECT order_id, customer_id, 
       COALESCE(shipped_date, 'Not Shipped Yet') AS shipped_status
FROM orders 
order by order_id desc ;

-- Q2. For every order, show its freight, replacing NULL freight values with 0.

SELECT order_id, COALESCE(freight, 0) AS freight_safe
FROM orders;

-- Q3. For every order, I need the details of the products sold in that order.

SELECT 
    o.order_id,
    od.product_id,
    SUM(od.quantity) AS total_quantity
FROM
    orders o
        INNER JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY o.order_id , od.product_id;

-- Q4. Management wants to know whether every order has at least one order-detail record?

SELECT 
    o.order_id, COUNT(DISTINCT od.product_id) AS product_count
FROM
    orders o
        LEFT JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY o.order_id;
-- Q5. Find the top 3 customers with the highest total spend (combined value of all their orders, adjusted for discount).

WITH order_totals AS (
    SELECT order_id, 
           SUM(unit_price * quantity * (1 - discount)) AS order_value
    FROM order_details
    GROUP BY order_id
),
customer_summary AS (
    SELECT o.customer_id,
           COUNT(DISTINCT o.order_id) AS total_orders,
           SUM(ot.order_value) AS total_spend
    FROM orders o
    JOIN order_totals ot ON o.order_id = ot.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, total_orders, total_spend
FROM customer_summary
ORDER BY total_spend DESC
LIMIT 3;

-- Q6. Find each customer's most recent order, along with its order value.

WITH order_totals AS (
    SELECT order_id, 
           SUM(unit_price * quantity * (1 - discount)) AS order_value
    FROM order_details
    GROUP BY order_id
),
ranked_orders AS (
    SELECT o.customer_id, o.order_id, o.order_date, ot.order_value,
           ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS rn
    FROM orders o
    JOIN order_totals ot ON o.order_id = ot.order_id
)
SELECT customer_id, order_id, order_date, order_value
FROM ranked_orders
WHERE rn = 1
ORDER BY order_date DESC;


-- Q7. Find the top 3 customers by total spend (same task, repeated in the second file).

WITH order_totals AS (
    SELECT order_id, 
           SUM(unit_price * quantity * (1 - discount)) AS order_value
    FROM order_details
    GROUP BY order_id
),
customer_summary AS (
    SELECT o.customer_id,
           COUNT(DISTINCT o.order_id) AS total_orders,
           SUM(ot.order_value) AS total_spend
    FROM orders o
    JOIN order_totals ot ON o.order_id = ot.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, total_orders, total_spend
FROM customer_summary
ORDER BY total_spend DESC
LIMIT 3;

-- Q8. Find each customer's latest order again, using the ROW_NUMBER window function.

WITH order_totals AS (
    SELECT order_id, 
           SUM(unit_price * quantity * (1 - discount)) AS order_value
    FROM order_details
    GROUP BY order_id
),
ranked_orders AS (
    SELECT o.customer_id, o.order_id, o.order_date, ot.order_value,
           ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS rn
    FROM orders o
    JOIN order_totals ot ON o.order_id = ot.order_id
)
SELECT customer_id, order_id, order_date, order_value
FROM ranked_orders
WHERE rn = 1
ORDER BY order_date DESC;

-- Q9. Find the top 10 orders with the longest shipping delay (how many days shipped_date exceeded required_date).

SELECT order_id, customer_id, order_date, required_date, shipped_date,
       DATEDIFF(shipped_date, required_date) AS delay_days
FROM orders
WHERE shipped_date IS NOT NULL
ORDER BY delay_days DESC
LIMIT 10;

-- Q10. Count each customer's on-time vs late orders, and show the top 10 customers by number of late orders

SELECT customer_id,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN DATEDIFF(shipped_date, required_date) <= 0 THEN 1 ELSE 0 END) AS on_time_orders,
       SUM(CASE WHEN DATEDIFF(shipped_date, required_date) > 0 THEN 1 ELSE 0 END) AS late_orders
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY customer_id
ORDER BY late_orders DESC
LIMIT 10;

-- Q11- Find all orders that have NO order details?

SELECT 
    o.order_id, od.product_id
FROM
    orders o
        LEFT JOIN
    order_details od ON o.order_id = od.order_id
WHERE
    od.product_id is NULL
;

-- Q12. Find the top 10 orders based on total quantity of products ordered?

SELECT 
    o.order_id,
    SUM(od.quantity) AS total_qty
FROM
    orders o
        INNER JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY order_id
ORDER BY total_qty DESC
LIMIT 10;

-- Q13. Find the top 10 orders by total revenue?

SELECT 
    o.order_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_revenue
FROM
    orders o
        INNER JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY order_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q14. How much total revenue did each customer generate, and who are the top 10 customers?

SELECT 
    o.customer_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_revenue
FROM
    orders o
        INNER JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q15. Along with the top 10 orders,
-- calculate the total revenue for each order and show only those orders whose revenue is greater than 1,000

SELECT 
    o.order_id,
    o.customer_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_revenue
FROM
    orders o
        INNER JOIN
    order_details od ON o.order_id = od.order_id
GROUP BY order_id
HAVING total_revenue > 1000
ORDER BY total_revenue DESC
LIMIT 10;


-- Q16- Which customers placed at least one order in 1997?

SELECT DISTINCT customer_id
from orders 
where order_date BETWEEN '1997-01-01' and '1997-12-31';

-- Q17. "Which customers ever spent more than $10,000 in a single order
-- (i.e., the total value of one order exceeded $10,000)?"

with order_totals as (
	SELECT order_id, 
           SUM(unit_price * quantity * (1 - discount)) AS order_value
    FROM order_details 
    GROUP BY order_id 
),
Big_orders as (
select customer_id, order_value
from orders o 
join order_totals ot 
on o.order_id = ot.order_id 
where order_value> 10000
)
select customer_id, order_value
from Big_orders 
order by order_value desc
limit 10 ;

-- Q18: "For each employee (employee_id), 
-- which order had the highest freight among all the orders they handled? 
-- Show employee_id, order_id, and that order's freight."

WITH ranked_freight AS (
	SELECT  employee_id, order_id, freight,
		ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY freight DESC) AS rn
	FROM orders
)
SELECT employee_id, order_id, freight
FROM ranked_freIght
WHERE rn = 1
ORDER BY employee_id ; 

-- Q19: "List the customers who have shipped an order via 'Speedy Express' 
-- (ship_via = 1) at least once, BUT have never used 'Federal Shipping' (ship_via = 2)."

SELECT customer_id,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN DATEDIFF(shipped_date, required_date) <= 0 THEN 1 ELSE 0 END) AS on_time_orders,
       SUM(CASE WHEN DATEDIFF(shipped_date, required_date) > 0 THEN 1 ELSE 0 END) AS late_orders
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY customer_id
ORDER BY late_orders DESC
LIMIT 10;

SELECT customer_id,
		COUNT(*) as total_orders,
        SUM(CASE WHEN ship_via = 1 THEN 1 ELSE 0 END) AS USED_1,
        SUM(CASE WHEN ship_via = 2 THEN 1 ELSE 0 END) AS USED_2,
        SUM(CASE WHEN ship_via = 3 THEN 1 ELSE 0 END) AS USED_3
FROM orders
WHERE ship_via IS NOT NULL 
GROUP BY customer_id
HAVING USED_1 > 0 AND USED_2 = 0
ORDER BY USED_1 DESC
LIMIT 10;
