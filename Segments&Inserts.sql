--drop existing table

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

-- BATCH INSERT 102400 rows USE BCP

-- Use windows powershell command 

-- C:\CSV\CSVInsert.bat | Out-Null

--Check the segment
select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Row Insert
GO
INSERT INTO dbo.TestTuple
select ProductID,Product from dbo.TestData where TheId <= 1048576


--Check the segment
select r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Insert 1 extra Row

insert into TestTuple (c1_ID,c1_Product)
values(1, 'Productje')

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

--Invoke tuple mover by Reorganize

ALTER INDEX ix_test on dbo.testtuple REORGANIZE


--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Force the one row

ALTER INDEX ix_test on dbo.testtuple REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON)


select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- get row into smaller segment

ALTER INDEX ix_test on dbo.testtuple REORGANIZE 

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

GO

--- WHAT HAPPENS WITH CLUSTERED COLUMNSTORE INDEXES


drop table IF EXISTS testtuple

---Create a test table
Create table TestTuple
(
c1_ID  varchar(200) null,
c1_Product varchar(100) null
)

---Create the clustered columnstore index

create CLUSTERED columnstore index ix_test on testtuple



-- BATCH INSERT 102400 rows USE BCP

-- Use windows powershell command 

-- C:\CSV\CSVInsert.bat | Out-Null

--Check the segment
select t.name,r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Row Insert
GO

insert into dbo.TestTuple
select productID, Product from dbo.TestData where TheId <= 100000
GO 10
insert into dbo.TestTUple
select productID,Product from dbo.TestData where TheId <= 48576


--Check the segment
select r.*
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Insert 1 extra Row

insert into TestTuple (c1_ID,c1_Product)
values(1, 'Productje')

--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

--Invoke tuple mover by Reorganize

ALTER INDEX ix_test on dbo.testtuple REORGANIZE


--Check the segment
select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- Force the one row

ALTER INDEX ix_test on dbo.testtuple REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON)


select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'

-- get row into smaller segment

ALTER INDEX ix_test on dbo.testtuple REORGANIZE 

select *
	from sys.column_store_row_groups r
	INNER JOIN sys.tables t on t.Object_ID = r.Object_ID where t.name ='TestTuple'
