-- thanks to Daniel Messer
SELECT
    p.Barcode AS [Patron Barcode],
    o.Abbreviation AS [Patron Branch],
    pr.PatronFullName AS [Patron Name],
    pub.Abbreviation AS [Hold Pickup Branch],
    br.BrowseTitle AS [Title],
    br.BrowseAuthor AS [Author],
    cir.Barcode AS [Item Barcode],
    th.TranClientDate AS [Unclaim Date]
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Gets the PatronID
    PolarisTransactions.Polaris.TransactionDetails patron WITH (NOLOCK)
    ON (th.TransactionID = patron.TransactionID AND patron.TransactionSubTypeID = 6)
INNER JOIN -- Gets the ItemRecordID
    PolarisTransactions.Polaris.TransactionDetails itemrecord WITH (NOLOCK)
    ON (th.TransactionID = itemrecord.TransactionID AND itemrecord.TransactionSubTypeID = 38)
INNER JOIN -- Get the BibliographicRecordID
    PolarisTransactions.Polaris.TransactionDetails bibrecord WITH (NOLOCK)
    ON (th.TransactionID = bibrecord.TransactionID AND bibrecord.TransactionSubTypeID = 36)
INNER JOIN -- Get the pickup location
    PolarisTransactions.Polaris.TransactionDetails pickup WITH (NOLOCK)
    ON (th.TransactionID = pickup.TransactionID and pickup.TransactionSubTypeID = 130)
INNER JOIN -- Bring in the Patrons table to get specific patron data
    Polaris.Polaris.Patrons p WITH (NOLOCK)
    ON (p.PatronID = patron.numValue)
INNER JOIN -- Bring in the PatronRegistration table to get specific patron data
    Polaris.Polaris.PatronRegistration pr WITH (NOLOCK)
    ON (pr.PatronID = patron.numValue)
INNER JOIN -- Bring in the BibliographicRecords table to get bib data
    Polaris.Polaris.BibliographicRecords br WITH (NOLOCK)
    ON (br.BibliographicRecordID = bibrecord.numValue)
INNER JOIN -- Bring in the CircItemRecords table for specific item data
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
    ON (cir.ItemRecordID = itemrecord.numValue)
INNER JOIN -- Bring in the Organizations table for patron assigned branch
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = p.OrganizationID)
INNER JOIN -- Bring in the Organzations table again for pickup branch
    Polaris.Polaris.Organizations pub WITH (NOLOCK)
    ON (pub.OrganizationID = pickup.numValue)
WHERE -- Holds become unclaimed
    th.TransactionTypeID = 6008
AND -- Adjust as needed
    TranClientDate BETWEEN '2024-07-22 00:00:00.000' AND '2024-07-29 23:59:59.999'
ORDER BY
    th.TranClientDate DESC,
    pub.Abbreviation ASC,
    pr.PatronFullName ASC
