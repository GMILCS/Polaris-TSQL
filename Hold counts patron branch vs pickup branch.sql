/*Thanks to Daniel Messer

This query pulls counts of holds placed at branches by patrons assigned to that branch and by patrons assigned to other branches. Useful for finding out how many patrons from other branches are using a given branch as a pickup branch.*/

SELECT
    patron.Name AS [Patron Branch],
    pickup.Name AS [Pickup Branch],
    COUNT(DISTINCT th.TransactionID) AS [Requests Placed]
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls the patron's assigned branch ID
    PolarisTransactions.Polaris.TransactionDetails patronbranch WITH (NOLOCK)
    ON (th.TransactionID = patronbranch.TransactionID AND patronbranch.TransactionSubTypeID = 123)
INNER JOIN -- Pulls the pickup branch ID
    PolarisTransactions.Polaris.TransactionDetails pickupbranch WITH (NOLOCK)
    ON (th.TransactionID = pickupbranch.TransactionID AND pickupbranch.TransactionSubTypeID = 130)
INNER JOIN -- Get a name for the patron's branches
    Polaris.Polaris.Organizations patron WITH (NOLOCK)
    ON (patron.OrganizationID = patronbranch.numValue)
INNER JOIN -- Get a name for the pickup branches
    Polaris.Polaris.Organizations pickup WITH (NOLOCK)
    ON (pickup.OrganizationID = pickupbranch.numValue)
WHERE -- Drop in whatever OrganizationsIDs you need here for your patron branches
    patronbranch.numValue IN (19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,103,112,115,116)
AND -- Drop in whatever OrganizationIDs you need here for your pickup branches
    pickupbranch.numValue IN (19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,103,112,115,116)
AND -- Hold request created
    th.TransactionTypeID = 6005
AND -- Modify dates as desired
    th.TranClientDate BETWEEN '2024-02-01 00:00:00.000' AND '2024-02-29 23:59:59.999'
GROUP BY
    patron.Name,
    pickup.Name
ORDER BY
    patron.Name,
    COUNT(DISTINCT th.TransactionID) DESC