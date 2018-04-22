-- 
-- Author: Matticusau
-- Purpose: Provides a summary of automatic seeding tasks in last 24 hours
-- Source: https://github.com/Microsoft/DataInsightsAsia/blob/Dev/Scripts/AlwaysOn/AutomaticSeeding.sql
-- License: https://github.com/Matticusau/sqlops-alwayson-insights/blob/master/LICENSE
-- 
SELECT 
autos.current_state
, COUNT(autos.current_state) [count]
FROM sys.dm_hadr_automatic_seeding autos 
    JOIN sys.availability_databases_cluster db 
        ON autos.ag_db_id = db.group_database_id
    JOIN sys.availability_groups ag 
        ON autos.ag_id = ag.group_id
WHERE [start_time] >= DATEADD(day, -1, GETDATE())
GROUP BY CONVERT(DATE, autos.start_time)
    , ag.name
    , db.database_name
    , autos.current_state
