-- ============================================================
--  Retail POS — Schema
--  File    : 01_schema.sql
--  Runs    : Automatically on first Docker container start
--  Note    : MySQL runs files in /docker-entrypoint-initdb.d
--            in alphabetical order — this runs before seed data
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_pos;
USE retail_pos;

-- ============================================================
--  TABLE 1 OF 7: Employee
-- ============================================================
CREATE TABLE Employee (
    Employee_ID  INT          NOT NULL AUTO_INCREMENT,
    First_Name   VARCHAR(50)  NOT NULL,
    Last_Name    VARCHAR(50)  NOT NULL,
    Role         ENUM(
                   'Cashier',
                   'Manager',
                   'Supervisor',
                   'Stock Clerk',
                   'Admin'
                 )            NOT NULL,
    Hire_Date    DATE         NOT NULL,
    Phone        VARCHAR(15)  NOT NULL,
    Email        VARCHAR(100) NOT NULL,

    PRIMARY KEY (Employee_ID),
    UNIQUE (Email)
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 2 OF 7: Customer
--  NULL Customer_ID on Sale = guest checkout
-- ============================================================
CREATE TABLE Customer (
    Customer_ID       INT          NOT NULL AUTO_INCREMENT,
    First_Name        VARCHAR(50)  NOT NULL,
    Last_Name         VARCHAR(50)  NOT NULL,
    Phone             VARCHAR(15),
    Email             VARCHAR(100),
    Loyalty_Points    INT          NOT NULL DEFAULT 0,
    Registration_Date DATE         NOT NULL,

    PRIMARY KEY (Customer_ID),
    UNIQUE (Email)
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 3 OF 7: Product
-- ============================================================
CREATE TABLE Product (
    Product_ID    INT            NOT NULL AUTO_INCREMENT,
    Name          VARCHAR(100)   NOT NULL,
    Description   TEXT,
    Category      VARCHAR(50)    NOT NULL,
    Unit_Price    DECIMAL(10,2)  NOT NULL,
    Barcode       VARCHAR(50)    NOT NULL,
    Supplier_Info VARCHAR(255),

    PRIMARY KEY (Product_ID),
    UNIQUE (Barcode)
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 4 OF 7: Inventory
--  Depends on: Product
-- ============================================================
CREATE TABLE Inventory (
    Inventory_ID       INT          NOT NULL AUTO_INCREMENT,
    Product_ID         INT          NOT NULL,
    Quantity_On_Hand   INT          NOT NULL DEFAULT 0,
    Reorder_Level      INT          NOT NULL DEFAULT 10,
    Last_Restock_Date  DATE,
    Warehouse_Location VARCHAR(100) NOT NULL,

    PRIMARY KEY (Inventory_ID),
    FOREIGN KEY (Product_ID)
        REFERENCES Product (Product_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 5 OF 7: Sale
--  Depends on: Employee, Customer
--  Customer_ID nullable — NULL = guest checkout
-- ============================================================
CREATE TABLE Sale (
    Sale_ID          INT           NOT NULL AUTO_INCREMENT,
    Employee_ID      INT           NOT NULL,
    Customer_ID      INT,
    Sale_Date        DATE          NOT NULL,
    Sale_Time        TIME          NOT NULL,
    Total_Amount     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Tax_Amount       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Discount_Applied DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    PRIMARY KEY (Sale_ID),
    FOREIGN KEY (Employee_ID)
        REFERENCES Employee (Employee_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (Customer_ID)
        REFERENCES Customer (Customer_ID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 6 OF 7: Sale_Item
--  Depends on: Sale, Product
--  Junction table resolving Sale <-> Product many-to-many
-- ============================================================
CREATE TABLE Sale_Item (
    Sale_Item_ID       INT           NOT NULL AUTO_INCREMENT,
    Sale_ID            INT           NOT NULL,
    Product_ID         INT           NOT NULL,
    Quantity           INT           NOT NULL DEFAULT 1,
    Unit_Price_At_Sale DECIMAL(10,2) NOT NULL,
    Line_Discount      DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    PRIMARY KEY (Sale_Item_ID),
    FOREIGN KEY (Sale_ID)
        REFERENCES Sale (Sale_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (Product_ID)
        REFERENCES Product (Product_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 7 OF 7: Payment
--  Depends on: Sale
--  A sale can have multiple payments (split payments)
-- ============================================================
CREATE TABLE Payment (
    Payment_ID            INT           NOT NULL AUTO_INCREMENT,
    Sale_ID               INT           NOT NULL,
    Payment_Method        ENUM(
                            'Cash',
                            'Credit',
                            'Debit',
                            'Gift Card',
                            'Store Credit'
                          )             NOT NULL,
    Amount_Paid           DECIMAL(10,2) NOT NULL,
    Payment_Date          DATE          NOT NULL,
    Transaction_Reference VARCHAR(100),

    PRIMARY KEY (Payment_ID),
    FOREIGN KEY (Sale_ID)
        REFERENCES Sale (Sale_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;


-- ============================================================
--  READ-ONLY USER
--  This is the user the web app connects as.
--  It can only SELECT — it cannot modify any data.
-- ============================================================
CREATE USER IF NOT EXISTS 'app_readonly'@'%' IDENTIFIED BY 'readonly_pass';
GRANT SELECT ON retail_pos.* TO 'app_readonly'@'%';
FLUSH PRIVILEGES;
