Declare @Job_name nvarchar(max), @recipients_mail nvarchar(max), @profil nvarchar(max)
set @Job_name = ''
set @recipients_mail = ''
set @profil = ''

if exists ( select j.name, js.step_name, jh.message FROM msdb.dbo.sysjobs AS j
			INNER JOIN msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
			INNER JOIN msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id AND jh.step_id = js.step_id
			WHERE jh.run_status = 0
			and jh.run_date=convert(int,replace(convert(date,getdate()),'-',''))
			and (j.name<>@Job_name
			or (j.name=@Job_name and STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(jh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') >'08:00:00'))
			)
begin

DECLARE @tableHTML  NVARCHAR(MAX) ;  
  
SET @tableHTML =  
    N'<H3>Jobs Failed</H3>' +  
    N'<table border="1">' +  
    N'<tr><th>Job_Name</th>' +
	N'<th>Step_Name</th>' +
	N'<th>Error message</th>' +
    CAST ( ( select td = j.name,		'',
					td = js.step_name,	'',
					td = jh.message,	''
					FROM msdb.dbo.sysjobs AS j
					INNER JOIN msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
					INNER JOIN msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id AND jh.step_id = js.step_id
					WHERE jh.run_status = 0
					and jh.run_date=convert(int,replace(convert(date,getdate()),'-',''))
					and (j.name<>@Job_name
					or (j.name=@Job_name 
						and STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(jh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') >'08:00:00')) 
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  

------------------------------------------------------------------------------------------------------------mail
			USE msdb
			EXEC sp_send_dbmail 
			@profile_name=@profil
			,@recipients=@recipients_mail
			,@subject='Jobs Fail'
			,@body = @tableHTML  
			,@body_format = 'HTML' ;  
end