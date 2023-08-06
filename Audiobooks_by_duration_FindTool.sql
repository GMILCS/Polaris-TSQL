SELECT BR.BibliographicRecordID as RecordID 
FROM Polaris.Polaris.BibliographicRecords BR (NOLOCK)
INNER JOIN Polaris.Polaris.BibliographicTags BT (NOLOCK)
ON BR.BibliographicRecordID = BT.BibliographicRecordID
INNER JOIN Polaris.Polaris.BibliographicSubfields BS (nolock)
ON (bt.BibliographicTagID = bs.BibliographicTagID)
INNER JOIN Polaris.Polaris.BibliographicTOMIndex TOM (nolock)
ON BR.BibliographicRecordID = TOM.BibliographicRecordID
WHERE BT.TagNumber = 306
AND bs.Subfield LIKE 'a'
AND bs.Data <= '020000'
AND TOM.SearchCode IN ('aeb', 'nsr', 'abc', 'abt', 'abk')