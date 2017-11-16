-- NCCI trick!

--- Delete NCCI from BatchModeProcessing Table

DROP INDEX  IF EXISTS BatchModeIndex ON dbo.BatchModeProcessing
GO

--- Turn on client statistics & Query plan!

select sum(Quantity),itemid 
from  dbo.BatchModeProcessing  group by itemid


--- Create an empty columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX BatchModeIndex ON  dbo.BatchModeProcessing
(
OrderID, Quantity, SalesPersonID, CustomerPersonID, ItemID, DateOfSale, payed
)
WHERE OrderID = -1 and OrderID = -2

--- Execute same query again
select sum(Quantity),itemid 
from  dbo.BatchModeProcessing  group by itemid






