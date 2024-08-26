/* Thank you to Daniel Messer. This 
query pulls a list of SQL jobs set up in SQL Server along with all the information connected to them
like frequency, start time, end time, intervals and so on.
It’s particularly useful if you need to back up, clone, or reset a database system.*/

SELECT 
    j.name AS [Job Name],
    s.name AS [Schedule Name,
    s.enabled AS [ScheduleEnabled],
    s.freq_type AS [Frequency Type],
    s.freq_interval AS [Frequency Interval],
    s.freq_subday_type AS [Subday Type],
    s.freq_subday_interval AS [Subday Interval],
    s.freq_relative_interval AS [Relative Interval],
    s.freq_recurrence_factor AS [Recurrence Factor],
    s.active_start_date AS [Active Start Date],
    s.active_end_date AS [Active End Date],
    RIGHT('0' + CAST(s.active_start_time / 10000 AS VARCHAR(2)), 2) + ':' + 
    RIGHT('0' + CAST((s.active_start_time / 100) % 100 AS VARCHAR(2)), 2) + ':' + 
    RIGHT('0' + CAST(s.active_start_time % 100 AS VARCHAR(2)), 2) AS ActiveStartTime,
    RIGHT('0' + CAST(s.active_end_time / 10000 AS VARCHAR(2)), 2) + ':' + 
    RIGHT('0' + CAST((s.active_end_time / 100) % 100 AS VARCHAR(2)), 2) + ':' + 
    RIGHT('0' + CAST(s.active_end_time % 100 AS VARCHAR(2)), 2) AS ActiveEndTime,
    CASE 
        WHEN s.freq_type = 1 THEN 'One Time'
        WHEN s.freq_type = 4 THEN 'Daily'
        WHEN s.freq_type = 8 THEN 'Weekly'
        WHEN s.freq_type = 16 THEN 'Monthly'
        WHEN s.freq_type = 32 THEN 'Monthly, relative to frequency'
        WHEN s.freq_type = 64 THEN 'When SQL Server Agent starts'
        WHEN s.freq_type = 128 THEN 'When the computer is idle'
        ELSE 'Unknown'
    END AS FrequencyDescription
FROM 
    msdb.dbo.sysjobs j
INNER JOIN 
    msdb.dbo.sysjobschedules js
    ON (j.job_id = js.job_id)
INNER JOIN 
    msdb.dbo.sysschedules s
    ON (js.schedule_id = s.schedule_id)
ORDER BY 
    j.name,
    s.name;
