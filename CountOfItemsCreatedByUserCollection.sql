-- Thanks to Daniel Messer

-- Create a table to hold onto the items created as a cross reference for
-- items deleted in the same period
CREATE TABLE #TempItemsCreated (
    TransactionID INT,
    PolarisUserID INT,
    ItemRecordID INT
);

-- Create a table to hold on to items deleted that were created during the
-- same period
CREATE TABLE #TempItemsDeleted (
    TransactionID INT,
    PolarisUserID INT,
    ItemRecordID INT,
    AssignedBranchID INT,
    AssignedCollectionID INT
);

-- Create a table to populate for data delivery
CREATE TABLE #TempDataDelivery (
    Library NVARCHAR(50),
    PolarisUser NVARCHAR(50),
    Collection NVARCHAR(80)
)

/* ------------------------------------------------------------------------------ */

-- Populate #TempItemsCreated with items created during this period
INSERT INTO #TempItemsCreated

SELECT
    th.TransactionID,
    th.PolarisUserID,
    item.numValue
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Get the ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails item WITH (NOLOCK)
    ON (th.TransactionID = item.TransactionID AND item.TransactionSubTypeID = 38)
WHERE -- Items created
    th.TransactionTypeID = 3008
AND -- Do not include items created by PolarisExec (typically eliminates eContent)
    PolarisUserID != 1
AND -- Adjust dates as needed
    th.TranClientDate BETWEEN '2023-07-01 00:00:00.000' AND '2024-06-30 23:59:59.999';

-- Debug
--SELECT * FROM #TempItemsCreated;

/* ------------------------------------------------------------------------------ */

-- Populate #TempItemsDeleted using #TempItemsCreated as a cross-reference
INSERT INTO #TempItemsDeleted

SELECT
    th.TransactionID,
    tic.PolarisUserID,
    item.numValue,
    abranch.numValue,
    acoll.numValue
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pull the ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails item WITH (NOLOCK)
    ON (th.TransactionID = item.TransactionID AND item.TransactionSubTypeID = 38)
INNER JOIN -- Pull the AssignedBranchID
    PolarisTransactions.Polaris.TransactionDetails abranch WITH (NOLOCK)
    ON (th.TransactionID = abranch.TransactionID AND abranch.TransactionSubTypeID = 58)
INNER JOIN -- Pull the CollectionID
    PolarisTransactions.Polaris.TransactionDetails acoll WITH (NOLOCK)
    ON (th.TransactionID = acoll.TransactionID AND acoll.TransactionSubTypeID = 61)
INNER JOIN -- Add in the PolarisUserID who originally created the item
    #TempItemsCreated tic
    ON (tic.ItemRecordID = item.numValue)
WHERE -- Item deleted
    th.TransactionTypeID = 3007
AND -- Use the #TempItemsCreated to pull in ItemRecordIDs as the basis for this query
    item.numValue IN (
        SELECT ItemRecordID
        FROM #TempItemsCreated
    );

-- Debug
-- SELECT * FROM #TempItemsDeleted;

/* ------------------------------------------------------------------------------ */

-- Populate #TempDataDelivery from the other two temp tables
INSERT INTO #TempDataDelivery

SELECT
    o.Name,
    pu.Name,
    c.Name
FROM -- Get items from #TempItemsCreated
    #TempItemsCreated tic
INNER JOIN -- Bring in existing ItemRecordIDs
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
    ON (cir.ItemRecordID = tic.ItemRecordID)
LEFT JOIN -- Get Collection name
    Polaris.Polaris.Collections c WITH (NOLOCK)
    ON (c.CollectionID = cir.AssignedCollectionID)
INNER JOIN -- Get Polaris username
    Polaris.Polaris.PolarisUsers pu WITH (NOLOCK)
    ON (pu.PolarisUserID = tic.PolarisUserID)
INNER JOIN -- Get the Assigned Branch
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = cir.AssignedBranchID)
WHERE -- Exclude deleted items as they won't be in CircItemRecords
    tic.ItemRecordID NOT IN (
        SELECT ItemRecordID
        FROM #TempItemsDeleted
    );

-- Populate #TempDataDelivery with items created and then deleted during
-- this time period
INSERT INTO #TempDataDelivery

SELECT
    o.Name,
    pu.Name,
    c.Name
FROM
    #TempItemsDeleted tid
INNER JOIN -- Get the Assigned Branch
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = tid.AssignedBranchID)
INNER JOIN -- Bring in the Polaris username
    Polaris.Polaris.PolarisUsers pu WITH (NOLOCK)
    ON (pu.PolarisUserID = tid.PolarisUserID)
LEFT JOIN -- Get the Collection name
    Polaris.Polaris.Collections c WITH (NOLOCK)
    ON (c.CollectionID = tid.AssignedCollectionID);

/* ---------- DATA DELIVERY ---------- */

SELECT
    Library AS [Branch/Library],
    PolarisUser AS [Polaris User],
    Collection AS [Collection],
    COUNT(*) AS [Items Created]
FROM
    #TempDataDelivery
GROUP BY
    Library,
    PolarisUser,
    Collection
ORDER BY
    Library,
    PolarisUser,
    Collection


-- Tidy up
DROP TABLE #TempItemsCreated;
DROP TABLE #TempItemsDeleted;
DROP TABLE #TempDataDelivery;