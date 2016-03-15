/* DMVs in Azure SQL Database */ 

/* Connections */
SELECT *
FROM sys.dm_exec_connections; 



/* Wait stats */ 
--System 
SELECT *
FROM sys.dm_os_wait_stats; 

--Your database 
SELECT *
FROM sys.dm_db_wait_stats; 



/* Virtual IO File Stats */ 
SELECT *  
FROM sys.dm_io_virtual_file_stats(DB_ID('v12test'), NULL) AS divfs 



/* Plan cache */
SELECT TOP (10) 
	SUBSTRING(ST.text, ( QS.statement_start_offset / 2 ) + 1,
		( ( CASE statement_end_offset
		WHEN -1 THEN DATALENGTH(st.text)
		ELSE QS.statement_end_offset
		END - QS.statement_start_offset ) / 2 ) + 1) AS statement_text ,
	execution_count ,
	total_worker_time / 1000 AS total_worker_time_ms ,
	( total_worker_time / 1000 ) / execution_count AS avg_worker_time_ms ,
	total_logical_reads ,
	total_logical_reads / execution_count AS avg_logical_reads ,
	total_elapsed_time / 1000 AS total_elapsed_time_ms ,
	( total_elapsed_time / 1000 ) / execution_count AS avg_elapsed_time_ms ,
	qs.creation_time, 
	qs.last_execution_time,
	DATEDIFF(hh, qs.creation_time, qs.last_execution_time) AS hours_in_cache,
	qp.query_plan, 
	qs.plan_handle 
FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY 
	total_worker_time DESC  
	--total_logical_reads DESC 
	--total_elapsed_time_ms DESC 
	--execution_count DESC