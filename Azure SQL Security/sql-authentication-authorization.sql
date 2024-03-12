-- in master 
<<<<<<< HEAD
CREATE LOGIN commerceadmin WITH PASSWORD = '<password>'; 
=======
CREATE LOGIN commerceadmin WITH PASSWORD = 'P@ssw0rd456&*'; 
>>>>>>> fc1dbc1dbf2ce811aaa99096c921063ccad3e310
-- SQL Database roles - https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=azuresqldb-current&preserve-view=true#special-roles-for--and-azure-synapse 
ALTER SERVER ROLE ##MS_DatabaseManager## ADD MEMBER commerceadmin; 
ALTER SERVER ROLE ##MS_DatabaseConnector## ADD MEMBER commerceadmin; 

-- comm-usa 
<<<<<<< HEAD
CREATE USER greenblue WITH PASSWORD = '<password>';
GRANT EXECUTE ON SCHEMA::dbo TO greenblue;

-- comm-can 
CREATE USER redwhite WITH PASSWORD = '<password>';
GRANT EXECUTE ON SCHEMA::dbo TO redwhite;

-- comm-mex 
CREATE USER bluered WITH PASSWORD = '<password>';
=======
CREATE USER greenblue WITH PASSWORD = 'P@ssw0rd456&*';
GRANT EXECUTE ON SCHEMA::dbo TO greenblue;

-- comm-can 
CREATE USER redwhite WITH PASSWORD = 'P@ssw0rd456&*';
GRANT EXECUTE ON SCHEMA::dbo TO redwhite;

-- comm-mex 
CREATE USER bluered WITH PASSWORD = 'P@ssw0rd456&*';
>>>>>>> fc1dbc1dbf2ce811aaa99096c921063ccad3e310
GRANT EXECUTE ON SCHEMA::dbo TO bluered;