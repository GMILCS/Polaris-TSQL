--The Transactions Database keeps a record of every Bib that is deleted which includes the Title.  I wouldn’t want to run the following query against the entire Transaction Database but maybe for the last 2-3 years would be acceptable (the GETDATE()-720 covers the last 2 years).  You could take the following query and create a Reporting Services report that would provide an input field for the title.  After the LIKE replace the Z with the first few letters or words of the title and leave the % (wildcard).  I used the “Z” to test with.  This query reports back the title and the date it was deleted.
 
SELECT TDS.TransactionString AS "Title", TH.TranClientDate AS "Date Deleted"
FROM Polaris.Polaris.TransactionHeaders TH
JOIN Polaris.Polaris.TransactionDetails TD
ON TD.TransactionID = TH.TransactionID
JOIN Polaris.Polaris.TransactionDetailStrings TDS
ON TDS.TransactionStringID = TD.numValue
WHERE TH.TransactionTypeID = 3001
AND TD.TransactionSubTypeID = 49
AND TDS.TransactionString LIKE 'Z%'
AND TH.TranClientDate > GETDATE()-730
ORDER BY TDS.TransactionString, TH.TranClientDate
