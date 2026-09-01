/*
====================================================
PAYMENTS — CLEANING & VALIDATION

Purpose:
Create a cleaned payments table by removing exact
duplicates and standardizing payment amount data types.

Validation:
Verify payment ID uniqueness and confirm that no
potential overpayments remain after duplicate removal.

Source:
dbo.payments_messy

Output:
dbo.payments_clean
====================================================
*/




DROP TABLE IF EXISTS dbo.payments_clean;

SELECT DISTINCT
    Payment_ID,
    PO_ID,
    Payment_Date,
    CAST(Payment_Amount AS DECIMAL(18,2)) AS Payment_Amount,
    Payment_Status
INTO dbo.payments_clean
FROM dbo.payments_messy;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Payment_ID) AS Unique_Payments
FROM dbo.payments_clean;

SELECT
    p.PO_ID,
    po.Total_Cost,
    SUM(p.Payment_Amount) AS Total_Paid,
    SUM(p.Payment_Amount) - po.Total_Cost AS Difference
FROM dbo.payments_clean AS p
INNER JOIN dbo.purchase_orders_clean AS po
    ON p.PO_ID = po.PO_ID
GROUP BY
    p.PO_ID,
    po.Total_Cost
HAVING SUM(p.Payment_Amount) > po.Total_Cost
ORDER BY Difference DESC;