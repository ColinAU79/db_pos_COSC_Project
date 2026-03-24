# db_pos_COSC_Project
Simple databse and schema project for COSC database systems
Works on MySQL in a local enviroment
# Sample ddl commands

SELECT * FROM Product;

SELECT Name, Unit_Price FROM Product order by Unit_Price desc;

SELECT First_Name, Last_Name, Email, Loyalty_Points FROM Customer WHERE Loyalty_Points > 100 order by Loyalty_Points desc;

SELECT
    Payment_Method,
    COUNT(*)           AS Times_Used,
    SUM(Amount_Paid)   AS Total_Revenue
FROM Payment
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;

