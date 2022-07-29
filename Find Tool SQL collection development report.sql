--You could modify the following SQL and run it from the Item Find Tool SQL search mode which would allow you to move the results to a RecordSet.  Modify the ***AssignedBranchID and the MaterialTypeID’s.
 
SELECT CIR.ItemRecordID AS "RecordID"
FROM CircItemRecords CIR
JOIN ItemRecordDetails IRD
ON IRD.ItemRecordID = CIR.ItemRecordID
WHERE CIR.AssignedBranchID = 3
AND CIR.MaterialTypeID IN (12,13,14)
AND IRD.CreationDate < GETDATE()-90
AND (CIR.HoldableByPickup = 1
OR CIR.HoldableByBranch = 1
OR CIR.HoldableByLibrary = 1)
