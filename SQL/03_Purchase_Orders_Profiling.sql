
/*
====================================================
PURCHASE ORDERS — DATA PROFILING & QUALITY CHECKS

Purpose:
Profile the raw purchase orders data and identify
duplicates, missing values, invalid values,
referential integrity issues, and business-rule
inconsistencies before data cleaning.

Source:
dbo.purchase_orders_messy
====================================================
*/

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT PO_ID) AS Unique_POs
FROM dbo.purchase_orders_messy;


-- 2. Duplicate PO IDs

SELECT
    PO_ID,
    COUNT(*) AS Record_Count
FROM dbo.purchase_orders_messy
GROUP BY PO_ID
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;


-- 3. Missing Values

SELECT
    SUM(CASE WHEN PO_ID IS NULL THEN 1 ELSE 0 END) AS Missing_PO_ID,
    SUM(CASE WHEN Supplier_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_ID,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Missing_Department,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Date,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS Missing_Product_Category,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN Total_Cost IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Cost,
    SUM(CASE WHEN Delivery_Days IS NULL THEN 1 ELSE 0 END) AS Missing_Delivery_Days,
    SUM(CASE WHEN Order_Status IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Status
FROM dbo.purchase_orders_messy;


-- 4. Invalid / Missing Supplier IDs

SELECT
    po.PO_ID,
    po.Supplier_ID
FROM dbo.purchase_orders_messy AS po
LEFT JOIN dbo.suppliers_clean AS s
    ON po.Supplier_ID = s.Supplier_ID
WHERE s.Supplier_ID IS NULL;


-- 5. Quantity Range

SELECT
    MIN(Quantity) AS Minimum_Quantity,
    MAX(Quantity) AS Maximum_Quantity
FROM dbo.purchase_orders_messy;


-- 6. Invalid Quantities

SELECT
    COUNT(*) AS Invalid_Quantities
FROM dbo.purchase_orders_messy
WHERE Quantity <= 0;


-- 7. Unit Price Range

SELECT
    MIN(Unit_Price) AS Minimum_Unit_Price,
    MAX(Unit_Price) AS Maximum_Unit_Price
FROM dbo.purchase_orders_messy;


-- 8. Invalid Unit Prices

SELECT
    COUNT(*) AS Invalid_Unit_Prices
FROM dbo.purchase_orders_messy
WHERE Unit_Price <= 0;


-- 9. Total Cost Validation

SELECT
    COUNT(*) AS Invalid_Total_Cost
FROM dbo.purchase_orders_messy
WHERE ROUND(Total_Cost, 2) <>
      ROUND(Quantity * Unit_Price, 2);


-- 10. Delivery Days Range

SELECT
    MIN(Delivery_Days) AS Minimum_Delivery_Days,
    MAX(Delivery_Days) AS Maximum_Delivery_Days
FROM dbo.purchase_orders_messy;


-- 11. Invalid Delivery Days

SELECT
    PO_ID,
    Order_Date,
    Delivery_Days,
    Order_Status
FROM dbo.purchase_orders_messy
WHERE Delivery_Days < 0;


-- 12. Order Date Range

SELECT
    MIN(Order_Date) AS Minimum_Order_Date,
    MAX(Order_Date) AS Maximum_Order_Date
FROM dbo.purchase_orders_messy;


-- 13. Product Categories

SELECT
    Product_Category,
    COUNT(*) AS Order_Count
FROM dbo.purchase_orders_messy
GROUP BY Product_Category
ORDER BY Order_Count DESC;


-- 14. Departments

SELECT
    Department,
    COUNT(*) AS Order_Count
FROM dbo.purchase_orders_messy
GROUP BY Department
ORDER BY Order_Count DESC;


-- 15. Order Status

SELECT
    Order_Status,
    COUNT(*) AS Order_Count
FROM dbo.purchase_orders_messy
GROUP BY Order_Status
ORDER BY Order_Count DESC;



SELECT
    PO_ID,
    Supplier_ID,
    Department,
    Product_Category,
    Order_Date,
    Quantity,
    Unit_Price,
    Total_Cost
FROM dbo.purchase_orders_messy
WHERE Department IS NULL;