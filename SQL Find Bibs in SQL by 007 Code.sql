--SQL Find Bibs in SQL by 007 Code

SELECT

BT.BibliographicRecordID

FROM BibliographicTags BT WITH (NOLOCK)

JOIN BibliographicSubfields BS WITH (NOLOCK)

ON BT.BibliographicTagID = BS.BibliographicTagID

WHERE BT.TagNumber = 007

AND PATINDEX('g%',BS.Data) = 1

