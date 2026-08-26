# Online BookStore — SQL Portfolio Project

A PostgreSQL portfolio project that models an online bookstore (books, customers, orders) and answers 53 business questions using SQL — covering filtering, joins, aggregation, CASE-based classification, subqueries, and data cleaning.

## 📊 Project Overview

This project simulates an online bookstore database and demonstrates practical SQL skills:
- Database & schema design with primary keys, foreign keys, and data-integrity `CHECK` constraints
- Data imported from CSV files into 3 related tables (books, customers, orders)
- 53 business questions solved with SQL, grouped by concept

## 🗂️ Schema

| Table | Description |
|---|---|
| `books` | Book catalog — title, author, genre, published year, price, stock |
| `customers` | Customer details — name, email, phone, city, country |
| `orders` | Order transactions linking customers and books |

**Relationships:** `orders.customer_id → customers`, `orders.book_id → books`

## 🧠 Concepts Covered

- Filtering & sorting (`WHERE`, `BETWEEN`, `ORDER BY`, `LIMIT`, `OFFSET`)
- Aggregation (`SUM`, `AVG`, `COUNT`, `GROUP BY`, `HAVING`)
- Joins (`INNER JOIN`, `LEFT JOIN`) across multiple tables
- Subqueries (scalar, `IN`, `NOT IN`)
- Conditional logic (`CASE WHEN`) for classification (customer value tiers, book price tiers)
- Null handling (`COALESCE`, `IS NULL`)
- Date functions (`TO_CHAR` for month extraction)
- Data cleaning (`TRIM`, `LOWER`, `UPPER`, `INITCAP`, duplicate detection)

## 💡 Sample Business Questions Answered

- Who is the most frequently ordered book / top-spending customer?
- Which books have never been ordered, and what stock remains after fulfilling all orders?
- What's the second-highest and second-lowest book price?
- Which customer records have missing/duplicate/invalid email or phone data?
- What revenue does each author/genre generate?

## 🛠️ Tech Stack

- PostgreSQL
- Standard SQL (joins, subqueries, CASE, data cleaning functions)

## 🚀 How to Run

1. **Create the database.** Run just the `CREATE DATABASE OnlineBookStore;` line first.
   - **In psql:** reconnect with `\c OnlineBookStore` before continuing.
   - **In pgAdmin 4:** `\c` will not work here — instead, refresh the **Databases** node in the left Object Explorer, click on the new `OnlineBookStore` database to connect to it, then open a **new Query Tool** window on that database before running the rest of the script.
2. Run the rest of `Portfolio_Project.sql` to create the schema and tables.
3. **Import the data.** The `COPY` commands use a local Windows file path (e.g. `C:\Users\pavan\...`) — this will only work on the original machine. To run this yourself:
   - Get the `Books.csv`, `Customers.csv`, and `Orders.csv` files (included in this repo under `/data`), and
   - Replace the file path in each `COPY` command with the full path to that CSV file on **your own machine** — for example:
     ```sql
     COPY bookstore.books(book_id, title, author, genre, published_year, price, stock)
     FROM '/home/yourname/Downloads/Books.csv'
     DELIMITER ','
     CSV HEADER;
     ```
   - Alternatively, use pgAdmin's **Import/Export Data** tool (right-click the table → Import/Export Data) instead of `COPY`, which lets you browse to the CSV file directly without editing SQL.
4. Run the 53 queries (`Q1` to `Q53`) — each is commented with the business question it answers.

## 📈 Possible Extensions

- Convert repeated CASE-based classification logic into a `VIEW`
- Rewrite nested subqueries as `CTE`s for readability
- Add indexes on foreign key columns for performance
- Parameterize the CSV import path or load data via a script instead of hardcoded `COPY`

## 👤 Author

**Pavan Dev Sharma**
