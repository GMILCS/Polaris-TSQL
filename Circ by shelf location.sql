SELECT 
    torg.Name AS TransactionBranchName, 
    sl.Description AS ShelfLocation, 
    COUNT(DISTINCT th.TransactionID) AS Total
FROM 
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
LEFT OUTER JOIN 
    PolarisTransactions.Polaris.TransactionDetails td296 WITH (NOLOCK) -- Join for ShelfLocationID
    ON th.TransactionID = td296.TransactionID
    AND td296.TransactionSubTypeID = 296 -- Filter applied directly in join
INNER JOIN 
    PolarisTransactions.Polaris.TransactionDetails td125 WITH (NOLOCK) -- Join for Items Assigned Branch Field
    ON th.TransactionID = td125.TransactionID
    AND td125.TransactionSubTypeID = 125 -- Filter applied directly in join
INNER JOIN 
    Polaris.Polaris.Organizations torg WITH (NOLOCK)
    ON th.OrganizationID = torg.OrganizationID
INNER JOIN 
    Polaris.Polaris.ShelfLocations sl WITH (NOLOCK)
    ON td296.numValue = sl.ShelfLocationID
    AND sl.OrganizationID = 16 -- Direct join condition for organization
WHERE 
    th.TransactionTypeID = 6001
    AND th.TranClientDate BETWEEN '2021-01-01' AND '2021-12-31'
    AND th.OrganizationID = 16
    AND td125.numValue = 16 -- Restrict to target branch
GROUP BY 
    torg.Name, 
    sl.Description
ORDER BY 
    torg.Name, 
    sl.Description;
