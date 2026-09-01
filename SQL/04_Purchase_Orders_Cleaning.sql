/*
====================================================
PURCHASE ORDERS — CLEANING & VALIDATION

Purpose:
Create a cleaned purchase orders table by removing
exact duplicates, handling missing departments,
standardizing financial data types, and correcting
invalid delivery-day values.

Validation:
Verify row uniqueness, missing values, and
Total Cost calculation accuracy.

Source:
dbo.purchase_orders_messy

Output:
dbo.purchase_orders_clean
====================================================
*/




DROP TABLE IF EXISTS dbo.purchase_orders_clean;

SELECT DISTINCT
    PO_ID,
    Supplier_ID,
    COALESCE(Department, Product_Category) AS Department,
    Order_Date,
    Product_Category,
    Quantity,
    CAST(Unit_Price AS DECIMAL(18,2)) AS Unit_Price,
    CAST(Total_Cost AS DECIMAL(18,2)) AS Total_Cost,
    CASE
        WHEN Delivery_Days < 0 THEN NULL
        ELSE Delivery_Days
    END AS Delivery_Days,
    Order_Status
INTO dbo.purchase_orders_clean
FROM dbo.purchase_orders_messy;


SELECT *
FROM dbo.purchase_orders_clean;


SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT PO_ID) AS Unique_POs
FROM dbo.purchase_orders_clean;

SELECT
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Missing_Department,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN Total_Cost IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Cost,
    SUM(CASE WHEN Delivery_Days < 0 THEN 1 ELSE 0 END) AS Negative_Delivery_Days
FROM dbo.purchase_orders_clean;



SELECT
    COUNT(*) AS Invalid_Total_Cost
FROM dbo.purchase_orders_clean
WHERE Total_Cost <>
      CAST(
          ROUND(Quantity * Unit_Price, 2)
          AS DECIMAL(18,2)
      );