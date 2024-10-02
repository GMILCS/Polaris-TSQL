select distinct br.BrowseAuthor, br.BrowseTitle, tom. Description
 from Folaris.SysHoldRequests shr with (nolock)
inner join Polaris. BibliographicRecords br with (nolock)

on (br. BibliographicRecordiD = shr. BibliographicKecordID)
 inner join Folaris.CircItemRecords cir with (nolock)
on (shr.BibliographicRecordID = cir.AssociatedBibRecordID)
 inner join Polaris.MARCTYPEofMaterial tom with (nolock)
on (tom.marctypeofmaterialid = shr.PrimaryMARCTOMID)
 inner join Polaris. SysHoldStatuses hs with (nolock)
on (hs.SysHoldStatusID = shr.SysHoldStatusID)
where cir. ItemStatusID = 13 --on order

 and cir.AssignedBranchID = 5
 and shr.PickupBranchID = 5
 and hs. SysHoldStatusID = 3 --active
 order by ton. Description
