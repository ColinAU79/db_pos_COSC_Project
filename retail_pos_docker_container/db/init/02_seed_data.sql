-- ============================================================
--  Retail POS — Seed Data
--  File    : 02_seed_data.sql
--  Runs    : Automatically after 01_schema.sql on first start
--  Volumes : 10 Employees, 30 Customers, 20 Products,
--            20 Inventory, 100 Sales, ~250 Sale_Items,
--            ~115 Payments
-- ============================================================

USE retail_pos;

-- ============================================================
--  EMPLOYEES (10 records — hardcoded for realism)
-- ============================================================
INSERT INTO Employee (First_Name, Last_Name, Role, Hire_Date, Phone, Email) VALUES
    ('Sandra',  'Torres',    'Manager',     '2018-04-10', '432-555-0101', 's.torres@retailpos.com'),
    ('James',   'Nguyen',    'Cashier',     '2020-07-22', '432-555-0102', 'j.nguyen@retailpos.com'),
    ('Maria',   'Collins',   'Cashier',     '2021-01-15', '432-555-0103', 'm.collins@retailpos.com'),
    ('Derek',   'Okafor',    'Supervisor',  '2019-11-05', '432-555-0104', 'd.okafor@retailpos.com'),
    ('Lily',    'Chen',      'Stock Clerk', '2022-06-18', '432-555-0105', 'l.chen@retailpos.com'),
    ('Marcus',  'Webb',      'Cashier',     '2023-02-28', '432-555-0106', 'm.webb@retailpos.com'),
    ('Priya',   'Patel',     'Admin',       '2017-09-01', '432-555-0107', 'p.patel@retailpos.com'),
    ('Carlos',  'Rivera',    'Cashier',     '2023-08-14', '432-555-0108', 'c.rivera@retailpos.com'),
    ('Janet',   'Armstrong', 'Supervisor',  '2020-03-22', '432-555-0109', 'j.armstrong@retailpos.com'),
    ('Tyler',   'Brooks',    'Stock Clerk', '2024-01-09', '432-555-0110', 't.brooks@retailpos.com');


-- ============================================================
--  CUSTOMERS (30 records)
-- ============================================================
INSERT INTO Customer (First_Name, Last_Name, Phone, Email, Loyalty_Points, Registration_Date) VALUES
    ('Alice',    'Johnson',   '432-555-2001', 'alice.j@email.com',    120, '2021-05-14'),
    ('Bob',      'Martinez',  '432-555-2002', 'bob.m@email.com',       85, '2022-02-28'),
    ('Carol',    'White',     '432-555-2003', 'carol.w@email.com',    200, '2020-11-03'),
    ('Daniel',   'Kim',       '432-555-2004', 'daniel.k@email.com',    50, '2023-01-19'),
    ('Emma',     'Davis',     '432-555-2005', 'emma.d@email.com',     310, '2019-08-30'),
    ('Frank',    'Thompson',  '432-555-2006', 'frank.t@email.com',     15, '2024-03-01'),
    ('Grace',    'Lee',       '432-555-2007', 'grace.l@email.com',    175, '2021-07-11'),
    ('Henry',    'Wilson',    '432-555-2008', 'henry.w@email.com',     90, '2022-09-25'),
    ('Isabelle', 'Moore',     '432-555-2009', 'isabelle.m@email.com', 240, '2020-04-17'),
    ('Jack',     'Taylor',    '432-555-2010', 'jack.t@email.com',      60, '2023-06-05'),
    ('Karen',    'Anderson',  '432-555-2011', 'karen.a@email.com',    400, '2018-12-22'),
    ('Luis',     'Garcia',    '432-555-2012', 'luis.g@email.com',      30, '2024-01-08'),
    ('Megan',    'Jackson',   '432-555-2013', 'megan.j@email.com',    155, '2021-10-14'),
    ('Nathan',   'Harris',    '432-555-2014', 'nathan.h@email.com',    75, '2022-08-19'),
    ('Olivia',   'Clark',     '432-555-2015', 'olivia.c@email.com',   280, '2020-02-07'),
    ('Paul',     'Lewis',     '432-555-2016', 'paul.l@email.com',      45, '2023-11-30'),
    ('Quinn',    'Robinson',  '432-555-2017', 'quinn.r@email.com',    195, '2021-03-23'),
    ('Rachel',   'Walker',    '432-555-2018', 'rachel.w@email.com',   110, '2022-05-16'),
    ('Steven',   'Hall',      '432-555-2019', 'steven.h@email.com',   350, '2019-07-04'),
    ('Tina',     'Allen',     '432-555-2020', 'tina.a@email.com',      20, '2024-02-14'),
    ('Uma',      'Young',     '432-555-2021', 'uma.y@email.com',      165, '2021-09-09'),
    ('Victor',   'Hernandez', '432-555-2022', 'victor.h@email.com',    55, '2022-12-03'),
    ('Wendy',    'King',      '432-555-2023', 'wendy.k@email.com',    225, '2020-06-28'),
    ('Xavier',   'Wright',    '432-555-2024', 'xavier.w@email.com',    80, '2023-04-11'),
    ('Yolanda',  'Scott',     '432-555-2025', 'yolanda.s@email.com',  300, '2020-01-15'),
    ('Zachary',  'Green',     '432-555-2026', 'zachary.g@email.com',   10, '2024-03-10'),
    ('Amy',      'Baker',     '432-555-2027', 'amy.b@email.com',      140, '2021-11-27'),
    ('Brian',    'Adams',     '432-555-2028', 'brian.a@email.com',     95, '2022-07-08'),
    ('Christine','Nelson',    '432-555-2029', 'chris.n@email.com',    215, '2020-09-21'),
    ('David',    'Carter',    '432-555-2030', 'david.c@email.com',     65, '2023-08-16');


-- ============================================================
--  PRODUCTS (20 records across 5 categories)
-- ============================================================
INSERT INTO Product (Name, Description, Category, Unit_Price, Barcode, Supplier_Info) VALUES
    ('Whole Milk 1 Gal',         '1 gallon whole milk, pasteurized',                'Dairy',      3.99,  '0001000000001', 'Lone Star Dairy, Lubbock TX'),
    ('Sharp Cheddar 16oz',       'Aged 12-month sharp cheddar block',               'Dairy',      6.49,  '0001000000002', 'Lone Star Dairy, Lubbock TX'),
    ('Greek Yogurt 32oz',        'Plain whole milk Greek yogurt',                   'Dairy',      5.29,  '0001000000003', 'Lone Star Dairy, Lubbock TX'),
    ('Sourdough Bread Loaf',     'Artisan sourdough, 24oz',                         'Bakery',     4.49,  '0002000000001', 'West Texas Bakehouse, Midland TX'),
    ('Whole Wheat Bagels 6pk',   'Stone ground whole wheat, 6 count',              'Bakery',     3.79,  '0002000000002', 'West Texas Bakehouse, Midland TX'),
    ('Blueberry Muffins 4pk',    'Fresh baked blueberry muffins, 4 count',          'Bakery',     4.99,  '0002000000003', 'West Texas Bakehouse, Midland TX'),
    ('Organic Apples 3lb',       'Fuji apples, USDA organic certified',             'Produce',    5.99,  '0003000000001', 'High Plains Organics, Amarillo TX'),
    ('Baby Spinach 5oz',         'Pre-washed baby spinach, ready to eat',           'Produce',    3.49,  '0003000000002', 'High Plains Organics, Amarillo TX'),
    ('Roma Tomatoes 2lb',        'Vine-ripened Roma tomatoes',                      'Produce',    2.99,  '0003000000003', 'High Plains Organics, Amarillo TX'),
    ('Yellow Onions 3lb',        'Sweet yellow onions, 3 lb bag',                   'Produce',    1.99,  '0003000000004', 'High Plains Organics, Amarillo TX'),
    ('Sparkling Water 12pk',     '12 fl oz cans, unflavored sparkling water',       'Beverages',  8.99,  '0004000000001', 'Clear Springs Beverage, Dallas TX'),
    ('Orange Juice 52oz',        '100% pure squeezed orange juice, no pulp',        'Beverages',  5.49,  '0004000000002', 'Sunshine Grove Co., Austin TX'),
    ('Cold Brew Coffee 32oz',    'Single origin cold brew concentrate',             'Beverages',  9.99,  '0004000000003', 'Lone Star Roasters, San Antonio TX'),
    ('Sports Drink 6pk',         'Electrolyte sports drink, mixed berry, 6 count',  'Beverages',  6.79,  '0004000000004', 'Clear Springs Beverage, Dallas TX'),
    ('Chicken Breast 2lb',       'Boneless skinless chicken breast, 2 lb pkg',      'Meat',      10.99,  '0005000000001', 'Panhandle Meats, Amarillo TX'),
    ('Ground Beef 1lb 80/20',    '80/20 ground beef, 1 lb',                         'Meat',       6.99,  '0005000000002', 'Panhandle Meats, Amarillo TX'),
    ('Salmon Fillet 1lb',        'Atlantic salmon fillet, fresh, 1 lb',             'Meat',      12.99,  '0005000000003', 'Gulf Coast Seafood, Houston TX'),
    ('Turkey Deli Slices 9oz',   'Oven roasted turkey breast, 9 oz pkg',            'Meat',       5.49,  '0005000000004', 'Panhandle Meats, Amarillo TX'),
    ('Russet Potatoes 5lb',      'Idaho russet potatoes, 5 lb bag',                 'Produce',    3.29,  '0003000000005', 'High Plains Organics, Amarillo TX'),
    ('Pasta Sauce 24oz',         'Marinara pasta sauce, San Marzano tomatoes',      'Bakery',     4.19,  '0002000000004', 'Bella Italia Imports, Dallas TX');


-- ============================================================
--  INVENTORY (20 records — one per product)
-- ============================================================
INSERT INTO Inventory (Product_ID, Quantity_On_Hand, Reorder_Level, Last_Restock_Date, Warehouse_Location) VALUES
    ( 1, 144, 30, '2026-03-15', 'Aisle 3 - Cooler A'),
    ( 2,  95, 20, '2026-03-15', 'Aisle 3 - Cooler B'),
    ( 3,  60, 20, '2026-03-14', 'Aisle 3 - Cooler C'),
    ( 4,  72, 20, '2026-03-14', 'Aisle 1 - Shelf A'),
    ( 5,  48, 15, '2026-03-13', 'Aisle 1 - Shelf B'),
    ( 6,  36, 15, '2026-03-16', 'Aisle 1 - Shelf C'),
    ( 7,  80, 25, '2026-03-16', 'Aisle 2 - Produce Bin A'),
    ( 8,  55, 20, '2026-03-16', 'Aisle 2 - Produce Bin B'),
    ( 9,  90, 25, '2026-03-15', 'Aisle 2 - Produce Bin C'),
    (10, 110, 30, '2026-03-14', 'Aisle 2 - Produce Bin D'),
    (11, 132, 35, '2026-03-13', 'Aisle 5 - Shelf A'),
    (12,  66, 20, '2026-03-15', 'Aisle 5 - Cooler A'),
    (13,  40, 15, '2026-03-12', 'Aisle 5 - Cooler B'),
    (14,  58, 20, '2026-03-14', 'Aisle 5 - Shelf B'),
    (15,  44, 15, '2026-03-16', 'Aisle 4 - Cooler A'),
    (16,  76, 20, '2026-03-15', 'Aisle 4 - Cooler B'),
    (17,  28, 10, '2026-03-13', 'Aisle 4 - Cooler C'),
    (18,  50, 15, '2026-03-14', 'Aisle 4 - Cooler D'),
    (19, 100, 30, '2026-03-15', 'Aisle 2 - Produce Bin E'),
    (20,  62, 20, '2026-03-13', 'Aisle 6 - Shelf A');


-- ============================================================
--  GENERATE SALES, SALE_ITEMS, AND PAYMENTS
--  Uses a stored procedure with a loop to produce:
--    100 Sales  |  ~250 Sale_Items  |  ~115 Payments
-- ============================================================

DELIMITER $$

CREATE PROCEDURE generate_sales()
BEGIN
    DECLARE i             INT DEFAULT 1;
    DECLARE v_sale_id     INT;
    DECLARE v_employee_id INT;
    DECLARE v_customer_id INT;
    DECLARE v_sale_date   DATE;
    DECLARE v_sale_time   TIME;
    DECLARE v_num_items   INT;
    DECLARE v_subtotal    DECIMAL(10,2);
    DECLARE v_tax         DECIMAL(10,2);
    DECLARE v_discount    DECIMAL(10,2);
    DECLARE v_total       DECIMAL(10,2);
    DECLARE v_product_id  INT;
    DECLARE v_quantity    INT;
    DECLARE v_unit_price  DECIMAL(10,2);
    DECLARE v_line_disc   DECIMAL(10,2);
    DECLARE v_split_amt   DECIMAL(10,2);
    DECLARE j             INT;

    WHILE i <= 100 DO

        -- Random employee (1–10)
        SET v_employee_id = FLOOR(1 + RAND() * 10);

        -- 30% chance of guest checkout (NULL customer)
        IF RAND() < 0.30 THEN
            SET v_customer_id = NULL;
        ELSE
            SET v_customer_id = FLOOR(1 + RAND() * 30);
        END IF;

        -- Random date within the past 90 days
        SET v_sale_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 90) DAY);

        -- Random time between 08:00 and 20:59
        SET v_sale_time = MAKETIME(
            FLOOR(8  + RAND() * 13),
            FLOOR(RAND() * 60),
            FLOOR(RAND() * 60)
        );

        -- 20% chance of a sale-level discount ($1–$5)
        IF RAND() < 0.20 THEN
            SET v_discount = ROUND(1 + RAND() * 4, 2);
        ELSE
            SET v_discount = 0.00;
        END IF;

        -- Insert Sale with placeholder totals (updated after items)
        INSERT INTO Sale
            (Employee_ID, Customer_ID, Sale_Date, Sale_Time,
             Total_Amount, Tax_Amount, Discount_Applied)
        VALUES
            (v_employee_id, v_customer_id, v_sale_date, v_sale_time,
             0.00, 0.00, v_discount);

        SET v_sale_id   = LAST_INSERT_ID();
        SET v_num_items = FLOOR(1 + RAND() * 4);   -- 1 to 4 line items
        SET v_subtotal  = 0.00;
        SET j           = 1;

        -- Insert Sale_Items
        WHILE j <= v_num_items DO
            SET v_product_id = FLOOR(1 + RAND() * 20);
            SET v_quantity   = FLOOR(1 + RAND() * 3);   -- 1 to 3 units

            SELECT Unit_Price INTO v_unit_price
            FROM   Product
            WHERE  Product_ID = v_product_id;

            -- 10% chance of a small line-level discount
            IF RAND() < 0.10 THEN
                SET v_line_disc = ROUND(v_unit_price * 0.10, 2);
            ELSE
                SET v_line_disc = 0.00;
            END IF;

            INSERT INTO Sale_Item
                (Sale_ID, Product_ID, Quantity, Unit_Price_At_Sale, Line_Discount)
            VALUES
                (v_sale_id, v_product_id, v_quantity, v_unit_price, v_line_disc);

            SET v_subtotal = v_subtotal + (v_quantity * v_unit_price) - v_line_disc;
            SET j = j + 1;
        END WHILE;

        -- Finalise totals: apply sale discount, add 8% tax
        SET v_subtotal = GREATEST(v_subtotal - v_discount, 0.00);
        SET v_tax      = ROUND(v_subtotal * 0.08, 2);
        SET v_total    = ROUND(v_subtotal + v_tax, 2);

        UPDATE Sale
        SET    Total_Amount = v_total,
               Tax_Amount   = v_tax
        WHERE  Sale_ID = v_sale_id;

        -- Insert Payment(s)
        -- 15% chance of split payment
        IF RAND() < 0.15 THEN
            -- First payment covers 40–70% of total
            SET v_split_amt = ROUND(v_total * (0.4 + RAND() * 0.3), 2);

            INSERT INTO Payment
                (Sale_ID, Payment_Method, Amount_Paid, Payment_Date, Transaction_Reference)
            VALUES (
                v_sale_id,
                ELT(FLOOR(1 + RAND() * 4), 'Credit', 'Debit', 'Gift Card', 'Store Credit'),
                v_split_amt,
                v_sale_date,
                CONCAT('TXN-', LPAD(FLOOR(10000 + RAND() * 89999), 5, '0'))
            );

            -- Second payment covers the remainder in cash
            INSERT INTO Payment
                (Sale_ID, Payment_Method, Amount_Paid, Payment_Date, Transaction_Reference)
            VALUES (
                v_sale_id,
                'Cash',
                ROUND(v_total - v_split_amt, 2),
                v_sale_date,
                NULL
            );

        ELSE
            -- Single payment: 25% cash, 75% card/gift
            IF RAND() < 0.25 THEN
                INSERT INTO Payment
                    (Sale_ID, Payment_Method, Amount_Paid, Payment_Date, Transaction_Reference)
                VALUES (
                    v_sale_id, 'Cash', v_total, v_sale_date, NULL
                );
            ELSE
                INSERT INTO Payment
                    (Sale_ID, Payment_Method, Amount_Paid, Payment_Date, Transaction_Reference)
                VALUES (
                    v_sale_id,
                    ELT(FLOOR(1 + RAND() * 4), 'Credit', 'Debit', 'Gift Card', 'Store Credit'),
                    v_total,
                    v_sale_date,
                    CONCAT('TXN-', LPAD(FLOOR(10000 + RAND() * 89999), 5, '0'))
                );
            END IF;
        END IF;

        SET i = i + 1;
    END WHILE;

END$$

DELIMITER ;

-- Run and then clean up the procedure
CALL generate_sales();
DROP PROCEDURE IF EXISTS generate_sales;
