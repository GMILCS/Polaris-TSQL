/*Thanks to Daniel Messer

This query looks for Polaris users who haven’t logged in for a given amount of time. It helps you find users who no longer work for the library, but their account still exists in Polaris. */

-- Create a table that holds onto a subset of Polaris users
CREATE TABLE #TempPolarisLogins (
    PolarisUserID INT,
    CreationDate DATETIME,
    Name NVARCHAR(50),
    Library NVARCHAR(50),
    Branch NVARCHAR(50)
);

-- Populate the table with users that meet our criteria
INSERT INTO #TempPolarisLogins

SELECT
    pu.PolarisUserID,
    pu.CreationDate,
    pu.Name,
    library.Name AS Library,
    branch.Name AS Branch
FROM
    Polaris.Polaris.PolarisUsers pu WITH (NOLOCK)
INNER JOIN -- Pull in the users' assigned library
    Polaris.Polaris.Organizations library WITH (NOLOCK)
    ON (pu.OrganizationID = library.OrganizationID)
LEFT JOIN -- Pull in the users' assigned branch
    Polaris.Polaris.Organizations branch WITH (NOLOCK)
    ON (pu.BranchID = branch.OrganizationID)
WHERE -- No need to deal with deleted users
    pu.Name NOT LIKE '%deleted%'
AND -- Look for users in PolarisTransactions that haven't logged in for a while
    pu.PolarisUserID NOT IN (
        SELECT PolarisUserID
        FROM PolarisTransactions.Polaris.TransactionHeaders WITH (NOLOCK)
        WHERE TransactionTypeID = 7200 -- System logon
        AND TranClientDate BETWEEN '2024-01-01 00:00:00.000' AND '2024-03-05 23:59:59.999' -- Adjust dates as desired
    )
ORDER BY
    pu.CreationDate DESC

-- Data delivery
SELECT
    tpl.PolarisUserID AS [PolarisUserID],
    tpl.CreationDate AS [Account Creation Date],
    tpl.Name AS [Username],
    tpl.Library AS [Assigned Library],
    tpl.Branch AS [Assigned Branch],
    MAX(th.TranClientDate) AS [Most Recent Login]
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN
    #TempPolarisLogins tpl
    ON (tpl.PolarisUserID = th.PolarisUserID)
GROUP BY
    tpl.PolarisUserID,
    tpl.CreationDate,
    tpl.Name,
    tpl.Library,
    tpl.Branch
ORDER BY
    tpl.CreationDate DESC;

-- Tidy up
DROP TABLE #TempPolarisLogins;