--cteate the "DataWarehouse' DB
use master;
 
GO

CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;

GO
CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
