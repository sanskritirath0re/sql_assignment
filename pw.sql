create database pw;
use pw;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT
);
INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);
 

CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50)
);
INSERT INTO Classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');


CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    order_id INT
);
INSERT INTO Products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);


CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);


CREATE TABLE Sales_Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);
INSERT INTO Sales_Products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');


CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);
INSERT INTO Order_Details (order_id, product_id, quantity) VALUES 
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT
);
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');


-- question 7
SELECT 
    orders.order_id,
    customers.customer_name,
    products.product_name
FROM 
    products
LEFT JOIN 
    order_details ON products.product_id = order_details.product_id
LEFT JOIN 
    orders ON order_details.order_id = orders.order_id
LEFT JOIN 
    customers ON orders.customer_id = customers.customer_id;


-- question 8
SELECT 
    products.product_name,
    SUM(sales.amount) AS total_sales_amount
FROM 
    products
INNER JOIN 
    sales ON products.product_id = sales.product_id
GROUP BY 
    products.product_name;


-- question 9
SELECT 
    orders.order_id,
    customers.customer_name,
    SUM(order_details.quantity) AS total_quantity
FROM 
    orders
INNER JOIN 
    customers ON orders.customer_id = customers.customer_id
INNER JOIN 
    order_details ON orders.order_id = order_details.order_id
GROUP BY 
    orders.order_id, customers.customer_name;


-- question 1
CREATE TABLE employees (
    emp_id INTEGER NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INTEGER CHECK (age >= 18),
    email TEXT ,
    salary DECIMAL DEFAULT 30000
);


-- question 6
CREATE TABLE product (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2));
ALTER TABLE product
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);
ALTER TABLE product
ALTER COLUMN price SET DEFAULT 50.00;




