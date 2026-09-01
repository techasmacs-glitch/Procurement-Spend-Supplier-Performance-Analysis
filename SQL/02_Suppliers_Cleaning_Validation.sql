/*
====================================================
SUPPLIERS — CLEANING & VALIDATION

Purpose:
Create a cleaned suppliers table by removing exact
duplicate records and standardizing supplier rating
data types.

Validation:
Verify supplier ID uniqueness and identify any
remaining missing supplier ratings.

Source:
dbo.suppliers_messy

Output:
dbo.suppliers_clean
====================================================
*/



DROP TABLE IF EXISTS dbo.suppliers_clean;

SELECT DISTINCT
    Supplier_ID,
    Supplier_Name,
    Supplier_Category,
    Region,
    CAST(Supplier_Rating AS DECIMAL(3,2)) AS Supplier_Rating,
    Contract_Status,
    Pricing_Profile
INTO dbo.suppliers_clean
FROM dbo.suppliers_messy;


SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Supplier_ID) AS Unique_Suppliers
FROM dbo.suppliers_clean;


SELECT
    COUNT(*) AS Missing_Ratings
FROM dbo.suppliers_clean
WHERE Supplier_Rating IS NULL;