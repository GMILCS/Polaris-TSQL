/* Thanks to Daniel Messer the CyberpunkLibrarian

This is a query specifically designed for the Polaris ILS Find Tool in the Staff Client and in Leap. Running this in the Record Set Find Tool will return a list of record sets that haven’t been updated within a given amount of time. In other words, it’ll help you find old record sets to weed out and delete. In the query, it’s set to find record sets that were created three months ago and never modified or record sets that haven’t been modified in the last three months. Change the -3 to another number to modify the timespan.*/

SELECT
    RecordSetID
FROM
    RecordSets WITH (NOLOCK)
WHERE
    (CreationDate < DATEADD(MONTH, -3, GETDATE())
AND
    ModificationDate IS NULL)
OR
    ModificationDate < DATEADD(MONTH, -3, GETDATE())
