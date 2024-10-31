-- Thanks to Daniel Messer

/* In our case, the state report only cares about the number of items you lend/borrow, not how many 
checkouts occurred. */

-- This is the master temp table used to collect and deliver data.
CREATE TABLE #TempCircLendingData (
    ItemOrgName NVARCHAR(50) NULL,
    ItemOrgID INT NULL,
    MaterialTypeID INT NULL,
    MatDescription NVARCHAR(50) NULL,
    TransactionDate DATETIME,
    TransactOrgName NVARCHAR(50) NULL,
    TransactionTypeID INT,
    ItemRecordID INT,
    PatronID INT,
    TransactionID INT
);

-- Begin populating that table
INSERT INTO #TempCircLendingData

SELECT
    iab.Name,
    itemab.numValue,
    0, -- Initializing - will update later with MaterialTypeID
    0, -- Initializing - will update later with MaterialType Description
    th.TranClientDate,
    torg.Name,
    th.TransactionTypeID,
    itemid.numValue,
    0, -- Initializing - will update later with PatronID
    th.TransactionID
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Item assigned branch
    PolarisTransactions.Polaris.TransactionDetails itemab WITH (NOLOCK)
    ON (th.TransactionID = itemab.TransactionID AND itemab.TransactionSubTypeID = 125)
INNER JOIN -- Item assigned branch readable name
    Polaris.Polaris.Organizations iab WITH (NOLOCK)
    ON (iab.OrganizationID = itemab.numValue)
INNER JOIN -- ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails itemid WITH (NOLOCK)
    ON (th.TransactionID = itemid.TransactionID AND itemid.TransactionSubTypeID = 38)
INNER JOIN -- Transacting branch readable name
    Polaris.Polaris.Organizations torg WITH (NOLOCK)
    ON (th.OrganizationID = torg.OrganizationID)
WHERE -- Check out
    th.TransactionTypeID = 6001
AND -- Adjust dates as needed
    th.TranClientDate BETWEEN '2023-07-01 00:00:00.000' AND '2024-06-30 23:59:59.999'
AND -- Put in the OrganizationIDs for the item's assigned branches and set boolean operations as desired
    itemab.numValue IN (14,15,110,113)
AND -- Put in the OrganizatonsIDs for the transacting branches and set boolean operations as desired
    th.OrganizationID NOT IN (14,15,110,113)

-- DEBUG
--SELECT * FROM #TempCircLendingData;

/* ---------------------------------------------------------------------------------------- */

/* If you do too much and try to pull in too much data for the table above, this query can go from an
execution time measured in seconds to an execution time measured in minutes. So we'll bring in the
MaterialType data separately, acting upon the TransactionIDs in #TempCircLendingData, and then update
the #TempCircLendingData table accordingly. */

CREATE TABLE #TempMaterialData (
    MaterialTypeID INT,
    MatDescription NVARCHAR(50),
    TransactionID INT
);

INSERT INTO
    #TempMaterialData
SELECT
    material.numValue,
    mat.Description,
    th.TransactionID
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Get MaterialTypeID
    PolarisTransactions.Polaris.TransactionDetails material WITH (NOLOCK)
    ON (th.TransactionID = material.TransactionID AND material.TransactionSubTypeID = 4)
INNER JOIN -- Get readable MaterialType description
    Polaris.Polaris.MaterialTypes mat WITH (NOLOCK)
    ON (mat.MaterialTypeID = material.numValue)
WHERE
    th.TransactionID IN (
        SELECT TransactionID FROM #TempCircLendingData
    );

-- DEBUG
--SELECT * FROM #TempMaterialData;

/* ---------------------------------------------------------------------------------------- */

/* If you do too much and try to pull in too much data for the table above, this query can go from an
execution time measured in seconds to an execution time measured in minutes. So we'll bring in the
PatronID data separately, acting upon the TransactionIDs in #TempCircLendingData, and then update
the #TempCircLendingData table accordingly. */

CREATE TABLE #TempPatronData (
    PatronID INT,
    TransactionID INT
);

INSERT INTO
    #TempPatronData
SELECT
    patron.numValue,
    th.TransactionID
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Get PatronID
    PolarisTransactions.Polaris.TransactionDetails patron WITH (NOLOCK)
    ON (th.TransactionID = patron.TransactionID AND patron.TransactionSubTypeID = 6)
WHERE
    th.TransactionID IN (
        SELECT TransactionID FROM #TempCircLendingData
    );

/* ---------------------------------------------------------------------------------------- */
/* Update the #TempCircLendingData table with MaterialType and Patron data */

-- Update MaterialTypes
UPDATE
    #TempCircLendingData
SET
    #TempCircLendingData.MaterialTypeID = #TempMaterialData.MaterialTypeID,
    #TempCircLendingData.MatDescription = #TempMaterialData.MatDescription
FROM
    #TempMaterialData
WHERE
    #TempMaterialData.TransactionID = #TempCircLendingData.TransactionID;

-- Update Patron
UPDATE
    #TempCircLendingData
SET
    #TempCircLendingData.PatronID = #TempPatronData.PatronID
FROM
    #TempPatronData
WHERE
    #TempPatronData.TransactionID = #TempCircLendingData.TransactionID;

/* ---------- DATA DELIVERY ---------- */
/* The #TempCircLendingData table is fully populated. Put your final data delivery queries below. */

/*SELECT
    ItemOrgName AS [Item Assigned Library],
    ItemOrgID AS [Item Assigned OrgID],
    MaterialTypeID,
    MatDescription AS [Material Type],
    TransactionDate,
    TransactOrgName AS [Checkout Library],
    PatronID,
    ItemRecordID
FROM
    #TempCircLendingData
WHERE
    MaterialTypeID NOT IN (38,39,45,157,161,162,163,164);*/

SELECT
    PatronID,
    COUNT(DISTINCT ItemRecordID)
FROM
    #TempCircLendingData
GROUP BY
    PatronID;

-- Tidy up
DROP TABLE #TempCircLendingData;
DROP TABLE #TempMaterialData;
DROP TABLE #TempPatronData;