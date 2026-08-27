# Northwind Dataset — Data Cleaning & SQL Business Analysis

A data cleaning + SQL analysis project built on the **Northwind** sample database (orders, order details), covering data cleaning in Python and business-question solving in SQL.

## 📌 About the Project

This project has two parts:
1. **Data Cleaning (Python/Pandas)** — raw Northwind order data is cleaned and prepared for analysis.
2. **SQL Business Analysis** — a set of business questions (customer spend, shipping delays, revenue, freight, indexing) answered using SQL: joins, CTEs, window functions, aggregates, and `COALESCE`/`NULLIF` for handling missing data.

## 🗂️ Dataset

- **Source:** Northwind sample database (orders & order_details tables)
- Common e-commerce-style tables: customers, orders, order_details, employees, shippers

## 🛠️ Tools & Concepts Used

- Python: Pandas (data cleaning, exploration)
- Jupyter Notebook
- SQL: joins, `GROUP BY`/`HAVING`, CTEs, window functions (`ROW_NUMBER()`), `COALESCE`, `NULLIF`, `DATEDIFF`, indexing

## 📁 Repository Structure

```
├── README.md
├── Northwind Dataset Business Question.docx    # Business questions list
├── Northwind Dataset Business Solution.sql     # SQL solutions to the questions
├── northwind_orders.csv                        # Raw orders data
├── cleaning_orders.ipynb                       # Cleaning notebook for orders
├── cleaning_order_details.ipynb                # Cleaning notebook for order_details
├── final_clean_data.ipynb                      # Final combined/cleaned dataset notebook
├── clean_orders.csv                            # Cleaned orders (intermediate)
└── clean_orders_final.csv                      # Final cleaned orders dataset
```

## 📊 Sample Business Questions Covered

- Which orders haven't shipped yet?
- What is each order's freight, with missing values handled safely?
- Which are the top 3 customers by total spend?
- What is each customer's most recent order?
- Which orders had the longest shipping delays?
- How many on-time vs. late orders does each customer have?
- How can query performance be improved with indexing?

*(Full list of questions in `Northwind Dataset Business Question.docx`)*

## 🚀 How to Run

1. **Data cleaning:** Open the notebooks (`cleaning_orders.ipynb`, `cleaning_order_details.ipynb`, `final_clean_data.ipynb`) in Jupyter and run cells in order to reproduce the cleaned CSVs.
2. **SQL analysis:** Load the Northwind database into MySQL, then run `Northwind Dataset Business Solution.sql` in MySQL Workbench (or any SQL client).

## 👤 Author

**Rehan** — BCA (AI/ML) student, transitioning into Data Analytics.
[www.linkedin.com/in/rehan-khan-7b9a86250](#) • [https://github.com/Rehan-codes24](#)
