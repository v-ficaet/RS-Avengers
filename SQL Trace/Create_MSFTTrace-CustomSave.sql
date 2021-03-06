/*=================== README ======================================================================================
Running the entire script will start the trace. SysAdmin permission on the SQL Server is required
Adjust the step 2 to an existing directory/folder that needs to exists inside the target SQL SERVER
STEP 5: Run this step manually as code is commented. Make sure to only select that T-SQL statement to end the trace
==================================================================================================================*/
USE master;
GO
/** 1. Cleanup **/ 
IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='_MSFTTrace')  
    DROP EVENT SESSION [_MSFTTrace] ON SERVER;  
GO
/** 2. Directory needs to exists on the targeted SERVER. Important: Close the path with fowardslash '\' **/
DECLARE 
@DIR NVARCHAR(255) = 'C:\ms\',
@sql NVARCHAR(MAX);
 
/** 3. Create the Extended Events Trace **/
SET @sql = '
CREATE EVENT SESSION [_MSFTTrace] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([opcode]=1 AND [duration]>10000 AND (([wait_type]>31 AND [wait_type]<38) OR ([wait_type]>47 AND [wait_type]<54) OR ([wait_type]>63 AND [wait_type]<70) OR ([wait_type]>96 AND [wait_type]<100) OR ([wait_type]=107) OR ([wait_type]=113) OR ([wait_type]>174 AND [wait_type]<179) OR ([wait_type]=178) OR ([wait_type]=186) OR ([wait_type]=207) OR ([wait_type]=269) OR ([wait_type]=283) OR ([wait_type]=284) OR ([duration]>15000 AND [wait_type]<22)))),
ADD EVENT sqlserver.attention(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
    WHERE ([sqlserver].[is_system]=(0))),
ADD EVENT sqlserver.blocked_process_report(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)),
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
    WHERE ([severity]>(10))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)),
ADD EVENT sqlserver.sp_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.username)),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'''+ @DIR + '_MSFTTrace.xel'',max_file_size=(2048),max_rollover_files=(5))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=3 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)'
EXECUTE (@sql)
GO
 
/** 4. Start the xEvent Trace **/
ALTER EVENT SESSION [_MSFTTrace] ON SERVER  
STATE = START;
 
/** 5. Stop the trace & Remove xEvent from Server. Please select only THE SINGLE LINE BELLOW  **
DROP EVENT SESSION [_MSFTTrace] ON SERVER;
											                                                  **/

/** 6. Share the created trace file (.xel) **/
