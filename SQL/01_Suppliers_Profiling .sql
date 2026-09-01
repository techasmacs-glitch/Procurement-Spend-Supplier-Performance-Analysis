/*
====================================================
SUPPLIERS — DATA PROFILING

Purpose:
Profile the raw suppliers data and assess data
quality across supplier identifiers, attributes,
ratings, contract status, pricing profiles,
categories, and regions.

Checks:
- Row counts and uniqueness
- Duplicate records
- Missing values
- Rating validity
- Categorical distributions
- Supplier rating patterns across key attributes

Source:
dbo.suppliers_messy
====================================================
*/
-- 1. Row Count & Unique Suppliers

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Supplier_ID) AS Unique_Suppliers
FROM dbo.suppliers_messy;


-- 2. Duplicate Supplier IDs

SELECT
    Supplier_ID,
    COUNT(*) AS Record_Count
FROM dbo.suppliers_messy
GROUP BY Supplier_ID
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;


-- 3. Missing Values

SELECT
    SUM(CASE WHEN Supplier_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_ID,
    SUM(CASE WHEN Supplier_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_Name,
    SUM(CASE WHEN Supplier_Category IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_Category,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN Supplier_Rating IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_Rating,
    SUM(CASE WHEN Contract_Status IS NULL THEN 1 ELSE 0 END) AS Missing_Contract_Status,
    SUM(CASE WHEN Pricing_Profile IS NULL THEN 1 ELSE 0 END) AS Missing_Pricing_Profile
FROM dbo.suppliers_messy;


-- 4. Duplicate Records - Check Exact Duplicates

SELECT
    Supplier_ID,
    Supplier_Name,
    Supplier_Category,
    Region,
    Supplier_Rating,
    Contract_Status,
    Pricing_Profile,
    COUNT(*) AS Record_Count
FROM dbo.suppliers_messy
GROUP BY
    Supplier_ID,
    Supplier_Name,
    Supplier_Category,
    Region,
    Supplier_Rating,
    Contract_Status,
    Pricing_Profile
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;


-- 5. Supplier Rating Range

SELECT
    MIN(Supplier_Rating) AS Minimum_Rating,
    MAX(Supplier_Rating) AS Maximum_Rating
FROM dbo.suppliers_messy;


-- 6. Invalid Supplier Ratings

SELECT
    COUNT(*) AS Invalid_Ratings
FROM dbo.suppliers_messy
WHERE Supplier_Rating < 0
   OR Supplier_Rating > 5;


-- 7. Supplier Categories

SELECT
    Supplier_Category,
    COUNT(*) AS Supplier_Count
FROM dbo.suppliers_messy
GROUP BY Supplier_Category
ORDER BY Supplier_Count DESC;


-- 8. Regions

SELECT
    Region,
    COUNT(*) AS Supplier_Count
FROM dbo.suppliers_messy
GROUP BY Region
ORDER BY Supplier_Count DESC;


-- 9. Contract Status

SELECT
    Contract_Status,
    COUNT(*) AS Supplier_Count
FROM dbo.suppliers_messy
GROUP BY Contract_Status
ORDER BY Supplier_Count DESC;


-- 10. Pricing Profile

SELECT
    Pricing_Profile,
    COUNT(*) AS Supplier_Count
FROM dbo.suppliers_messy
GROUP BY Pricing_Profile
ORDER BY Supplier_Count DESC;


SELECT
    *
FROM dbo.suppliers_messy
WHERE Supplier_Rating IS NULL;


SELECT
    Supplier_Category,
    Region,
    Contract_Status,
    Pricing_Profile,
    COUNT(Supplier_ID) AS Supplier_Count,
    AVG(Supplier_Rating) AS Average_Rating
FROM dbo.suppliers_messy
WHERE Supplier_Rating IS NOT NULL
GROUP BY
    Supplier_Category,
    Region,
    Contract_Status,
    Pricing_Profile
ORDER BY
    Supplier_Category,
    Region;