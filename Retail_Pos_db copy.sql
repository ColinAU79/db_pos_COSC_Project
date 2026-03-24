-- ============================================================
--  Retail Point-of-Sale Database
--  Environment : MySQL Workbench | MacOS | Local Host
--  Created     : 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_pos;
USE retail_pos;

-- ============================================================
--  TABLE 1 OF 7: Employee
--  No foreign key dependencies — created first.
-- ============================================================
CREATE TABLE Employee (
    Employee_ID   INT          NOT NULL AUTO_INCREMENT,
    First_Name    VARCHAR(50)  NOT NULL,
    Last_Name     VARCHAR(50)  NOT NULL,
    Role          ENUM(
                    'Cashier',
                    'Manager',
                    'Supervisor',
                    'Stock Clerk',
                    'Admin'
                  )            NOT NULL,
    Hire_Date     DATE         NOT NULL,
    Phone         VARCHAR(15)  NOT NULL,
    Email         VARCHAR(100) NOT NULL,

    PRIMARY KEY (Employee_ID),
    UNIQUE (Email)
) ENGINE = InnoDB;


-- ============================================================
--  TABLE 2 OF 7: Customer
--  No foreign key dependencies — created second.
--  Guest checkouts do NOT create a Customer record;
--  the Sale table handles this via a nullable FK.
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
--  No foreign key dependencies — created third.
--  Barcode is enforced as unique for reliable scanning.
--  Supplier_Info is a plain text field for simplicity.
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
--  Supports multiple location rows per product (1-to-many)
--  to allow multi-warehouse tracking.
--  RESTRICT on delete prevents removing a product that still
--  has inventory records.
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
--  Customer_ID is nullable — NULL means guest checkout.
--  ON DELETE SET NULL preserves sale history if a customer
--  account is deleted.
--  Total_Amount should equal SUM of Sale_Items minus
--  Discount_Applied plus Tax_Amount (enforced at app level).
-- ============================================================
CREATE TABLE Sale (
    Sale_ID          INT           NOT NULL AUTO_INCREMENT,
    Employee_ID      INT           NOT NULL,
    Customer_ID      INT,                          -- NULL = guest
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
--  Junction table that resolves the Sale <-> Product M:M.
--  Unit_Price_At_Sale locks in the price at time of purchase,
--  independent of future Product price changes.
--  CASCADE on Sale_ID: deleting a sale removes its line items.
--  RESTRICT on Product_ID: cannot delete a product that has
--  appeared on a sale (preserves transaction history).
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
--  A sale can have multiple Payment rows (split payments).
--  CASCADE on Sale_ID: deleting a sale removes its payments.
--  Transaction_Reference is nullable — cash payments will
--  not have a reference number.
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
    Transaction_Reference VARCHAR(100),            -- NULL for cash

    PRIMARY KEY (Payment_ID),
    FOREIGN KEY (Sale_ID)
        REFERENCES Sale (Sale_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;


-- ============================================================
--  SAMPLE DATA
--  Insert order respects FK dependencies:
--  Employee → Customer → Product → Inventory
--  → Sale → Sale_Item → Payment
-- ============================================================


-- ------------------------------------------------------------
--  Employees  (5 records)
-- ------------------------------------------------------------
INSERT INTO Employee (First_Name, Last_Name, Role, Hire_Date, Phone, Email) VALUES
    ('Sandra',  'Torres',   'Manager',     '2019-03-15', '432-555-0101', 's.torres@retailpos.com'),
    ('James',   'Nguyen',   'Cashier',     '2021-07-22', '432-555-0102', 'j.nguyen@retailpos.com'),
    ('Maria',   'Collins',  'Cashier',     '2022-01-10', '432-555-0103', 'm.collins@retailpos.com'),
    ('Derek',   'Okafor',   'Supervisor',  '2020-11-05', '432-555-0104', 'd.okafor@retailpos.com'),
    ('Lily',    'Chen',     'Stock Clerk', '2023-06-18', '432-555-0105', 'l.chen@retailpos.com');


-- ------------------------------------------------------------
--  Customers  (5 records)
-- ------------------------------------------------------------
INSERT INTO Customer (First_Name, Last_Name, Phone, Email, Loyalty_Points, Registration_Date) VALUES
    ('Alice',   'Johnson',  '432-555-1001', 'alice.j@email.com',   120, '2022-05-14'),
    ('Bob',     'Martinez', '432-555-1002', 'bob.m@email.com',     85,  '2023-02-28'),
    ('Carol',   'White',    '432-555-1003', 'carol.w@email.com',   200, '2021-11-03'),
    ('Daniel',  'Kim',      '432-555-1004', 'daniel.k@email.com',  50,  '2024-01-19'),
    ('Emma',    'Davis',    '432-555-1005', 'emma.d@email.com',    310, '2020-08-30');


-- ------------------------------------------------------------
--  Products  (5 records)
-- ------------------------------------------------------------
INSERT INTO Product (Name, Description, Category, Unit_Price, Barcode, Supplier_Info) VALUES
    ('Whole Milk (1 Gal)',        '1 gallon whole milk, pasteurized',         'Dairy',      3.99,  '0001234567890', 'Lone Star Dairy Co., Lubbock TX'),
    ('Sourdough Bread Loaf',      'Artisan sourdough, 24 oz',                 'Bakery',     4.49,  '0002345678901', 'West Texas Bakehouse, Midland TX'),
    ('Organic Apples (3 lb bag)', 'Fuji apples, USDA organic certified',      'Produce',    5.99,  '0003456789012', 'High Plains Organics, Amarillo TX'),
    ('Sharp Cheddar Cheese 16oz', 'Aged 12 months sharp cheddar block',       'Dairy',      6.49,  '0004567890123', 'Lone Star Dairy Co., Lubbock TX'),
    ('Sparkling Water 12-Pack',   '12 fl oz cans, unflavored sparkling water','Beverages',  8.99,  '0005678901234', 'Clear Springs Beverage, Dallas TX');


-- ------------------------------------------------------------
--  Inventory  (5 records — one per product, single location)
-- ------------------------------------------------------------
INSERT INTO Inventory (Product_ID, Quantity_On_Hand, Reorder_Level, Last_Restock_Date, Warehouse_Location) VALUES
    (1, 144, 30, '2026-03-15', 'Aisle 3 - Cooler A'),
    (2,  60, 20, '2026-03-14', 'Aisle 1 - Shelf B'),
    (3,  80, 25, '2026-03-16', 'Aisle 2 - Produce Bin'),
    (4,  95, 20, '2026-03-15', 'Aisle 3 - Cooler B'),
    (5, 110, 35, '2026-03-13', 'Aisle 5 - Shelf A');


-- ------------------------------------------------------------
--  Sales  (6 records)
--  Customer_ID = NULL indicates a guest checkout.
-- ------------------------------------------------------------
INSERT INTO Sale (Employee_ID, Customer_ID, Sale_Date, Sale_Time, Total_Amount, Tax_Amount, Discount_Applied) VALUES
    (2, 1,    '2026-03-17', '09:14:00', 9.14,  0.66, 0.00),   -- Sale 1: registered customer
    (2, NULL, '2026-03-17', '10:32:00', 6.47,  0.48, 0.00),   -- Sale 2: guest checkout
    (3, 2,    '2026-03-17', '11:55:00', 19.51, 1.56, 1.00),   -- Sale 3: loyalty discount
    (4, 3,    '2026-03-18', '14:08:00', 11.32, 0.84, 0.00),   -- Sale 4: registered customer
    (3, NULL, '2026-03-18', '15:20:00', 9.71,  0.72, 0.00),   -- Sale 5: guest checkout
    (2, 4,    '2026-03-19', '08:45:00', 21.19, 1.68, 2.00);   -- Sale 6: manager discount


-- ------------------------------------------------------------
--  Sale_Items  (14 records spread across 6 sales)
-- ------------------------------------------------------------
INSERT INTO Sale_Item (Sale_ID, Product_ID, Quantity, Unit_Price_At_Sale, Line_Discount) VALUES
    -- Sale 1: Milk + Bread
    (1, 1, 1, 3.99, 0.00),
    (1, 2, 1, 4.49, 0.00),

    -- Sale 2: Apples (guest)
    (2, 3, 1, 5.99, 0.00),

    -- Sale 3: Milk + Cheese + Sparkling Water with $1.00 sale-level discount
    (3, 1, 1, 3.99, 0.00),
    (3, 4, 1, 6.49, 0.00),
    (3, 5, 1, 8.99, 0.00),

    -- Sale 4: Bread + Apples
    (4, 2, 1, 4.49, 0.00),
    (4, 3, 1, 5.99, 0.00),

    -- Sale 5: Sparkling Water (guest)
    (5, 5, 1, 8.99, 0.00),

    -- Sale 6: Milk + Bread + Apples + Cheese with $2.00 sale-level discount
    (6, 1, 1, 3.99, 0.00),
    (6, 2, 1, 4.49, 0.00),
    (6, 3, 1, 5.99, 0.00),
    (6, 4, 1, 6.49, 0.00),
    -- second unit of Sparkling Water on this sale
    (6, 5, 2, 8.99, 2.00);


-- ------------------------------------------------------------
--  Payments  (7 records)
--  Sale 3 uses a split payment (Debit + Cash).
-- ------------------------------------------------------------
INSERT INTO Payment (Sale_ID, Payment_Method, Amount_Paid, Payment_Date, Transaction_Reference) VALUES
    (1, 'Credit',  9.14,  '2026-03-17', 'TXN-CC-00481'),
    (2, 'Cash',    6.47,  '2026-03-17',  NULL),           -- cash: no reference
    (3, 'Debit',  15.00,  '2026-03-17', 'TXN-DB-00219'),  -- split payment pt.1
    (3, 'Cash',    4.51,  '2026-03-17',  NULL),           -- split payment pt.2
    (4, 'Debit',  11.32,  '2026-03-18', 'TXN-DB-00220'),
    (5, 'Cash',    9.71,  '2026-03-18',  NULL),
    (6, 'Credit', 21.19,  '2026-03-19', 'TXN-CC-00482');