--generates a list of all items currently assigned to a branch and gives a count of checkouts and renewals at that branch and a separate count of checkouts/renewals at any other branch

SELECT
ir.Barcode
,ir.CallNumber
,ISNULL(ir.VolumeNumber, '') AS Volume
,br.BrowseTitle
,COUNT(CASE WHEN irh.OrganizationID = 7 THEN irh.ItemRecordHistoryID END) AS ThisBranch
,COUNT(CASE WHEN irh.OrganizationID <> 7 THEN irh.ItemRecordHistoryID END) AS OtherBranch


FROM Polaris.Polaris.Itemrecords ir WITH (NOLOCK)
JOIN Polaris.Polaris.BibliographicRecords br (NOLOCK)
ON (ir.AssociatedBibRecordID = br.BibliographicRecordID)
JOIN Polaris.Polaris.ItemRecordHistory irh (NOLOCK)
ON (ir.ItemRecordID = irh.ItemRecordID AND irh.ActionTakenID in (13,75,77,78,79,81,89,91,28,73,76,80,82,93)) --28 and after are renewals

WHERE ir.AssignedBranchID = 7

GROUP BY
ir.Barcode
,ir.CallNumber
,ir.VolumeNumber
,br.BrowseTitle

ORDER BY
ir.CallNumber
,ISNULL(ir.VolumeNumber, '')
