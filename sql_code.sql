-- Create tables
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Populate tables with sample data
INSERT INTO customers (name, email) VALUES
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com'),
    ('Bob Johnson', 'bob@example.com');

INSERT INTO products (name, price) VALUES
    ('Widget A', 9.99),
    ('Gadget B', 19.99),
    ('Gizmo C', 14.99);

INSERT INTO orders (customer_id, order_date) VALUES
    (1, '2023-01-15'),
    (2, '2023-02-01'),
    (3, '2023-02-15'),
    (1, '2023-03-01');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 2, 3),
    (3, 3, 2),
    (4, 1, 1),
    (4, 3, 1);

-- i) Join data from multiple tables
SELECT o.order_id, c.name AS customer_name, p.name AS product_name, oi.quantity, p.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- ii) Perform data aggregation (total sales by product)
SELECT p.name AS product_name, SUM(oi.quantity * p.price) AS total_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sales DESC;

-- iii) Update records based on specific conditions
UPDATE products
SET price = price * 1.1
WHERE price < 15.00;

-- iii) Delete records based on specific conditions
DELETE FROM order_items
WHERE order_id IN (SELECT order_id FROM orders WHERE order_date < '2023-02-01');

DELETE FROM orders
WHERE order_date < '2023-02-01';