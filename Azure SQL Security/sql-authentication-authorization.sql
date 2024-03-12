-- in master 
CREATE LOGIN commerceadmin WITH PASSWORD = '<password>'; 
-- SQL Database roles - https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=azuresqldb-current&preserve-view=true#special-roles-for--and-azure-synapse 
ALTER SERVER ROLE ##MS_DatabaseManager## ADD MEMBER commerceadmin; 
ALTER SERVER ROLE ##MS_DatabaseConnector## ADD MEMBER commerceadmin; 

-- comm-usa 
CREATE USER greenblue WITH PASSWORD = '<password>';
GRANT EXECUTE ON SCHEMA::dbo TO greenblue;

-- comm-can 
CREATE USER redwhite WITH PASSWORD = '<password>';
GRANT EXECUTE ON SCHEMA::dbo TO redwhite;

-- comm-mex 
CREATE USER bluered WITH PASSWORD = '<password>';
GRANT EXECUTE ON SCHEMA::dbo TO bluered;