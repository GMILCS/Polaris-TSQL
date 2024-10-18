-- Thanks to wesochuck
SELECT ird.ItemRecordID
FROM Polaris.Polaris.ItemRecordDetails ird
JOIN Polaris.Polaris.CircItemRecords cir ON ird.ItemRecordID = cir.ItemRecordID
JOIN Polaris.Polaris.Organizations o ON cir.AssignedBranchID = o.OrganizationID
WHERE ird.Price > 500 --adjust dollar amount as needed
  AND cir.NonCirculating = 0 --only look for CIRCULATING items, withOUT the non-circulating checkmark
  AND cir.RecordStatusID <> 4 --exclude item records with a deleted record status
  AND cir.ItemStatusID NOT IN (3, 11, 13, 17) --exclude Out-ILL, Withdrawn, On-Order, Returned-ILL
  --AND cir.MaterialTypeID NOT IN (); --uncomment and add a commas separated list of material type ids you might want to exclude, like reference, ebooks, etc.