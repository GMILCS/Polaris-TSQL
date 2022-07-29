--Here is the one I created for our libraries. This report also sorts the titles by type of material and is designed for a consortium where we have to specify the assigned branch as the same as the pickup branch. (In this example, --it is 29.) You may be able to leave that out. Of course, I'd be interested to see if others have created better scripts.




select distinct  br.BrowseAuthor, br.BrowseTitle, tom.Description

from Polaris.SysHoldRequests shr with (nolock)

inner join Polaris.BibliographicRecords br with (nolock)

on (br.BibliographicRecordID = shr.BibliographicRecordID)

inner join Polaris.CircItemRecords cir with (nolock)

on (shr.BibliographicRecordID = cir.AssociatedBibRecordID)

inner join Polaris.MARCTYPEofMaterial tom with (nolock)

on (tom.marctypeofmaterialid = shr.PrimaryMARCTOMID)

inner join Polaris.SysHoldStatuses hs with (nolock)

on (hs.SysHoldStatusID = shr.SysHoldStatusID)

where cir.ItemStatusID = 15

and cir.AssignedBranchID = 29

and shr.PickupBranchID = 29

and hs.SysHoldStatusID = 3

order by tom.Description
