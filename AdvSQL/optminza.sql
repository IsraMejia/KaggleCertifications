
WITH 
    LocationsAndOwners AS (
        SELECT * 
        FROM CostumeOwners co 
            INNER JOIN CostumeLocations cl
            ON co.CostumeID = cl.CostumeID
    ),
    LastSeen AS (
        SELECT CostumeID, MAX(Timestamp)
        FROM LocationsAndOwners
        GROUP BY CostumeID
    )

SELECT lo.CostumeID, Location 
FROM LocationsAndOwners lo 
    INNER JOIN LastSeen ls 
        ON lo.Timestamp = ls.Timestamp 
            AND lo.CostumeID = ls.CostumeID
WHERE OwnerID = MitzieOwnerID










































--Query optimizada

WITH 
    CurrentOwnersCostumes AS (
        SELECT CostumeID 
        FROM CostumeOwners 
        WHERE OwnerID = MitzieOwnerID
    ),
    OwnersCostumesLocations AS(
        SELECT cc.CostumeID, Timestamp, Location 
        FROM CurrentOwnersCostumes cc 
            INNER JOIN CostumeLocations cl
                ON cc.CostumeID = cl.CostumeID
    ),
    LastSeen AS (
    SELECT CostumeID, MAX(Timestamp)
    FROM OwnersCostumesLocations
    GROUP BY CostumeID
    )

SELECT ocl.CostumeID, Location 
FROM OwnersCostumesLocations ocl 
    INNER JOIN LastSeen ls 
        ON ocl.timestamp = ls.timestamp 
        AND ocl.CostumeID = ls.costumeID