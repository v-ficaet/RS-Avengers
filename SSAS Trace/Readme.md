# How to Run
1. Open SQL Management Studio (SSMS.exe) as an Administrator
	- *You  might recieve an permission error on the nexts steps if the SSMS is not run as administrator*
	
2. On SSMS: Connect to Server> Select "Server Type"> "Analysis Services”
		
    `Server Name: localhost:5132` 
    
3. Open and edit the script XMLA file:
		
    `Start_Trace.XMLA`
		
4. Change the “LogFileName” line to a available driver and folder on your machine

    `example: "C:\Temp"`

5. Run all the code by Pressing F5
	- *if it prompts for a server, make sure to follow the step 2*
	
6. Dont close the SSMS yet. Make sure that the issue is reproduced

7. After the issue is reproduced, run the following file to stop the trace
		
    `Stop_Trace.XMLA`
		
8. Send the .TRC file generated and the latest logs *(compress whole directory)*
	
    `Generally located on: <PBI Installation Folder>\PIBRS\LogFiles\`
   
		
9. Please provide the aproximated timestamp when the issue occured



# Usefull information to customize the code 
| Parameter       | Information                                                                                               |
|-----------------|-----------------------------------------------------------------------------------------------------------|
| LogFileAppend   | 0 for Overwrite, 1 for Appending multiple files.                                                                            |
| AutoRestart     | 0 for No, 1 to restart when the server restarts.                                                          |
| LogFileSize     | Size in MB.  The log will roll over when it reaches this size.                                            |
| LogFileRollover | 1 means create a new log file. 0 (false) it will stop the trace after max file is reached
