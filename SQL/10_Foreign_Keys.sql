ALTER TABLE dbo.purchase_orders_clean
ADD CONSTRAINT FK_purchase_orders_suppliers
FOREIGN KEY (Supplier_ID)
REFERENCES dbo.suppliers_clean (Supplier_ID);


ALTER TABLE dbo.payments_clean
ADD CONSTRAINT FK_payments_purchase_orders
FOREIGN KEY (PO_ID)
REFERENCES dbo.purchase_orders_clean (PO_ID);