ALTER TABLE dbo.suppliers_clean
ADD CONSTRAINT PK_suppliers_clean
PRIMARY KEY (Supplier_ID);

ALTER TABLE dbo.purchase_orders_clean
ADD CONSTRAINT PK_purchase_orders_clean
PRIMARY KEY (PO_ID);

ALTER TABLE dbo.payments_clean
ADD CONSTRAINT PK_payments_clean
PRIMARY KEY (Payment_ID);

