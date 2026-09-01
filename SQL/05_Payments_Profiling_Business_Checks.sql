/*
====================================================
PAYMENTS — DATA PROFILING & BUSINESS CHECKS

Purpose:
Profile the raw payments data and identify
duplicates, missing values, invalid payment amounts,
referential integrity issues, and potential
overpayments.

Business Check:
Compare total payments against purchase order
costs to identify potential overpayment cases.

Source:
dbo.payments_messy

Related Table:
dbo.purchase_orders_clean
====================================================
*/



SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Payment_ID) AS Unique_Payments
FROM dbo.payments_messy;




SELECT
    Payment_ID,
    COUNT(*) AS Record_Count
FROM dbo.payments_messy
GROUP BY Payment_ID
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;




SELECT
    SUM(CASE WHEN Payment_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_ID,
    SUM(CASE WHEN PO_ID IS NULL THEN 1 ELSE 0 END) AS Missing_PO_ID,
    SUM(CASE WHEN Payment_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Date,
    SUM(CASE WHEN Payment_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Amount,
    SUM(CASE WHEN Payment_Status IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Status
FROM dbo.payments_messy;




SELECT
    p.Payment_ID,
    p.PO_ID
FROM dbo.payments_messy AS p
LEFT JOIN dbo.purchase_orders_clean AS po
    ON p.PO_ID = po.PO_ID
WHERE po.PO_ID IS NULL;




SELECT
    MIN(Payment_Amount) AS Minimum_Payment_Amount,
    MAX(Payment_Amount) AS Maximum_Payment_Amount
FROM dbo.payments_messy;




SELECT
    COUNT(*) AS Invalid_Payment_Amounts
FROM dbo.payments_messy
WHERE Payment_Amount <= 0;




SELECT
    MIN(Payment_Date) AS Minimum_Payment_Date,
    MAX(Payment_Date) AS Maximum_Payment_Date
FROM dbo.payments_messy;




SELECT
    Payment_Status,
    COUNT(*) AS Payment_Count
FROM dbo.payments_messy
GROUP BY Payment_Status
ORDER BY Payment_Count DESC;




SELECT
    COUNT(*) AS Potential_Overpayments
FROM
(
    SELECT
        p.PO_ID,
        SUM(p.Payment_Amount) AS Total_Paid,
        po.Total_Cost
    FROM dbo.payments_messy AS p
    INNER JOIN dbo.purchase_orders_clean AS po
        ON p.PO_ID = po.PO_ID
    GROUP BY
        p.PO_ID,
        po.Total_Cost
    HAVING SUM(p.Payment_Amount) > po.Total_Cost
) AS x;