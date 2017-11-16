--- BATCH MODE DEMO

---CREATE NONCLUSTERED COLUMNSTORE INDEX


DROP INDEX  IF EXISTS BatchModeIndex ON dbo.BatchModeProcessing
GO
CREATE NONCLUSTERED COLUMNSTORE INDEX BatchModeIndex ON  dbo.BatchModeProcessing
(
OrderID, Quantity, SalesPersonID, CustomerPersonID, ItemID, DateOfSale, payed
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
---- Write a simple query on SSD.Orders Table
---- Include Plan


--Execute the query without the columnstore index

SET STATISTICS TIME ON
PRINT 'ROWSTORE START'
select count(*) from  dbo.BatchModeProcessing
option (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)
PRINT 'ROWSTORE END'
PRINT'COLUMNSTORE START'
select count(*) from  dbo.BatchModeProcessing
PRINT 'COLUMNSTORE END'

--- More complex query
PRINT 'ROWSTORE START'
select sum(Quantity),itemid 
from  dbo.BatchModeProcessing  group by itemid
option (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)
PRINT 'ROWSTORE END'
PRINT 'COLUMNSTORE START'
select sum(Quantity),itemid 
from  dbo.BatchModeProcessing  group by itemid
PRINT 'COLUMNSTORE END'

SET STATISTICS TIME OFF





