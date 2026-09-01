/*
PAYMENT OVERVIEW
*/

SELECT
    COUNT(DISTINCT Payment_ID) AS Total_Payments,
    COUNT(DISTINCT PO_ID) AS Purchase_Orders_With_Payments,
    SUM(Payment_Amount) AS Total_Paid,
    AVG(Payment_Amount) AS Average_Payment_Amount
FROM dbo.payments_clean;


/*
PURCHASE ORDERS VS PAYMENTS
*/

SELECT
    po.PO_ID,
    po.Total_Cost,
    COALESCE(SUM(p.Payment_Amount), 0) AS Total_Paid,
    po.Total_Cost - COALESCE(SUM(p.Payment_Amount), 0) AS Outstanding_Amount
FROM dbo.purchase_orders_clean AS po
LEFT JOIN dbo.payments_clean AS p
    ON po.PO_ID = p.PO_ID
GROUP BY
    po.PO_ID,
    po.Total_Cost
HAVING
    po.Total_Cost > COALESCE(SUM(p.Payment_Amount), 0)
ORDER BY Outstanding_Amount DESC;




SELECT
    COUNT(*) AS Total_Purchase_Orders,

    SUM(CASE
        WHEN p.PO_ID IS NULL THEN 1
        ELSE 0
    END) AS Unpaid_PO_Count,

    SUM(CASE
        WHEN p.PO_ID IS NOT NULL THEN 1
        ELSE 0
    END) AS Paid_PO_Count,

    SUM(CASE
        WHEN p.PO_ID IS NULL THEN po.Total_Cost
        ELSE 0
    END) AS Unpaid_PO_Value

FROM dbo.purchase_orders_clean AS po
LEFT JOIN (
    SELECT DISTINCT PO_ID
    FROM dbo.payments_clean
    WHERE Payment_Amount > 0
) AS p
    ON po.PO_ID = p.PO_ID;


    -- ============================================
-- SUPPLIER PERFORMANCE & PROCUREMENT SPEND
-- ============================================

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    s.Contract_Status,
    COUNT(po.PO_ID) AS PO_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend,
    AVG(po.Total_Cost) AS Average_PO_Value
FROM dbo.suppliers_clean AS s
LEFT JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    s.Contract_Status
ORDER BY Total_Procurement_Spend DESC;

-- ============================================
-- HIGH SPEND VS LOW SUPPLIER RATING
-- ============================================

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    SUM(po.Total_Cost) AS Total_Procurement_Spend,
    COUNT(po.PO_ID) AS PO_Count
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
WHERE s.Supplier_Rating IS NOT NULL
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating
HAVING
    SUM(po.Total_Cost) > 10000000
    AND s.Supplier_Rating < 4
ORDER BY
    Total_Procurement_Spend DESC;

-- ============================================
-- PAYMENT COVERAGE BY SUPPLIER
-- ============================================

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    SUM(po.Total_Cost) AS Total_PO_Value,
    COALESCE(SUM(p.Payment_Amount), 0) AS Total_Paid,
    COALESCE(SUM(p.Payment_Amount), 0) - SUM(po.Total_Cost) AS Payment_Difference
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
LEFT JOIN dbo.payments_clean AS p
    ON po.PO_ID = p.PO_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category
ORDER BY
    Total_PO_Value DESC;


-- ============================================
-- PAYMENT COVERAGE RATE
-- ============================================

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    SUM(po.Total_Cost) AS Total_PO_Value,
    COALESCE(SUM(p.Payment_Amount), 0) AS Total_Paid,
    CAST(
        COALESCE(SUM(p.Payment_Amount), 0) * 100.0
        / NULLIF(SUM(po.Total_Cost), 0)
        AS DECIMAL(5,2)
    ) AS Payment_Coverage_Percent
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
LEFT JOIN dbo.payments_clean AS p
    ON po.PO_ID = p.PO_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category
ORDER BY
    Payment_Coverage_Percent ASC;

-- ============================================
-- SUPPLIER RISK INDICATORS
-- ============================================

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    SUM(po.Total_Cost) AS Total_PO_Value,
    COALESCE(SUM(p.Payment_Amount), 0) AS Total_Paid,
    CAST(
        COALESCE(SUM(p.Payment_Amount), 0) * 100.0
        / NULLIF(SUM(po.Total_Cost), 0)
        AS DECIMAL(5,2)
    ) AS Payment_Coverage_Percent
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
LEFT JOIN dbo.payments_clean AS p
    ON po.PO_ID = p.PO_ID
WHERE s.Supplier_Rating IS NOT NULL
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating
HAVING
    SUM(po.Total_Cost) > 10000000
    AND s.Supplier_Rating < 4
    AND COALESCE(SUM(p.Payment_Amount), 0) * 100.0
        / NULLIF(SUM(po.Total_Cost), 0) < 70
ORDER BY
    Total_PO_Value DESC;