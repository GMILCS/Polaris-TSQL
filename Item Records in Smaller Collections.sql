/*Thanks to Daniel Messer

This query looks for low number counts of items in your collections, the idea being that you might have items miscatalogued or mis-assigned to given collections that may not be used at a particular branch or location. It then produces a list of items in those collections so you can identify any problems. */

-- Set the minimum number that you want to limit for in the collection
DECLARE @MinimumTarget INT = 20;

-- Set the OrganizationID for the branch you want to work with
DECLARE @BranchID INT = 27;

-- Create a table to pull in counts of items in the collections
CREATE TABLE #TempCollectionCount (
    AssignedCollectionID INT,
    ItemCount INT
);

-- Populate that table
INSERT INTO #TempCollectionCount

SELECT
    AssignedCollectionID,
    COUNT(ItemRecordID)
FROM
    Polaris.Polaris.CircItemRecords WITH (NOLOCK)
WHERE
    AssignedBranchID = @BranchID
GROUP BY
    AssignedCollectionID
ORDER BY
    COUNT(ItemRecordID) ASC;

-- Data delivery
SELECT
    c.Name AS [Collection],
    ird.CallNumber AS [Call Number],
    br.BrowseTitle AS [Title],
    br.BrowseAuthor AS [Author],
    cir.Barcode AS [Barcode],
    bctn.ISBN AS [ISBN],
    br.PublicationYear AS [Pub Year],
    cir.LastCheckoutRenewDate AS [Last Checkout],
    cir.LifetimeCircCount AS [Lifetime Circ],
    o.Name AS [Assigned Branch]
FROM
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
INNER JOIN
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = cir.AssignedBranchID)
LEFT JOIN
    Polaris.Polaris.Collections c WITH (NOLOCK)
    ON (c.CollectionID = cir.AssignedCollectionID)
INNER JOIN
    Polaris.Polaris.ItemRecordDetails ird WITH (NOLOCK)
    ON (ird.ItemRecordID = cir.ItemRecordID)
INNER JOIN
    Polaris.Polaris.BibliographicRecords br WITH (NOLOCK)
    ON (br.BibliographicRecordID = cir.AssociatedBibRecordID)
LEFT JOIN -- Pulls in the indexed ISBN
    RwriterBibCtrlNumView bctn WITH (NOLOCK)
    ON (cir.AssociatedBibRecordID = bctn.BibliographicRecordID)
WHERE -- Add the item to the results only if it appears within a low number collection in the TempCollectionCount table
    cir.AssignedCollectionID IN (
        SELECT AssignedCollectionID
        FROM #TempCollectionCount
        WHERE ItemCount <= @MinimumTarget
    )
AND
    cir.AssignedBranchID = @BranchID
ORDER BY
    c.Name ASC;

-- Tidy up    
DROP TABLE #TempCollectionCount;