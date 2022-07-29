SELECT BibliographicRecordID

FROM BibliographicTags bt (nolock)

INNER JOIN BibliographicSubfields BS (nolock)

ON (bt.BibliographicTagID = bs.BibliographicTagID)

Where TagNumber = 049

AND bs.Subfield LIKE 'a'

AND bs.Data LIKE '%BUNA%'

AND bt.BibliographicRecordID NOT IN (SELECT DISTINCT AssociatedBibRecordID FROM CircItemRecords)
