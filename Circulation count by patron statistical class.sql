/*Thanks to Daniel Messer

This query produces a circ count for patron statistical classes along with the transacting branch and the patrons’ assigned branch. The original request (on the IUG Discord) called for UDF 4 to appear in the results but this can be modified/removed if needed.*/


SELECT
    tbranch.Abbreviation AS [Transacting Branch],
    patronstat.numValue AS [Patron Stat Code],
    pscc.Description AS [Patron Stat Class],
    pr.User4 AS [UDF 4],
    o.Abbreviation AS [Patron Assigned Branch],
    COUNT(DISTINCT th.TransactionID) AS [Circ Count]
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls the transacting branch
    Polaris.Polaris.Organizations tbranch WITH (NOLOCK)
    ON (tbranch.OrganizationID = th.OrganizationID)
INNER JOIN -- Gets the patron statistical code ID from TransactionDetails
    PolarisTransactions.Polaris.TransactionDetails patronstat WITH (NOLOCK)
    ON (th.TransactionID = patronstat.TransactionID AND patronstat.TransactionSubTypeID = 33)
INNER JOIN -- Gets the patron's assigned branch from TransactionDetails
    PolarisTransactions.Polaris.TransactionDetails patronbranch WITH (NOLOCK)
    ON (th.TransactionID = patronbranch.TransactionID AND patronbranch.TransactionSubTypeID = 123)
INNER JOIN -- Gets the PatronID from TransactionDetails
    PolarisTransactions.Polaris.TransactionDetails patronid WITH (NOLOCK)
    ON (th.TransactionID = patronid.TransactionID AND patronid.TransactionSubTypeID = 6)
INNER JOIN -- Hooks up Organizations to the patron's assigned branch from TransactionDetails
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = patronbranch.numValue)
LEFT JOIN -- Pulls in the Patron Stat Class information
    Polaris.Polaris.PatronStatClassCodes pscc WITH (NOLOCK)
    ON (pscc.StatisticalClassID = patronstat.numValue)
LEFT JOIN -- User4 (UDF4) lives in PatronRegistration
    Polaris.Polaris.PatronRegistration pr WITH (NOLOCK)
    ON (pr.PatronID = patronid.numValue)
WHERE -- Check outs
    th.TransactionTypeID = 6001
AND -- Adjust dates as desired
    th.TranClientDate BETWEEN '2024-03-01 00:00:00.000' AND '2024-03-14 23:59:59.999'
GROUP BY
    tbranch.Abbreviation,
    patronstat.numValue,
    pscc.Description,
    pr.User4,
    o.Abbreviation
ORDER BY
    COUNT(DISTINCT th.TransactionID) DESC