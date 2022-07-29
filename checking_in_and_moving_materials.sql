--From IUG 2021 derek.brown@rhpl.org
--This is a snip of our code that looks through existing material in the "wild" and moves it to a different branch location. We do this since our main library branch leverages an automated material returns machine and we wanted the material to come off of the patrons record when it was returned.
--This runs every hour...

UPDATE TOP (1000) Polaris.Polaris.CircItemRecords
-- Move Items OUT in the wild from MAIN library to RESTING branch WITHOUT holds
SET AssignedBranchID = '14', ShelfLocationID = sl2.ShelfLocationID, StatisticalCodeID = sc2.StatisticalCodeID
FROM Polaris.Polaris.CircItemRecords AS [cir] WITH (NOLOCK)
LEFT OUTER JOIN Polaris.Polaris.ShelfLocations AS [sl1] WITH (NOLOCK)
ON cir.AssignedBranchID = sl1.OrganizationID AND cir.ShelfLocationID = sl1.ShelfLocationID
LEFT OUTER JOIN Polaris.Polaris.ShelfLocations AS [sl2] WITH (NOLOCK)
ON sl1.Description = sl2.Description AND sl2.OrganizationID = '14'
LEFT OUTER JOIN Polaris.Polaris.StatisticalCodes AS [sc1] WITH (NOLOCK)
ON cir.AssignedBranchID = sc1.OrganizationID AND cir.StatisticalCodeID = sc1.StatisticalCodeID
LEFT OUTER JOIN Polaris.Polaris.StatisticalCodes AS [sc2] WITH (NOLOCK)
ON sc1.Description = sc2.Description AND sc2.OrganizationID = '14'
LEFT OUTER JOIN Polaris.Polaris.PatronAccount AS [pa] WITH (NOLOCK)
ON pa.ItemRecordID = cir.ItemRecordID
LEFT OUTER JOIN Polaris.polaris.Patrons AS [ps] WITH (NOLOCK)
ON ps.PatronID = pa.PatronID
-- Items assigned to our main library branch
WHERE AssignedBranchID = '3'
AND ItemStatusID = '2'
-- Ignore IIL
AND ILLFlag = '0'
-- Ignore all econtent
AND cir.Barcode NOT LIKE 'econtent%'
-- Ignore all melcat items out to a patron
-- AND ps.Barcode NOT LIKE 'INNREACH%'
AND cir.AssociatedBibRecordID NOT IN (SELECT BibliographicRecordID
FROM Polaris.Polaris.SysHoldRequests AS [shr] WITH (NOLOCK)
WHERE shr.SysHoldStatusID = '3')
AND cir.Barcode NOT IN (SELECT DISTINCT(ItemBarcode)
FROM Polaris.Polaris.SysHoldRequests AS [shr] WITH (NOLOCK)
WHERE shr.SysHoldStatusID = '3'
AND ItemBarcode IS NOT NULL)

--This moves material checked out to our patrons to a specific "resting" branch that the automation machine is also set to. When an item comes across the belt it checks the item "in" and lives in that "resting" branch for a set period of time. Items on hold or that do not fit the standard category are put into the exceptions bin and are handled manually by our staff.

--We then follow up with a removal of the quarantine once a day that will take the items out of the "resting" branch and move them back to the standard workflow for our library (based on our time allotted to quarantine).

UPDATE Polaris.Polaris.CircItemRecords
-- Move Items from RESTING branch to MAIN
SET AssignedBranchID = '3', ShelfLocationID = sl2.ShelfLocationID, StatisticalCodeID = sc2.StatisticalCodeID
FROM Polaris.Polaris.CircItemRecords AS [cir] WITH (NOLOCK)
LEFT OUTER JOIN Polaris.Polaris.ShelfLocations AS [sl1] WITH (NOLOCK)
ON cir.AssignedBranchID = sl1.OrganizationID AND cir.ShelfLocationID = sl1.ShelfLocationID
LEFT OUTER JOIN Polaris.Polaris.ShelfLocations AS [sl2] WITH (NOLOCK)
ON sl1.Description = sl2.Description AND sl2.OrganizationID = '3'
LEFT OUTER JOIN Polaris.Polaris.StatisticalCodes AS [sc1] WITH (NOLOCK)
ON cir.AssignedBranchID = sc1.OrganizationID AND cir.StatisticalCodeID = sc1.StatisticalCodeID
LEFT OUTER JOIN Polaris.Polaris.StatisticalCodes AS [sc2] WITH (NOLOCK)
ON sc1.Description = sc2.Description AND sc2.OrganizationID = '3'
WHERE AssignedBranchID = '14'
AND barcode NOT LIKE 'econtent%'
AND CheckInDate BETWEEN DATEADD(day,-3,GETDATE()) AND DATEADD(day,-2,GETDATE())

--The process came with new challenges, but SQL helped manage the majority of our items and relieve stress for our limited staff.

