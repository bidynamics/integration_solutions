
--Code to Create a SQL Server Database
USE [master];
GO
CREATE DATABASE [CentralLogging]
ON PRIMARY
(
NAME = N'CentralLogging'
, FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\
CentralLogging.mdf'
, SIZE = 1024MB
, MAXSIZE = UNLIMITED
, FILEGROWTH = 1024MB
)
LOG ON
(
NAME = N'CentralLogging_log'
, FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\
CentralLogging_log.ldf'
, SIZE = 256MB
, MAXSIZE = UNLIMITED
, FILEGROWTH = 256MB
);
GO




--Code to Create a Table for Monitoring SQL Server Instances
USE CentralLogging;
GO
CREATE TABLE dbo.dba_monitor_SQLServerInstances
(
SQLServerInstance NVARCHAR(128)
, LastMonitored SMALLDATETIME NULL
CONSTRAINT PK_dba_monitor_SQLServerInstances
PRIMARY KEY CLUSTERED( SQLServerInstance )
);


--Code to Insert Data into the dba_monitor_SQLServerInstances Table
INSERT INTO dbo.dba_monitor_SQLServerInstances
(
SQLServerInstance
)
SELECT @@SERVERNAME-- The name of the server that hosts the central repository
UNION ALL
SELECT 'YourSQLServerInstanceHere'-- Example of a SQL Server instance
UNION ALL
SELECT 'YourSQLServerInstance\Here';-- Example of a server with multiple instances

--Code to Create a Table to Store Data and Log File Size Information
USE CentralLogging;
GO
CREATE TABLE dbo.dba_monitor_databaseGrowth
(
log_id INT IDENTITY(1,1)
, captureDate DATETIME
, serverName NVARCHAR(128)
, databaseName SYSNAME
, dataSizeInKB BIGINT
, logSizeInKB BIGINT
CONSTRAINT PK_dba_monitor_databaseGrowth
PRIMARY KEY NONCLUSTERED(log_id)
);
CREATE CLUSTERED INDEX CIX_dba_monitor_databaseGrowth
ON dbo.dba_monitor_databaseGrowth(captureDate,serverName,databaseName);


--Code to Create the dba_monitor_unusedIndexes Table
USE CentralLogging;
GO
CREATE TABLE dbo.dba_monitor_unusedIndexes
(
log_id INT IDENTITY(1,1)
,captureDate DATETIME
,serverName NVARCHAR(128)
,schemaName SYSNAME
,databaseName SYSNAME
,tableName SYSNAME
,indexName SYSNAME
,indexType NVARCHAR(60)
,isFiltered BIT
,isPartitioned BIT
,numberOfRows BIGINT
,userSeeksSinceReboot BIGINT
,userScansSinceReboot BIGINT
,userLookupsSinceReboot BIGINT
,userUpdatesSinceReboot BIGINT
,indexSizeInMB BIGINT
,lastReboot DATETIME
CONSTRAINT PK_dba_monitor_unusedIndexes
PRIMARY KEY NONCLUSTERED(log_id)
);
CREATE CLUSTERED INDEX CIX_dba_monitor_unusedIndexes
ON dbo.dba_monitor_unusedIndexes(captureDate);














