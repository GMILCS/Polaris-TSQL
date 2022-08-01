--Find Tool
--Since you asked for suggestions.  This will just return the ItemRecords that could fill an Active Hold at you Library.  Change the CIR.AssignedBranchID to the one you want to search for or removed the entire line for all of them.  Run this from the Item Record Find Tool SQL.
 
SELECT DISTINCT CIR.ItemRecordID AS RecordID
FROM CircItemRecords CIR
JOIN BibliographicRecords B
ON B.BibliographicRecordID = CIR.AssociatedBibRecordID
JOIN SysHoldRequests SHR
ON SHR.BibliographicRecordID = CIR.AssociatedBibRecordID
WHERE SHR.SysHoldStatusID = 3
AND CIR.ItemStatusID = 15
AND CIR.RecordStatusID <> 4
AND CIR.AssignedBranchID = 59
