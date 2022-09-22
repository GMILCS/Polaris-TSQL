SELECT bt.BibliographicRecordID
FROM BibliographicTags bt (NOLOCK) 
JOIN BibliographicSubfields bsf (NOLOCK) 
ON bsf.BibliographicTagID = bt.BibliographicTagID
WHERE bt.TagNumber = 856
AND bsf.Data LIKE 'http%'
