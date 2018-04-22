-- 
-- Author: Matticusau
-- Purpose: Provides a report on automatic seeding tasks
-- Source: https://github.com/Microsoft/DataInsightsAsia/blob/Dev/Scripts/AlwaysOn/AutomaticSeeding.sql
-- License: https://github.com/Matticusau/sqlops-alwayson-insights/blob/master/LICENSE
-- 
SELECT start_time,
    ag.name,
    db.database_name,
    current_state,
    performed_seeding,
    failure_state,
    failure_state_desc
FROM sys.dm_hadr_automatic_seeding autos 
    JOIN sys.availability_databases_cluster db 
        ON autos.ag_db_id = db.group_database_id
    JOIN sys.availability_groups ag 
        ON autos.ag_id = ag.group_id
WHERE [start_time] >= DATEADD(day, -1, GETDATE())
ORDER BY [start_time]