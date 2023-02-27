SELECT

 
BT.BibliographicRecordID

FROM BibliographicTags BT WITH (NOLOCK)

JOIN BibliographicSubfields BS WITH (NOLOCK)

ON BT.BibliographicTagID = BS.BibliographicTagID

WHERE BT.TagNumber = 006

AND PATINDEX('j%',BS.Data) = 1

AND BT.BibliographicRecordID IN

(

SELECT BT.BibliographicRecordID

FROM BibliographicTags BT WITH (NOLOCK)

JOIN BibliographicSubfields BS WITH (NOLOCK)

ON BT.BibliographicTagID = BS.BibliographicTagID

WHERE BT.TagNumber = 007

AND PATINDEX('s%',BS.Data) = 1)

AND BT.BibliographicRecordID IN

(

SELECT BT.BibliographicRecordID

FROM BibliographicTags BT WITH (NOLOCK)

JOIN BibliographicSubfields BS WITH (NOLOCK)

ON BT.BibliographicTagID = BS.BibliographicTagID

WHERE NOT BT.TagNumber = 007

AND PATINDEX('%d%',BS.Data) = 2)
