-- 
-- Author: Matticusau
-- Purpose: Provides percentage of Connected Replicas
--          Experimental script for building a count insight
-- License: https://github.com/Matticusau/sqlops-widgets/blob/master/LICENSE
-- 
DECLARE @totalReplicaCnt INT = (
    SELECT Count(connected_state_desc)
    FROM sys.availability_groups ag
    INNER JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id = ag.group_id
    INNER JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
)
--SELECT @totalReplicaCnt
DECLARE @disconnectedReplicaCnt INT = (
    SELECT Count(connected_state_desc)
    FROM sys.availability_groups ag
    INNER JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id = ag.group_id
    INNER JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
    WHERE ars.connected_state_desc <> 'CONNECTED'
)
DECLARE @disconnectedReplicaPct DECIMAL(5,2) = (
SELECT CONVERT( DECIMAL(5,2), ((@disconnectedReplicaCnt * 1.0 / @totalReplicaCnt) * 100))
)
if (@disconnectedReplicaPct = 0) SET @disconnectedReplicaPct = 100;
SELECT @disconnectedReplicaPct [replica_percent]