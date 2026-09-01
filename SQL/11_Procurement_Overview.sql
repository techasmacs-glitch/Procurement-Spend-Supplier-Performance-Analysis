/*
PROCUREMENT OVERVIEW
High-level summary of procurement activity.
*/

SELECT
    COUNT(DISTINCT PO_ID) AS Total_Purchase_Orders,
    COUNT(DISTINCT Supplier_ID) AS Total_Suppliers,
    SUM(Total_Cost) AS Total_Procurement_Spend,
    AVG(Total_Cost) AS Average_PO_Value,
    SUM(Quantity) AS Total_Quantity_Ordered
FROM dbo.purchase_orders_clean;



SELECT
    Department,
    COUNT(DISTINCT PO_ID) AS Purchase_Order_Count,
    SUM(Total_Cost) AS Total_Procurement_Spend,
    AVG(Total_Cost) AS Average_Purchase_Order_Cost,
    SUM(Quantity) AS Total_Quantity_Ordered
FROM dbo.purchase_orders_clean
GROUP BY Department
ORDER BY Total_Procurement_Spend DESC;


/*
PROCUREMENT SPEND BY PRODUCT CATEGORY
*/

SELECT
    Product_Category,
    COUNT(DISTINCT PO_ID) AS Purchase_Order_Count,
    SUM(Total_Cost) AS Total_Procurement_Spend,
    AVG(Total_Cost) AS Average_Purchase_Order_Cost,
    SUM(Quantity) AS Total_Quantity_Ordered
FROM dbo.purchase_orders_clean
GROUP BY Product_Category
ORDER BY Total_Procurement_Spend DESC;