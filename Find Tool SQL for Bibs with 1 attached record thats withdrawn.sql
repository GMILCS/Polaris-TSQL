SELECT BR.BibliographicRecordID as RecordID 

FROM BibliographicRecords BR (NOLOCK)

LEFT OUTER JOIN RWRITER_BibDerivedDataView RW (NOLOCK)

ON BR.BibliographicRecordID = RW.BibliographicRecordID

WHERE RW.NumberofItems = 1

and RW.NumberWithdrawnItems = 1

and BR.DisplayInPAC = 1
