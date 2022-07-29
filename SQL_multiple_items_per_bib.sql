Select BR.BrowseTitle, BR.BrowseAuthor, BR.PublicationYear, COUNT(CIR.ItemRecordID) as Copies, CIR.AssignedBranchID
from Polaris.CircItemRecords CIR (nolock)
JOIN Polaris.BibliographicRecords BR (nolock)
ON BR.BibliographicRecordID=CIR.AssociatedBibRecordID
JOIN Polaris.ItemRecordDetails IRD (nolock)
ON CIR.ItemRecordID=IRD.ItemRecordID
GROUP BY BR.PublicationYear, CIR.AssociatedBibRecordID, BR.PublicationYear, BR.BrowseTitle, BR.BrowseAuthor, CIR.AssignedCollectionID, CIR.AssignedBranchID
HAVING COUNT(CIR.ItemRecordID) > 3 and CIR.AssignedCollectionID=6 and CIR.AssignedBranchID=3
ORDER BY BR.BrowseAuthor
