/* Setting up logins for SQL Database */

/* View databases - from master */
SELECT *
FROM sys.databases; 

/* View server logins - from master */ 
SELECT * 
FROM sys.sql_logins; 

/* Create a new user - connect to v12test as CNCY */
CREATE USER AppLogin WITH PASSWORD = 'Azur3!sGr3at'; 

/* View database logins - connect to v12test as CNCY */
SELECT *
FROM sys.database_principals; 

/* Connect to v12test as AppLogin 
File > New > Database Engine Query 
Enter username, password. 
Click Options 
On Connection Properties, enter v12test 
Click Connect */ 

/* Try to create table */ 
/* Come back here */
EXEC sp_addrolemember 'db_ddladmin', 'AppLogin';
/* Try to create table again */

/* Create a server-level login */ 
CREATE LOGIN ServerLogin WITH PASSWORD = 'Azur3!sGr3at'; --Will have to create new connection to master 
/* Tie that to database user */ 
CREATE USER ServerUser FROM LOGIN ServerLogin; 
EXEC sp_addrolemember 'ServerUser', 'db_owner';

/* Clean up! */

/* Connect to v12test as CNCY */
DROP USER ServerUser; 
GO 

DROP USER AppLogin; 
GO

/* Connect to master */ 
DROP LOGIN ServerLogin; 
