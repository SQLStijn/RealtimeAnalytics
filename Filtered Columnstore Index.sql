--- Filtered NCCI

--Drop if exists
DROP INDEX IF EXISTS NCCI_Filtered on dbo.FilteredNCCI
GO

/****** Object:  Index [NCI_TEST]    Script Date: 10/10/2017 15:36:20 ******/
DROP INDEX [NCI_TEST] ON [dbo].[FilteredNCCI]
GO

-- Create NCCI





CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Filtered ON dbo.FilteredNCCI
(
OrderID, Quantity, SalesPersonID, CustomerPersonID, ItemID, DateOfSale, payed
)
where dateofsale < '2016-10-10'
GO

--- Check the segments

select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='FilteredNCCI'
select * from sys.partitions where object_name(object_id) = 'FilteredNCCI'

--- Update a value

UPDATE dbo.FilteredNCCI
SET dateofsale = '2016-09-09'
where OrderID = (select top 1 orderID from dbo.FilteredNCCI where dateofsale > '2016-10-10')

--- Check the segments

select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='FilteredNCCI'
select * from sys.partitions where object_name(object_id) = 'FilteredNCCI'
GO

--- Invoke Tuple Mover
ALTER INDEX NCCI_Filtered ON dbo.FilteredNCCI REORGANIZE

--- Check the segments

select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='FilteredNCCI'
select * from sys.partitions where object_name(object_id) = 'FilteredNCCI'
GO

--- Insert a value

insert into dbo.FilteredNCCI
select 20, 5, 3, 4, '2016-09-09 00:00:00.000', 1

--- Check the segments

select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='FilteredNCCI'
select * from sys.partitions where object_name(object_id) = 'FilteredNCCI'
GO

--- What happens if we select data

select * from dbo.FilteredNCCI

--- What happens if we select data from the filtered part

select * from dbo.FilteredNCCI where dateofsale < '2016-10-10'

--- What happens if we make a more complex query
declare @d date = dateadd(month,-22,getdate())

select SUM(Quantity), avg(quantity),sum(quantity*itemPrice),year(DateOfSale) from dbo.FilteredNCCI	f --with(INDEX  (NCCI_Filtered))
inner join ssd.item i on i.itemID = f.itemID 
where dateofsale > @d 
group by year(DateOfSale)
having sum(Quantity) > 20000
option(recompile)

--- What happens if we create an index on the other part

DROP INDEX IF EXISTS NCI_TEST2  ON dbo.FilteredNCCI
GO
CREATE NONCLUSTERED INDEX NCI_TEST2
ON [dbo].[FilteredNCCI] ([ItemID],dateofsale)
INCLUDE ([Quantity],[payed])
where dateofsale >= '2016-10-10'


--- What happens if we make a more complex query
declare @d date = dateadd(month,-22,getdate())

select SUM(Quantity), avg(quantity),sum(quantity*itemPrice),year(DateOfSale) from dbo.FilteredNCCI	f --with(INDEX  (NCCI_Filtered))
inner join ssd.item i on i.itemID = f.itemID 
where dateofsale > @d 
group by year(DateOfSale)
having sum(Quantity) > 20000

option(recompile)