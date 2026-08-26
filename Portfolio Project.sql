-- Run this line separately first, then connect to the new database before continuing
-- (see README for pgAdmin vs psql instructions)
-- Create Database
CREATE DATABASE OnlineBookStore;


-- Create Schemas
CREATE SCHEMA bookstore;



-- Drop Table If Exists
DROP TABLE IF EXISTS bookstore.orders;
DROP TABLE IF EXISTS bookstore.books;
DROP TABLE IF EXISTS bookstore.customers;



-- Create Books Table 
CREATE TABLE bookstore.books
(
book_id INT PRIMARY KEY,
title VARCHAR(100) NOT NULL,
author VARCHAR(50) NOT NULL,
genre VARCHAR(50) NOT NULL,
published_year INT NOT NULL,
price NUMERIC (10,2) NOT NULL,
stock INT NOT NULL DEFAULT 0 CHECK(stock>=0)
);



-- Create Customers Table 
CREATE TABLE bookstore.customers
(
customer_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL,
phone VARCHAR(15),
city VARCHAR(50) NOT NULL,
country VARCHAR(100) NOT NULL
);



-- Create Orders Table
CREATE TABLE bookstore.orders
(
order_id SERIAL PRIMARY KEY,
customer_id INT NOT NULL,
book_id INT NOT NULL,
order_date DATE NOT NULL,
quantity INT NOT NULL CHECK(quantity>0),
total_amount NUMERIC(10,2) NOT NULL CHECK(total_amount>=0),

CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES bookstore.customers(customer_id),

CONSTRAINT fk_orders_books
FOREIGN KEY (book_id)
REFERENCES bookstore.books(book_id)
);


SELECT * FROM bookstore.books;
SELECT * FROM bookstore.customers;
SELECT * FROM bookstore.orders;


-- Import Data into Books Table 
COPY bookstore.books(book_id, title, author, genre, published_year, price, stock)
FROM 'C:\Users\pavan\Desktop\PostgreSQL\PD-Portfolio Project-1\Books.csv'
DELIMITER ','
CSV HEADER;


--Import Data into Customers Table
COPY bookstore.customers(customer_id, name, email, phone, city, country)
FROM 'C:\Users\pavan\Desktop\PostgreSQL\PD-Portfolio Project-1\Customers.csv'
DELIMITER ','
CSV HEADER;


-- Import Data into Orders Table
COPY bookstore.orders(order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM 'C:\Users\pavan\Desktop\PostgreSQL\PD-Portfolio Project-1\Orders.csv'
DELIMITER ','
CSV HEADER;



-- 1) Retrieve all books in the 'Fiction' genre:
SELECT book_id, title, author, genre
FROM bookstore.books
WHERE genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT book_id, title, author, published_year
FROM bookstore.books
WHERE published_year>1950;


-- 3) List all customers from the Canada:
SELECT customer_id, name, country
FROM bookstore.customers
WHERE country='Canada';


-- 4) Show orders placed in November 2023:
SELECT order_id, order_date
FROM bookstore.orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books avialable:
SELECT SUM(stock) AS total_stock_of_books
FROM bookstore.books;


-- 6) Find the details of the most expensive book:
SELECT book_id, title, author, price
FROM bookstore.books
ORDER BY price DESC
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT order_id, quantity
FROM bookstore.orders
WHERE quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT order_id, total_amount
FROM bookstore.orders
WHERE total_amount>20;


-- 9) Retrieve all genres available in the book table:
SELECT DISTINCT genre
FROM bookstore.books;


-- 10) Find the book with the lowest stock:
SELECT book_id, title, author, stock
FROM bookstore.books
ORDER BY stock ASC
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue
FROM bookstore.orders;


-- 12) Retrieve the total number of books sold for each genre:
SELECT b.genre,
       SUM(o.quantity) AS total_books_sold
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.genre;


-- 13) Find the average price of books in the 'Fantasy' genre:
SELECT AVG(price) AS average_price
FROM bookstore.books
WHERE genre='Fantasy';



-- 14) List Customers who have placed at least 2 orders:
SELECT c.customer_id, c.name,
       COUNT(o.order_id) AS total_count
FROM bookstore.customers c
INNER JOIN
bookstore.orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id)>=2;


-- 15) Find the most frequently ordered book:
SELECT b.book_id, b.title,
       COUNT(o.order_id) AS total_count
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.book_id, b.title
ORDER BY COUNT(o.order_id) DESC
LIMIT 1;



-- 16) Show the top 3 most expensive books of 'Fantasy' genre:
SELECT title, genre, price
FROM bookstore.books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;



-- 17) Retrieve the total quantity of books sold by each author:
SELECT b.author,
       SUM(o.quantity) AS total_quantity
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.author;



-- 18) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city
FROM bookstore.customers c
INNER JOIN
bookstore.orders o
ON c.customer_id=o.customer_id
WHERE total_amount>30;



-- 19) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name,
       SUM(o.total_amount) AS total_spent
FROM bookstore.customers c
INNER JOIN
bookstore.orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;



-- 20) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock,
       COALESCE(SUM(o.quantity),0) AS order_quantity,
	   b.stock - COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM bookstore.books b
LEFT JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ASC;



-- 21) Display the customer's name, book title, author name, order date, quantity, and total amount for every order.
SELECT c.name, b.title, b.author, o.order_date,
       o.quantity, o.total_amount
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
INNER JOIN
bookstore.customers c
ON c.customer_id=o.customer_id;



-- 22) Display the titles of books that have never been ordered.
SELECT b.title
FROM bookstore.books b
LEFT JOIN
bookstore.orders o
ON b.book_id=o.book_id
WHERE o.book_id IS NULL;



-- 23) Display each customer's name along with the total quantity of books they have purchased.
SELECT c.customer_id, c.name,
       SUM(o.quantity) AS total_quantity
FROM bookstore.customers c
INNER JOIN 
bookstore.orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name;



-- 24) Display the total revenue generated by each author.
SELECT b.author,
       SUM(o.total_amount) AS total_revenue
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.author;



-- 25) Display the total number of orders received for each genre.
SELECT b.genre,
       COUNT(o.order_id) AS total_orders
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.genre;


/* 26) Display the customer's name, total order amount, and assign a category using CASE.

Rules:

Premium Customer → Total Amount ≥ 100
Regular Customer → Total Amount 50–99.99
Basic Customer → Total Amount < 50
*/

SELECT c.customer_id, c.name,
       SUM(o.total_amount) AS total_amount,
	   CASE
	       WHEN SUM(o.total_amount) >= 100 THEN 'Premium Customer'
		   WHEN SUM(o.total_amount) BETWEEN 50 AND 99.99 THEN 'Regular Customer'
		   ELSE 'Basic Customer'
	   END AS customer_category
FROM bookstore.customers c
INNER JOIN 
bookstore.orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name;



-- 27) Display the customer name, book title, order date, and the month name in which the order was placed.
SELECT c.name, b.title, o.order_date,
       TO_CHAR(o.order_date, 'Month') AS month_name
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
INNER JOIN
bookstore.customers c
ON c.customer_id=o.customer_id;



-- 28) Display each book title along with the number of different customers who purchased it.
SELECT b.title,
       COUNT(DISTINCT o.customer_id) AS customer_count
FROM bookstore.books b
INNER JOIN
bookstore.orders o
ON b.book_id=o.book_id
GROUP BY b.title;



/* 29) Display the Book Title, Price, Genre and classify the book using CASE.

Rules:

Expensive → Price ≥ 30
Moderate → Price 15–29.99
Affordable → Price <15
*/

SELECT title, price, genre,
       CASE
	       WHEN price >= 30 THEN 'Expensive'
		   WHEN price BETWEEN 15 AND 29.99 THEN 'Moderate'
		   ELSE 'Affordable'
		END AS book_price_category
FROM bookstore.books;



/* 30) Create a report with the following columns:

Order ID
Customer Name
Book Title
Author
Genre
Order Date
Quantity
Total Amount
Order Month
Book Price Category

Book Price Category:

Expensive → Price ≥ 30
Moderate → Price 15–29.99
Affordable → Price <15

Sort the report by Order Date (Latest First).
*/

SELECT o.order_id, c.name, b.title, b.author, b.genre,
       o.order_date, o.quantity, o.total_amount,
	   TO_CHAR(o.order_date, 'Month') AS order_month,
	   CASE
	       WHEN b.price >= 30 THEN 'Expensive'
		   WHEN b.price BETWEEN 15 AND 29.99 THEN 'Moderate'
		   ELSE 'Affordable'
	   END AS book_price_category
FROM bookstore.books b
INNER JOIN 
bookstore.orders o
ON b.book_id=o.book_id
INNER JOIN
bookstore.customers c
ON c.customer_id=o.customer_id
ORDER BY o.order_date DESC;



-- Q31. Find all books whose price is greater than the average price of all books.
SELECT book_id, title, price
FROM bookstore.books
WHERE price > 
(SELECT AVG(price) 
FROM bookstore.books);



-- Q32. Find the book(s) having the maximum price.
SELECT book_id, title, price
FROM bookstore.books
WHERE price = 
(SELECT MAX(price) 
FROM bookstore.books);



-- Q33. Find the book(s) having the minimum stock.
SELECT book_id, title, stock
FROM bookstore.books
WHERE stock = 
(SELECT MIN(stock) 
FROM bookstore.books);



-- Q34. Find books published in the latest published year available in the table.
SELECT book_id, title, published_year
FROM bookstore.books
WHERE published_year = 
(SELECT published_year 
FROM bookstore.books
ORDER BY published_year DESC
LIMIT 1);



-- Q35. Find orders whose total amount is greater than the average order amount.
SELECT order_id, total_amount
FROM bookstore.orders
WHERE total_amount>
(SELECT AVG(total_amount)
FROM bookstore.orders);



-- Q36. Find all customers who have placed at least one order.
SELECT customer_id, name
FROM bookstore.customers
WHERE customer_id IN (SELECT customer_id FROM bookstore.orders);


-- Q37. Find books ordered by customer ID 2.
SELECT book_id, title, genre
FROM bookstore.books
WHERE book_id IN 
(SELECT book_id 
FROM bookstore.orders
WHERE customer_id = 2);



-- Q38. Find all customers who have never placed an order.
SELECT customer_id, name
FROM bookstore.customers
WHERE customer_id NOT IN (SELECT customer_id
FROM bookstore.orders);



-- Q39. Find books that have never been ordered.
SELECT book_id, title
FROM bookstore.books
WHERE book_id NOT IN (SELECT book_id
FROM bookstore.orders);



-- Q40. Find the second highest book price.
SELECT book_id, title, author, price
FROM bookstore.books
WHERE price = (SELECT MAX(price)
FROM bookstore.books
WHERE price < (SELECT MAX(price)
FROM bookstore.books));



-- Q41. Find the second lowest book price.
SELECT MIN(price) AS second_lowest_price
FROM bookstore.books
WHERE price > (SELECT MIN(price)
FROM bookstore.books);



--Q42. Find the second highest distinct book price using LIMIT and OFFSET
SELECT book_id, title, author, price
FROM bookstore.books
WHERE price = (SELECT DISTINCT(price)
FROM bookstore.books
ORDER BY price DESC
LIMIT 1 OFFSET 1);


-- Q43. Find all customers whose email is NULL.
SELECT customer_id, name, email
FROM bookstore.customers
WHERE email IS NULL;


-- Q44. Find all customers whose phone number is missing.
SELECT customer_id, name, phone
FROM bookstore.customers
WHERE phone IS NULL;


-- Q45. Display customer names and their phone numbers. If phone number is NULL, display 'Not Available'.
SELECT name,
       COALESCE(phone, 'Not Available') AS updated_phone_column
FROM bookstore.customers;


-- Q46. Find all books whose price is less than or equal to 0.
SELECT book_id, title, author, price
FROM bookstore.books
WHERE price <= 0;


-- Q47. Find all books whose stock quantity is negative.
SELECT book_id, title, author, stock
FROM bookstore.books
WHERE stock < 0;



-- Q48. Display customer names after removing leading and trailing spaces.
SELECT TRIM(name) AS cleaned_name
FROM bookstore.customers;



-- Q49. Display customer cities in lowercase after removing extra spaces.
SELECT LOWER(TRIM(city)) AS cleaned_city
FROM bookstore.customers;


-- Q50. Find email addresses that appear more than once in the customers table.
SELECT email, COUNT(*) AS duplicate_count
FROM bookstore.customers
GROUP BY email
HAVING COUNT(*) > 1;



-- Q51. Find customers whose email does not contain '@'.
SELECT customer_id, name, email
FROM bookstore.customers
WHERE email NOT LIKE '%@%';


-- Q52. Display book titles after removing extra spaces and converting them to uppercase.
SELECT UPPER(TRIM(title)) AS cleaned_title
FROM bookstore.books;


-- Q53. Display the customer names with the first letter of each word in uppercase and the remaining letters in lowercase.
SELECT INITCAP(name) AS proper_name
FROM bookstore.customers;



/*
Project Completed

Topics Covered:

SELECT

WHERE

ORDER BY

LIMIT

OFFSET

DISTINCT

GROUP BY

HAVING

JOINS

CASE

COALESCE

DATE FUNCTIONS

AGGREGATE FUNCTIONS

SUBQUERY

DATA CLEANING

*/



















































































































