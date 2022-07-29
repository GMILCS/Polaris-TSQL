SELECT CIR.ItemRecordID AS "RecordID", BR.BrowseTitle AS "Title", BR.BrowseAuthor AS "Author", BR.MARCPubDateOne AS "Pub Date"
FROM CircItemRecords CIR WITH (NOLOCK)
JOIN ItemRecordDetails IRD WITH (NOLOCK)
ON IRD.ItemRecordID = CIR.ItemRecordID
JOIN ItemRecordHistory IRH
ON IRD.ItemRecordID = IRH.ItemRecordID
JOIN BibliographicRecords BR WITH (NOLOCK)
ON CIR.AssociatedBibRecordID = BR.BibliographicRecordID
WHERE CIR.AssignedBranchID IN (3,5,7,9,11,15,17,19,21,23,25,27,29,31,33,35) --Excluding HPL
AND CIR.MaterialTypeID IN (18) --large print
AND IRH.ActionTakenID = 66 --Held for hold request
AND IRH.OrganizationID = 13
AND IRH.TransactionDate BETWEEN '2022-06-01' and '2022-07-20'
GROUP BY CIR.ItemRecordID, BR.BrowseTitle, BR.BrowseAuthor, BR.MARCPubDateOne
ORDER BY BR.MARCPubDateOne DESC, BR.BrowseTitle, BR.BrowseAuthor, CIR.ItemRecordID
