/* Using Extended Events in SQL Database */

/* Find events, actions, targets  */
SELECT o.object_type,
        p.name AS [package_name],
        o.name AS [db_object_name],
        o.description AS [db_obj_description]
    FROM sys.dm_xe_objects  AS o 
        INNER JOIN sys.dm_xe_packages AS p ON p.guid = o.package_guid
    WHERE o.object_type in
            ('action',  'event',  'target')
    ORDER BY o.object_type,
        p.name,
        o.name;

/* CREATE EVENT SESSION <name> ON DATABASE */

CREATE EVENT SESSION [Track sql_statement_completed] ON DATABASE 
ADD EVENT sqlserver.sql_statement_completed(SET collect_parameterized_plan_handle=(1),collect_statement=(1)
    ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[database_name]=N'v12test'))
ADD TARGET package0.event_file(SET filename=N'https://xestorageaccount.blob.core.windows.net/xecontainer/Track_sql_statement_completed_2015_12_30.xel')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

/* Start */
ALTER EVENT SESSION [Track sql_statement_completed] ON DATABASE 
STATE = START; 

/* Stop */
ALTER EVENT SESSION [Track sql_statement_completed] ON DATABASE 
STATE = STOP; 

/* Drop */
DROP EVENT SESSION [Track sql_statement_completed] ON DATABASE; 