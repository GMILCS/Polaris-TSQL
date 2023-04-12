SELECT [Branch Location] = O.Name
, [Number of Transactions] =  COUNT(DISTINCT TH.TransactionID) /*Counting the checkout transactions. This should already be distinct, but adding that just in case.*/
/* I built in some additional parameters in case they are needed for a future run of the query. 
This will break out the counts by Collection, Material type, and/or checkout type.
These are commented out for now. If needed please besure to also uncomment out the same sections in the GROUP BY below.*/
-- , [Material Type] = M.Description
-- , [Collection] = C.Name
-- , [Checkout Type] = CTC.TransactionSubTypeCodeDesc
FROM PolarisTransactions.Polaris.TransactionHeaders AS TH (NOLOCK)
-- Patrons Assigned Branch - 123
JOIN PolarisTransactions.Polaris.TransactionDetails AS TDPat (NOLOCK)
ON TH.TransactionID =TDPat.TransactionID
AND TDPat.TransactionSubTypeID = 123
JOIN Polaris.Polaris.Organizations As O (NOLOCK)
ON TDPat.numValue = O.OrganizationID
-- Checkout Type - 145
JOIN PolarisTransactions.Polaris.TransactionDetails AS CT (NOLOCK)
ON TH.TransactionID = CT.TransactionID
AND CT.TransactionSubTypeID = 145
JOIN PolarisTransactions.Polaris.TransactionSubTypeCodes AS CTC (NOLOCK)
ON CT.TransactionSubTypeID = CTC.TransactionSubTypeID 
AND CT.numValue = CTC.TransactionSubTypeCode
-- Material Type - 4
JOIN PolarisTransactions.Polaris.TransactionDetails AS MT (NOLOCK)
ON TH.TransactionID = MT.TransactionID
AND MT.TransactionSubTypeID = 4
JOIN Polaris.Polaris.MaterialTypes AS M
ON MT.numValue = M.MaterialTypeID
-- Start of LEFT JOINs for optional and exclusion data
-- Assigned Collection Code - 61
LEFT JOIN PolarisTransactions.Polaris.TransactionDetails AS COL (NOLOCK)
ON TH.TransactionID = COL.TransactionID
AND COL.TransactionSubTypeID = 61
LEFT JOIN Polaris.Polaris.Collections AS C (NOLOCK)
ON COL.numValue = C.CollectionID
-- Renewal Bit - 124
LEFT JOIN PolarisTransactions.Polaris.TransactionDetails AS R (NOLOCK)
ON TH.TransactionID = R.TransactionID
AND R.TransactionSubTypeID = 124
-- Electronic Item - 301
LEFT JOIN PolarisTransactions.Polaris.TransactionDetails AS EI (NOLOCK)
ON TH.TransactionID = EI.TransactionID
AND EI.TransactionSubTypeID = 301
-- Vendor Account ID - 300
LEFT JOIN PolarisTransactions.Polaris.TransactionDetails AS VA (NOLOCK)
ON TH.TransactionID = VA.TransactionID
AND VA.TransactionSubTypeID = 300
-- Parameters
WHERE TransactionDate BETWEEN '2022-05-01' and '2023-01-01' 
/*Unless adding in time, always have the end date be the following day. This will stop at midnight on the last day. i.e. 2023-01-01 00:00:00.000*/
AND TH.TransactionTypeID = 6001 -- Checkouts only
AND R.numValue IS NULL -- Exclude Renewals
AND EI.numValue IS NULL -- Exclude Electronic Items
AND VA.numValue IS NULL -- Exclude things with vendor accounts (integrated eContent)
GROUP BY O.Name
-- , M.Description
-- , C.Name
-- , CTC.TransactionSubTypeCodeDesc