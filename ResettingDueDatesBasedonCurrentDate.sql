-- Thanks to Daniel Messer

-- Create a table to hold onto data and calculated dates
CREATE TABLE #TempItemData (
    ItemRecordID INT,
    PatronID INT,
    LoanPeriodCodeID INT,
    PatronCodeID INT,
    OrganizationID INT,
    CheckoutDate DATETIME,
    DueDate DATETIME,
    TimeUnit INT,
    Units INT,
    NewDueDate DATETIME
);


-- Populate the temp table
INSERT INTO #TempItemData

SELECT
    ico.ItemRecordID,
    ico.PatronID,
    cir.LoanPeriodCodeID,
    p.PatronCodeID,
    ico.OrganizationID,
    ico.CheckoutDate, -- The most recent checkout date in ItemCheckouts, if an item has been renewed, this date reflects that
    ico.DueDate, -- The current, and likely wrong due date
    lp.TimeUnit, -- The time units used based upon LoanPeriod data (Days, Hours, Minutes)
    lp.Units, -- The actual number of the above units 
    -- The parameter below calculates the proper due date based on Loan Periods
    DATEADD(SECOND, -1, DATEADD(DAY, lp.Units + 1, CAST(CAST(ico.DueDate AS DATE) AS DATETIME))) AS NewDueDate
FROM
    Polaris.Polaris.ItemCheckouts ico WITH (NOLOCK)
INNER JOIN
    Polaris.Polaris.Patrons p WITH (NOLOCK)
    ON (p.PatronID = ico.PatronID)
INNER JOIN
    Polaris.Polaris.CircItemRecords cir WITH (NOLOCK)
    ON (cir.ItemRecordID = ico.ItemRecordID)
INNER JOIN -- Loan periods are figured by a combination of LoanPeriodCodeID, PatronID, and OrganizationID
    Polaris.Polaris.LoanPeriods lp WITH (NOLOCK)
    ON (
        lp.LoanPeriodCodeID = cir.LoanPeriodCodeID
        AND ico.OrganizationID = lp.OrganizationID
        AND p.PatronCodeID = lp.PatronCodeID
    )
WHERE -- Adjust dates as needed
    DueDate BETWEEN '2024-10-14 00:00:00.000' AND '2024-10-14 23:59:59.999'
AND -- Exclude eContent
    cir.MaterialTypeID NOT IN (38,39,161,157,45,164,13,55,133,62,147,148,149);

/* -- CHECK YOUR DATA FIRST BEFORE UPDATING -- */
/* -- Comment out the SELECT below when you're ready to update -- */
--SELECT * FROM #TempItemData
--ORDER BY CheckoutDate DESC;

/* -- WHEN YOU'RE READY TO UPDATE, UNCOMMENT THE QUERY BELOW -- */

-- Use a BEGIN TRAN for safety
/* BEGIN TRAN 
UPDATE
    Polaris.Polaris.ItemCheckouts
SET
    ItemCheckouts.DueDate = #TempItemData.NewDueDate
FROM
    #TempItemData
WHERE
    ItemCheckouts.ItemRecordID = #TempItemData.ItemRecordID
AND
    ItemCheckouts.PatronID = #TempItemData.PatronID; */

-- Rollback or commit as necessary
-- ROLLBACK
-- COMMIT;

/* -- RETAIN YOUR TEMP TABLE UNTIL YOU'RE DONE WITH THE UPDATE ABOVE -- */
DROP TABLE #TempItemData;