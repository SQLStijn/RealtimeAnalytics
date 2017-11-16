--- OLAP & OLTP  Scenario 1
DROP INDEX IF EXISTS CI_TEST ON SSD.Orders
GO
DROP INDEX IF EXISTS ColumnstoreIndex ON SSD.Orders
GO
CREATE CLUSTERED INDEX CI_TEST ON SSD.Orders (OrderID)
GO
CREATE NONCLUSTERED COLUMNSTORE INDEX ColumnStoreIndex ON SSD.Orders
(
OrderID, Quantity, SalesPersonID, CustomerPersonID, ItemID, DateOfSale, payed
)
where payed = 1
GO


--- OPEN FOLLOWING WORKLOAD IN SQL QUERY STRESS 100 Iterations & 2 Threads

EXEC dbo.OLAPWorkload
EXEC dbo.OLTPWorkload
