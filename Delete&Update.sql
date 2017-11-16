
---drop existing table

drop table IF EXISTS testtuple

---Create a test table
Create table TestTuple
(
c1_ID  int null,
c1_Product varchar(100) null
)

create nonclustered columnstore index ix_test on testtuple
(
c1_ID, c1_Product
)

INSERT INTO dbo.TestTuple
select ProductID,Product from dbo.TestData where TheId <= 1048578

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'


ALTER INDEX ix_test on dbo.TestTuple REORGANIZE
--Check the data

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

---Delete data from table

delete from testtuple
where c1_id < 299999

---Select data where id < 40000

select * from testtuple where c1_id <299999


---- ARE THEY DELETED?

--- Check the columnstore row groups
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

--Check the Internal partitions
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'




---Update data where id 

update testtuple
set [c1_Product] = 'ProductjeV3'
where c1_id > 300000 

---rerun dmv the tuple move

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'
GO

-- Reorganize the index
ALTER INDEX ix_test on dbo.testtuple REORGANIZE

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

-- Reorganize the index
ALTER INDEX ix_test on dbo.testtuple REORGANIZE

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

---Select updated data

select * from testtuple where c1_id > 300000 
---Update data where id 

update testtuple
set [c1_Product] = 'ProductjeV4'

---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

-- Tuple Move

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'


--RUN IT AGAIN

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

--RUN IT AGAIN

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

--Use the compress all row groups

ALTER INDEX ix_test on dbo.testTuple REORGANIZE with(COMPRESS_ALL_ROW_GROUPS = ON)
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'



---CLUSTERED COLUMNSTORE


---drop existing table

drop table IF EXISTS testtuple

---Create a test table
Create table TestTuple
(
c1_ID  int null,
c1_Product varchar(100) null
)

create CLUSTERED columnstore index ix_test on testtuple


INSERT INTO dbo.TestTuple
select ProductID,Product from dbo.TestData where TheId <= 1048578

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'


ALTER INDEX ix_test on dbo.TestTuple REORGANIZE
--Check the data

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

---Delete data from table

delete from testtuple
where c1_id < 299999

---Select data where id < 40000

select * from testtuple where c1_id <299999


---- ARE THEY DELETED?

--Check the segment
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'


--INVOKE TUPLE MOVE
ALTER INDEX ix_test on dbo.testTuple REORGANIZE


--Check the segment
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

---Update data where id 

update testtuple
set [c1_Product] = 'ProductjeV3'
where c1_id > 300000 

---rerun dmv the tuple move

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

---Select updated data

select * from testtuple where c1_id > 300000 
---Update data where id 

update testtuple
set [c1_Product] = 'ProductjeV4'

---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'

-- Tuple Move

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'


--RUN IT AGAIN

ALTER INDEX ix_test on dbo.testTuple REORGANIZE
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'


--Use the compress all row groups

ALTER INDEX ix_test on dbo.testTuple REORGANIZE with(COMPRESS_ALL_ROW_GROUPS = ON)
	
---rerun dmv the tuple move

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
select * from sys.internal_partitions where OBJECT_NAME(object_id)= 'TestTuple'