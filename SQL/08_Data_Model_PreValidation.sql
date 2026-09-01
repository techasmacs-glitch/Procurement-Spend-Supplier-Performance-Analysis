SELECT
    Supplier_ID,
    COUNT(*) AS Record_Count
FROM dbo.suppliers_clean
GROUP BY Supplier_ID
HAVING COUNT(*) > 1;

SELECT
    PO_ID,
    COUNT(*) AS Record_Count
FROM dbo.purchase_orders_clean
GROUP BY PO_ID
HAVING COUNT(*) > 1;

SELECT
    Payment_ID,
    COUNT(*) AS Record_Count
FROM dbo.payments_clean
GROUP BY Payment_ID
HAVING COUNT(*) > 1;

SELECT DISTINCT
    po.Supplier_ID
FROM dbo.purchase_orders_clean AS po
LEFT JOIN dbo.suppliers_clean AS s
    ON po.Supplier_ID = s.Supplier_ID
WHERE s.Supplier_ID IS NULL;


SELECT DISTINCT
    p.PO_ID
FROM dbo.payments_clean AS p
LEFT JOIN dbo.purchase_orders_clean AS po
    ON p.PO_ID = po.PO_ID
WHERE po.PO_ID IS NULL;