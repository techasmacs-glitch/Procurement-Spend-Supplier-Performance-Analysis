/*
====================================================
PAYMENTS — ANOMALY INVESTIGATION

Purpose:
Investigate payment anomalies identified during
data profiling, including zero-value payments,
potential overpayments, duplicate payment records,
and missing payment attributes.

Objective:
Determine whether identified anomalies represent
data quality issues or valid business states before
applying cleaning rules.

Source:
dbo.payments_messy

Related Table:
dbo.purchase_orders_clean
====================================================
*/




SELECT
    Payment_Amount,
    COUNT(*) AS Record_Count
FROM dbo.payments_messy
WHERE Payment_Amount <= 0
GROUP BY Payment_Amount
ORDER BY Payment_Amount;

SELECT
    p.PO_ID,
    po.Total_Cost,
    SUM(p.Payment_Amount) AS Total_Paid,
    SUM(p.Payment_Amount) - po.Total_Cost AS Overpayment_Amount
FROM dbo.payments_messy AS p
INNER JOIN dbo.purchase_orders_clean AS po
    ON p.PO_ID = po.PO_ID
GROUP BY
    p.PO_ID,
    po.Total_Cost
HAVING SUM(p.Payment_Amount) > po.Total_Cost
ORDER BY Overpayment_Amount DESC;


SELECT
    Payment_ID,
    PO_ID,
    Payment_Date,
    Payment_Amount,
    Payment_Status
FROM dbo.payments_messy
WHERE PO_ID IN ('PO-00647', 'PO-00042', 'PO-00203')
ORDER BY PO_ID, Payment_Date, Payment_ID;





SELECT
    Payment_Status,
    COUNT(*) AS Zero_Payment_Count
FROM dbo.payments_messy
WHERE Payment_Amount = 0
GROUP BY Payment_Status
ORDER BY Zero_Payment_Count DESC;


SELECT
    *
FROM dbo.payments_messy
WHERE Payment_Status IS NULL;



SELECT
    Payment_Status,
    COUNT(*) AS Missing_Date_Count
FROM dbo.payments_messy
WHERE Payment_Date IS NULL
GROUP BY Payment_Status
ORDER BY Missing_Date_Count DESC;