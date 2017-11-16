
--- Check the distinct products we have since last test
select distinct c1_product from testtuple
go


--- Check the dictionary
select object_name(p.object_id),c.name , d.* from sys.column_store_dictionaries d
inner join sys.partitions p on p.partition_id = d.partition_id 
inner join sys.columns c on c.column_id = d.column_id and c.object_id = p.object_id
where object_name(p.object_id) = 'Testtuple'
GO

--- Recreate the table
drop table IF EXISTS testtuple

---Create a test table
Create table TestTuple
(
c1_ID  varchar(200) null,
c1_Product varchar(100) null
)

---Create the nonclustered columnstore index

create nonclustered columnstore index ix_test on testtuple
(
c1_ID, c1_Product
)

GO

---Insert all unique values into product field

insert into dbo.testtuple
select TheID, product +'  '+ cast(TheID as varchar)
from dbo.testdata
where TheID <= 1048577

GO

--- reorganize to trigger segment creation
ALTER INDEX ix_test on dbo.testtuple REORGANIZE
GO
--Check the segment
select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

GO

-- check the dictionaries created
select object_name(p.object_id),c.name , d.* from sys.column_store_dictionaries d
inner join sys.partitions p on p.partition_id = d.partition_id 
inner join sys.columns c on c.column_id = d.column_id and c.object_id = p.object_id
where object_name(p.object_id) = 'Testtuple'

GO

-- check why the rowgroups have trimmed
select trim_reason_desc,* from sys.dm_db_column_store_row_group_physical_stats where object_name(object_id) = 'Testtuple'