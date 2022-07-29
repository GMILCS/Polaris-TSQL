--SysHoldsRequests table.  Here's a quick SQL query which should get you or your catalogers what you need.   Change what you need to.   The Join with the ItemStatuses table isn't necessary, but if you want to include a description of the status (for other reports) you'll need it.


SELECT Distinct SHR. BrowseTitle , SHR. BibliographicRecordID
FROM Polaris. SysHoldRequests SHR WITH ( NOLOCK )
INNER JOIN Polaris. CircItemRecords CIR WITH ( NOLOCK )
         ON CIR. AssociatedBibRecordID = SHR. BibliographicRecordID
-- INNER JOIN Polaris.ItemStatuses IST WITH (NOLOCK)
--      ON IST.ItemStatusID = CIR.ItemStatusID
WHERE CIR. AssociatedBibRecordID IN
                  ( Select SHR. BibliographicRecordID
                           FROM Polaris. SysHoldRequests )
AND CIR. ItemStatusID = 15 -- ItemStatusID 15 = In Process
--AND CIR.AssignedBranchID = 3 -- use to limit by branch
ORDER BY SHR. BibliographicRecordID
