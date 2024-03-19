/*Thanks to Daniel Messer

This query looks for items added to existing bibliographic records in order to see if cataloguers are creating new bib records for newer items or if they’re adding the items to the extant bibs that are already in the system. This may need some tweaking as our Polaris ILS Admins typically handle the deletion of withdrawn items after a certain time, so the PolarisUsersIDs for our Admins are called out in the query. You’ll likely need to adjust those PolarisUserIDs to reflect whoever does item deletions within your own system.

Three results are provided:

    A list of items added to extant bibs along with when the last time was deleted and when the most recent item was added.

    The total number of distinct bibs with new items added to them.

    The total number of distinct bibs with items deleted from them and the total number of item records deleted

The results are collected across a given timespan. */

-- Create a table to hold on to item deletion data
CREATE TABLE #TempItemDeletions20231110 (
    BibliographicRecordID INT,
    ItemDeletedDate DATETIME
);

-- Create a table to hold on to item creation data
CREATE TABLE #TempItemCreations20231110 (
    ItemRecordID INT,
    Description NVARCHAR(80),
    BibliographicRecordID INT,
    ItemDeletedDate DATETIME,
    ItemCreationDate DATETIME,
    Age1 INT,
    BibCreationDate DATETIME,
    Age2 INT,
    BrowseTitle NVARCHAR(255),
    BrowseAuthor NVARCHAR(255)
);

-- Populate items deleted table
INSERT INTO #TempItemDeletions20231110

SELECT
    bibrecord.numValue,
    th.TranClientDate
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails itemrecord WITH (NOLOCK)
    ON (th.TransactionID = itemrecord.TransactionID AND itemrecord.TransactionSubTypeID = 38)
INNER JOIN -- Pulls AssociatedBibRecordID
    PolarisTransactions.Polaris.TransactionDetails bibrecord WITH (NOLOCK)
    ON (th.TransactionID = bibrecord.TransactionID AND bibrecord.TransactionSubTypeID = 39)
WHERE -- Item record deleted
    th.TransactionTypeID = 3007
AND -- Adjust these to reflect the PolarisUserIDs for people who handle item deletions
    th.PolarisUserID IN (15,16,17)
AND -- Adjust dates as necessary. Dates should match throughout the query.
    th.TranClientDate BETWEEN '2023-01-01 00:00:00.000' AND '2023-12-30 23:59:59.999';

-- Populate items created table
INSERT INTO #TempItemCreations20231110

SELECT
    itemrecord.numValue,
    mat.Description,
    bibrecord.numValue,
    tid.ItemDeletedDate,
    ird.CreationDate,
    DATEDIFF(DAY,tid.ItemDeletedDate,ird.CreationDate),
    br.CreationDate,
    DATEDIFF(DAY,br.CreationDate,ird.CreationDate),
    br.BrowseTitle,
    br.BrowseAuthor

FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails itemrecord WITH (NOLOCK)
    ON (th.TransactionID = itemrecord.TransactionID AND itemrecord.TransactionSubTypeID = 38)
INNER JOIN -- Pulls AssociatedBibRecordID
    PolarisTransactions.Polaris.TransactionDetails bibrecord WITH (NOLOCK)
    ON (th.TransactionID = bibrecord.TransactionID AND bibrecord.TransactionSubTypeID = 39)
INNER JOIN -- Bring in CircItemRecords
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
    ON (cir.ItemRecordID = itemrecord.numValue)
INNER JOIN -- Bring in ItemRecordDetails
    Polaris.Polaris.ItemRecordDetails ird WITH (NOLOCK)
    ON (ird.ItemRecordID = cir.ItemRecordID)
INNER JOIN -- Bring in BibliographicRecords
    Polaris.Polaris.BibliographicRecords br WITH (NOLOCK)
    ON (br.BibliographicRecordID = bibrecord.numValue)
INNER JOIN -- Bring in MaterialTypes
    Polaris.Polaris.MaterialTypes mat WITH (NOLOCK)
    ON (mat.MaterialTypeID = cir.MaterialTypeID)
INNER JOIN -- Bring in our deleted items temp table
    #TempItemDeletions20231110 tid
    ON (tid.BibliographicRecordID = bibrecord.numValue)
WHERE -- Item record created
    th.TransactionTypeID = 3008
AND -- Adjust dates as necessary. Dates should match throughout the query.
    th.TranClientDate BETWEEN '2023-01-01 00:00:00.000' AND '2023-12-31 23:59:59.999'
AND -- Don't include items created the same day that the bib record was created
    DATEDIFF(DAY,tid.ItemDeletedDate,ird.CreationDate) >= 0
AND
    bibrecord.numValue IN (SELECT BibliographicRecordID FROM #TempItemDeletions20231110)

ORDER BY
    tid.ItemDeletedDate;

-- Data delivery --

-- Produce a list of new items added to existing bib records
SELECT
    ItemRecordID AS [New ItemRecordID],
    Description AS [Material Type],
    BibliographicRecordID,
    ItemDeletedDate AS [Item Deletion],
    ItemCreationDate AS [Item Created],
    Age1 AS [Age - Item Deleted to Item Creation],
    BibCreationDate AS [Bib Created],
    Age2 AS [Age - Bib Creation to Item Creation],
    BrowseTitle AS [Title],
    BrowseAuthor AS [Author]
FROM
    #TempItemCreations20231110;

-- Produce a count of existing bibs with new items
SELECT
    COUNT(DISTINCT BibliographicRecordID) AS [Total Distinct Bibs with New Items]
FROM
    #TempItemCreations20231110;

-- Produce counts of bibs that have had items deleted and the total number of records deleted    
SELECT
    COUNT(DISTINCT BibliographicRecordID) AS [Total Distinct Bibs With Deletions],
    COUNT(*) AS [Total Item Records Deleted]
FROM
    #TempItemDeletions20231110; 

-- Tidy up
DROP TABLE #TempItemDeletions20231110;
DROP TABLE #TempItemCreations20231110;
