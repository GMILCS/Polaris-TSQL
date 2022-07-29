SELECT a.BibliographicRecordID, 1 as [ItemCount]
FROM BibliographicRecords a
WHERE a.ILLFlag = 0 AND a.RecordStatusID = 1
and a.bibliographicrecordid in (select bibliographicrecordid from bibrecordsets where 
recordsetID = 44338)