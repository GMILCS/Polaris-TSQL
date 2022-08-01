--Find Tool
--This item record find tool SQL search is designed to find instances where a branch has more than one available book attached to a single bib record. To customize the report for your needs, you would just reblace the marker [BranchID] with your actual branch ID number from Polaris. You could also modfiy the report to change the material type searched (this query searches for books only) or the item circulation statuses searched (this query will find In, Out, Out-ILL, Held, Transferred, In-Transit, In-Repair, In-Process, Returned-ILL, and Routed items), or you might eliminate those parameters altogether. This report also excludes any items that have data in the Volume field of the item record, to exclude encyclopedia sets and other multi-volume works that use a single bib record. 

SELECT IR.ItemRecordID as RecordID 
FROM Polaris.ItemRecords IR WITH (NOLOCK) 
JOIN Polaris.BibliographicRecords BR WITH (NOLOCK) on 
IR.AssociatedBibRecordID = BR.BibliographicRecordID 
JOIN Polaris.ItemRecordDetails IRD WITH (NOLOCK) on 
IR.ItemRecordID = IRD.ItemRecordID 
where IR.AssociatedBibRecordID in 
(SELECT IR.AssociatedBibRecordID 
FROM Polaris.ItemRecords IR WITH (NOLOCK) 
WHERE IR.AssignedBranchID = [BranchID] and IR.ItemStatusID in (1,2,3,4,5,6,14,15,17,18) 
GROUP BY IR.AssociatedBibRecordID 
HAVING count(IR.Barcode) > 1) 
and IR.AssignedBranchID = [BranchID] 
and IR.MaterialTypeID=1 
and IRD.VolumeNumber is null 
and IR.ItemStatusID in (1,2,3,4,5,6,14,15,17,18) 
