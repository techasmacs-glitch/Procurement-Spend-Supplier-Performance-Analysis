/*
SUPPLIER SPEND ANALYSIS
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Region,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend,
    AVG(po.Total_Cost) AS Average_Purchase_Order_Cost
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Region
ORDER BY Total_Procurement_Spend DESC;



/*
SUPPLIER PERFORMANCE VS SPEND
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Region,
    s.Supplier_Rating,
    s.Contract_Status,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend,
    AVG(po.Delivery_Days) AS Average_Delivery_Days
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Region,
    s.Supplier_Rating,
    s.Contract_Status
ORDER BY Total_Procurement_Spend DESC;


/*
SUPPLIER PERFORMANCE BENCHMARKS
*/

SELECT
    AVG(s.Supplier_Rating) AS Average_Supplier_Rating,
    AVG(po.Total_Cost) AS Average_Purchase_Order_Cost,
    AVG(po.Delivery_Days) AS Average_Delivery_Days
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
WHERE s.Supplier_Rating IS NOT NULL;

/*
SUPPLIER SPEND BENCHMARK
*/

SELECT
    AVG(Supplier_Spend) AS Average_Supplier_Spend
FROM
(
    SELECT
        Supplier_ID,
        SUM(Total_Cost) AS Supplier_Spend
    FROM dbo.purchase_orders_clean
    GROUP BY Supplier_ID
) AS SupplierSpend;




/*
HIGH-SPEND SUPPLIERS REQUIRING REVIEW
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    s.Contract_Status,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend,
    AVG(po.Delivery_Days) AS Average_Delivery_Days
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
WHERE s.Supplier_Rating IS NOT NULL
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    s.Contract_Status
HAVING
    SUM(po.Total_Cost) > 5690983.37
    AND s.Supplier_Rating < 4.064948
    AND AVG(po.Delivery_Days) > 24
ORDER BY Total_Procurement_Spend DESC;


/*
HIGH-SPEND SUPPLIERS VS RATING
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Supplier_Rating,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend
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
    SUM(po.Total_Cost) > 5690983.37
    AND s.Supplier_Rating < 4.064948
ORDER BY Total_Procurement_Spend DESC;


/*
HIGH-SPEND SUPPLIERS VS DELIVERY
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    AVG(po.Delivery_Days) AS Average_Delivery_Days,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category
HAVING
    SUM(po.Total_Cost) > 5690983.37
    AND AVG(po.Delivery_Days) > 24
ORDER BY Total_Procurement_Spend DESC;

/*
HIGH-SPEND SUPPLIERS WITH EXPIRED CONTRACTS
*/

SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Contract_Status,
    COUNT(DISTINCT po.PO_ID) AS Purchase_Order_Count,
    SUM(po.Total_Cost) AS Total_Procurement_Spend
FROM dbo.suppliers_clean AS s
INNER JOIN dbo.purchase_orders_clean AS po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Supplier_Category,
    s.Contract_Status
HAVING
    SUM(po.Total_Cost) > 5690983.37
    AND s.Contract_Status = 'Expired'
ORDER BY Total_Procurement_Spend DESC;

