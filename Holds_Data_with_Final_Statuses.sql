-- Thanks to Daniel Messer 

/* -------------------- C R E A T E   T E M P   T A B L E S -------------------- */

-- Create a table to hold onto the request data
CREATE TABLE #TempHoldsData (
    TransactionID INT,
    HoldRequestID INT,
    HoldPlaced DATETIME,
    PatronBarcode NVARCHAR(20),
    PatronBranch NVARCHAR(15),
    PatronFullName NVARCHAR(100),
    BrowseTitle NVARCHAR(255),
    BrowseAuthor NVARCHAR(255),
    ItemBarcode NVARCHAR(20),
    MaterialType NVARCHAR(80),
    ItemCall NVARCHAR(255),
    ShelfLocation NVARCHAR(80),
    PickupBranch NVARCHAR(15),
    FinalHoldStatus NVARCHAR(100),
    FinalHoldStatusDate DATETIME
);

-- Create a table to keep track of all the events of these holds
CREATE TABLE #HoldEvents (
    TransactionID INT,
    HoldRequestID INT,
    ItemRecordID INT,
    ItemBarcode NVARCHAR(20),
    MaterialType NVARCHAR(80),
    ShelfLocation NVARCHAR(80),
    ItemCall NVARCHAR(255),
    TransactionTypeID INT,
    TransactionTypeDescription NVARCHAR(100),
    TranClientDate DATETIME
);

/* -------------------- P O P U L A T E   T E M P   T A B L E S -------------------- */

-- Initial population of the temp holds data table
INSERT INTO #TempHoldsData

SELECT
    th.TransactionID,
    holdreq.numValue,
    th.TranClientDate,
    p.Barcode,
    pbranch.Abbreviation,
    pr.PatronFullName,
    br.BrowseTitle,
    br.BrowseAuthor,
    0, -- Will be updated later
    0, -- Will be updated later
    0, -- Will be updated later
    0, -- Will be updated later
    pickup.Abbreviation,
    0, -- Will be updated later
    '1900-01-01 00:00:00.000' -- A default date in the far past to indicate no date at all
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls SysHoldRequestID
    PolarisTransactions.Polaris.TransactionDetails holdreq WITH (NOLOCK)
    ON (th.TransactionID = holdreq.TransactionID AND holdreq.TransactionSubTypeID = 233)
INNER JOIN -- Pulls PatronID
    PolarisTransactions.Polaris.TransactionDetails patron WITH (NOLOCK)
    ON (th.TransactionID = patron.TransactionID AND patron.TransactionSubTypeID = 6)
INNER JOIN -- Pulls BibliographicRecordID
    PolarisTransactions.Polaris.TransactionDetails bibrecord WITH (NOLOCK)
    ON (th.TransactionID = bibrecord.TransactionID AND bibrecord.TransactionSubTypeID = 36)
INNER JOIN -- Pulls Pickup Branch
    PolarisTransactions.Polaris.TransactionDetails pickupbranch WITH (NOLOCK)
    ON (th.TransactionID = pickupbranch.TransactionID AND pickupbranch.TransactionSubTypeID = 123)
INNER JOIN -- Bring in Patrons table
    Polaris.Polaris.Patrons p WITH (NOLOCK)
    ON (p.PatronID = patron.numValue)
INNER JOIN -- Bring in the PatronRegistration table
    Polaris.Polaris.PatronRegistration pr WITH (NOLOCK)
    ON (pr.PatronID = patron.numValue)
INNER JOIN -- Bring in the Organizations table for patron branch
    Polaris.Polaris.Organizations pbranch WITH (NOLOCK)
    ON (pbranch.OrganizationID = p.OrganizationID)
INNER JOIN -- Bring in the Organizations table for pickup branch
    Polaris.Polaris.Organizations pickup WITH (NOLOCK)
    ON (pickup.OrganizationID = pickupbranch.numValue)
LEFT JOIN -- Bring in BibliographicRecords table
    Polaris.Polaris.BibliographicRecords br WITH (NOLOCK)
    ON (br.BibliographicRecordID = bibrecord.numValue)
WHERE -- We're only concerned with Hold Request Created
    th.TransactionTypeID IN (6005)
AND -- These dates should match throughout the query
    th.TranClientDate BETWEEN '2022-07-01 00:00:00.000' AND '2024-06-30 23:59:59.999';

/* Populate the temp table of hold events based off the SysHoldRequestIDs
populated to the previous temp table */
INSERT INTO #HoldEvents

SELECT
    DISTINCT th.TransactionID,
    holdreq.numValue,
    item.numValue,
    cir.Barcode,
    mat.Description,
    sloc.Description,
    ird.CallNumber,
    th.TransactionTypeID,
    tt.TransactionTypeDescription,
    th.TranClientDate
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Get SysHoldRequestID
    PolarisTransactions.Polaris.TransactionDetails holdreq WITH (NOLOCK)
    ON (th.TransactionID = holdreq.TransactionID AND holdreq.TransactionSubTypeID = 233)
INNER JOIN -- Get readable TransactionTypeDescription
    PolarisTransactions.Polaris.TransactionTypes tt WITH (NOLOCK)
    ON (th.TransactionTypeID = tt.TransactionTypeID)
LEFT JOIN -- Get the ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails item WITH (NOLOCK)
    ON (th.TransactionID = item.TransactionID AND item.TransactionSubTypeID = 38)
LEFT JOIN -- Bring in CircItemRecords for item data
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
    ON (cir.ItemRecordID = item.numValue)
LEFT JOIN -- Bring in ItemRecordDetails for other item data
    Polaris.Polaris.ItemRecordDetails ird WITH (NOLOCK)
    ON (ird.ItemRecordID = item.numValue)
LEFT JOIN -- Bring in MaterialTypes
    Polaris.Polaris.MaterialTypes mat WITH (NOLOCK)
    ON (mat.MaterialTypeID = cir.MaterialTypeID)
LEFT JOIN -- Bring in ShelfLocations
    Polaris.Polaris.ShelfLocations sloc WITH (NOLOCK)
    ON (sloc.ShelfLocationID = cir.ShelfLocationID)
WHERE
    holdreq.numValue IN (
        SELECT HoldRequestID
        FROM #TempHoldsData
    )
AND -- Looking for last stops for a hold - everything *but* a Hold Created
    th.TransactionTypeID IN (6006,6007,6008,6009,6010,6011,6012,6013,6039,6051,6052,6053,6054,6057,6058)
AND -- These dates should match throughout the query
    th.TranClientDate BETWEEN '2022-07-01 00:00:00.000' AND '2024-06-30 23:59:59.999';

-- Look at #HoldEvents and pull the data from rows based on the last TranClientDate
WITH FinalHoldInfo AS (
    SELECT
    TransactionID,
    HoldRequestID,
    ItemRecordID,
    ItemBarcode,
    MaterialType,
    ShelfLocation,
    ItemCall,
    TransactionTypeID,
    TransactionTypeDescription,
    TranClientDate,
    ROW_NUMBER() OVER (PARTITION BY HoldRequestID ORDER BY TranClientDate DESC) AS rn
FROM
    #HoldEvents
)

/* Create a temp table #FinalStatus and populate it with the final statuses
based on the original SysHoldRequestIDs pulled and populated to
#TempHoldsData */
SELECT
    TransactionID,
    HoldRequestID,
    ItemRecordID,
    ItemBarcode,
    MaterialType,
    ShelfLocation,
    ItemCall,
    TransactionTypeID,
    TransactionTypeDescription,
    TranClientDate
INTO #FinalStatus
FROM FinalHoldInfo
WHERE rn = 1;

-- Update #TempHoldsData with the final statuses and item information
UPDATE
    #TempHoldsData
SET
    #TempHoldsData.ItemBarcode = #FinalStatus.ItemBarcode,
    #TempHoldsData.ItemCall = #FinalStatus.ItemCall,
    #TempHoldsData.MaterialType = #FinalStatus.MaterialType,
    #TempHoldsData.ShelfLocation = #FinalStatus.ShelfLocation,
    #TempHoldsData.FinalHoldStatus = #FinalStatus.TransactionTypeDescription,
    #TempHoldsData.FinalHoldStatusDate = #FinalStatus.TranClientDate
FROM
    #FinalStatus
WHERE    
    #TempHoldsData.HoldRequestID = #FinalStatus.HoldRequestID;

/* -------------------- D A T A   D E L I V E R Y -------------------- */

SELECT
    HoldRequestID AS [HoldRequestID],
    HoldPlaced AS [Request Created],
    PatronBarcode AS [Patron Barcode],
    PatronBranch AS [Patron Branch],
    PatronFullName AS [Patron Name],
    BrowseTitle AS [Title],
    BrowseAuthor AS [Author],
    CASE WHEN ItemBarcode = '0' THEN 'NO ITEM TRAPPED' ELSE ItemBarcode END AS [Item Barcode],
    CASE WHEN MaterialType = '0' THEN 'NO ITEM TRAPPED' ELSE MaterialType END AS [Material Type],
    CASE WHEN ItemCall = '0' THEN 'NO ITEM TRAPPED' ELSE Itemcall END AS [Call Number],
    CASE WHEN ShelfLocation = '0' THEN 'NO ITEM TRAPPED' ELSE ShelfLocation END AS [Shelf Location],
    PickupBranch AS [Pickup Branch],
    CASE WHEN FinalHoldStatus = '0' THEN 'NO ITEM TRAPPED' ELSE FinalHoldStatus END AS [Final Hold Status],
    FinalHoldStatusDate AS [Final Hold Status Date]
FROM
    #TempHoldsData
ORDER BY HoldRequestID ASC;

-- Tidy up
DROP TABLE #FinalStatus;
DROP TABLE #HoldEvents;
DROP TABLE #TempHoldsData;
