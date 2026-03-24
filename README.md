# db_pos_COSC_Project
Small Business POS & Inventory Management Database System  
COSC 4415 – Database Systems  
MySQL – Local Environment

---

## Project Description
This project is a database system for a small business Point-of-Sale (POS). The system stores products, inventory, customers, employees, sales, and payments. The database helps track sales, update inventory, and generate reports.

---

## Project Modules
- Product Management
- Inventory Management
- Sales Management
- Customer Management
- Employee Management
- Payment Processing
- Reporting System

---

## Database Definition Language (DDL)
These commands create the database and tables.

```sql
CREATE DATABASE retail_pos;
USE retail_pos;

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Role VARCHAR(50),
    Hire_Date DATE,
    Phone VARCHAR(15),
    Email VARCHAR(100)
);

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Loyalty_Points INT,
    Registration_Date DATE
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Description TEXT,
    Category VARCHAR(50),
    Unit_Price DECIMAL(10,2),
    Barcode VARCHAR(50)
);
## Database Manipulation Language (DML)
These commands insert sample data.

```sql
INSERT INTO Product (Name, Category, Unit_Price, Barcode)
VALUES ('Milk', 'Dairy', 3.99, '000123456');

INSERT INTO Customer (First_Name, Last_Name, Phone, Email, Loyalty_Points, Registration_Date)
VALUES ('John', 'Smith', '432-555-1234', 'john@email.com', 100, '2026-03-01');

INSERT INTO Employee (First_Name, Last_Name, Role, Hire_Date, Phone, Email)
VALUES ('Alice', 'Brown', 'Cashier', '2025-01-10', '432-555-2222', 'alice@email.com');

---

## (DQL Section)
## Database Queries (DQL)
These queries retrieve and analyze data.

```sql
-- View all products
SELECT * FROM Product;

-- View expensive products
SELECT Name, Unit_Price 
FROM Product 
ORDER BY Unit_Price DESC;

-- Customers with loyalty points
SELECT First_Name, Last_Name, Email, Loyalty_Points 
FROM Customer 
WHERE Loyalty_Points > 100 
ORDER BY Loyalty_Points DESC;

-- Payment method usage
SELECT
    Payment_Method,
    COUNT(*) AS Times_Used,
    SUM(Amount_Paid) AS Total_Revenue
FROM Payment
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;

-- Total sales per day
SELECT Sale_Date, SUM(Total_Amount) AS Daily_Total
FROM Sale
GROUP BY Sale_Date;

-- Low inventory items
SELECT Product.Name, Inventory.Quantity_On_Hand
FROM Inventory
JOIN Product ON Inventory.Product_ID = Product.Product_ID
WHERE Inventory.Quantity_On_Hand < Inventory.Reorder_Level;

Tools Used
MySQL Workbench
GitHub
Dia Diagram Tool
SQL

Team Members
Jersain Hermosillo
Hector Flores
Colin Doyle
Corey Eilers
