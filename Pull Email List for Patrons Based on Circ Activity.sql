/*Thanks to Daniel Messer

These queries work together to get email addresses for patrons who’ve checked out certain numbers of items over a given period of time. In my case we used this for an email marketing campaign where patrons who’d frequently used their cards got a different message than patrons who only used their cards occasionally.

There are two queries here, one which complies patron circulation data to a table in your Polaris database and another than queries that table. You can eventually drop the patron circulation table later on if you like. It’s just a lot faster to have it sitting in your database rather than using the same data in a temp table over and over again. */



-- FIRST QUERY - RUN ONCE, USE AS NEEDED, DROP AFTERWARDS --

/* This is the first query that collects and writes your patron circulation data to a table in your
Polaris database. This query can take some time to run depending on the amount of circulation data you
need. However, once that data is in the table, it's very fast to query and use. You can drop this
table later on whenever you're done using it. */

SELECT
    patron.numValue AS PatronID,
    COUNT(DISTINCT th.TransactionID) AS CircCount
INTO -- CHANGE THIS TABLE NAME TO SUIT YOUR NEEDS
    Polaris.Lss.TempPatronCircCounts
FROM
    PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
INNER JOIN -- Pulls the PatronID
    PolarisTransactions.Polaris.TransactionDetails patron WITH (NOLOCK)
    ON (th.TransactionID = patron.TransactionID AND patron.TransactionSubTypeID = 6)
WHERE -- Checkouts
    TransactionTypeID = 6001
AND -- Adjust dates to suit your needs -- see line 76 below.
    TranClientDate BETWEEN '2023-01-01 00:00:00.000' AND '2024-02-29 23:59:59.999'
GROUP BY
    patron.numValue

-- SECOND QUERY - DATA DELIVERY --

/* This is the query that pulls data from the table you created above and will deliver email addresses
for patrons whose circulation usage meets your criteria */


-- Create a tempoary table to limit our range and optimize the query
CREATE TABLE #TempPatronsAndEmails (
    PatronID INT,
    Abbreviation NVARCHAR(15),
    EmailAddress NVARCHAR(64),
    NameLast NVARCHAR(100),
    PatronFullName NVARCHAR(100)
);

-- Populate that table
INSERT INTO #TempPatronsAndEmails

SELECT
    pr.PatronID,
    o.Abbreviation,
    pr.EmailAddress,
    pr.NameLast,
    pr.PatronFullName
FROM
    Polaris.Polaris.PatronRegistration pr WITH (NOLOCK)
INNER JOIN
    Polaris.Polaris.Patrons p WITH (NOLOCK)
    ON (p.PatronID = pr.PatronID)
INNER JOIN
    Polaris.Polaris.Organizations o WITH (NOLOCK)
    ON (o.OrganizationID = p.OrganizationID)
WHERE -- We wanted cards that were of a certain age. Adjust your WHERE and AND clauses as needed
    RegistrationDate < DATEADD(MONTH,-3,GETDATE())
AND -- This query was directed at RCLS in Riverside, CA. However you can change this as desired.
    p.OrganizationID IN (
        SELECT OrganizationID
        FROM Polaris.Polaris.Organizations WITH (NOLOCK)
        WHERE Name LIKE 'RCLS%'
    )
AND -- No reason to deal with patrons who don't have an email address at all.
    pr.EmailAddress IS NOT NULL
AND -- Don't include patrons where LastActivityDate doesn't fit in with the parameters. These dates should match the dates in the first query.
    p.LastActivityDate BETWEEN '2023-01-01 00:00:00.000' AND '2024-02-29 23:59:59.999'
ORDER BY
    RegistrationDate DESC;

-- Now that we have a working subset of patrons, use the temp table to pull your emails.
SELECT
    tpe.PatronID,
    tpe.Abbreviation,
    tpe.EmailAddress,
    tpe.NameLast,
    tpe.PatronFullName,
    tpcc.CircCount
FROM
    #TempPatronsAndEmails tpe
LEFT JOIN
    Polaris.Lss.TempPatronCircCounts tpcc WITH (NOLOCK)
    ON (tpcc.PatronID = tpe.PatronID)
WHERE -- Set this as needed for your circulation parameters
    tpcc.CircCount > 12
ORDER BY
    tpe.Abbreviation,
    tpe.PatronFullName

-- Tidy up
DROP TABLE #TempPatronsAndEmails;