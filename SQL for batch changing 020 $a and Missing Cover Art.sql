--I checked our database to see if the problem you describe above was happening for us.  We use Content Café for cover images and have many DVD bib records with ISBNs in addition to 024 fields.  Some of our records have multiple ISBNs and/or multiple 024 fields.  I spot checked some and we have the correct cover art.  You may be facing another issue.

--Here is a query for the Find Tool that will find DVD records that have an ISBN (a subfield a in an 020 field).

Select distinct bi.BibliographicrecordID as ID from Bibliographicrecords bi with (nolock)
inner join BibliographicTags bt (nolock) on (bi.BibliographicrecordID = bt.BibliographicrecordID)
inner join BibliographicSubfields bs (nolock) on (bt.BibliographicTagID = bs.BibliographicTagID)
where bi.RecordstatusID = 1
and bi.PrimaryMARCTOMID = 33
and bt.TagNumber = 020
and bs.Subfield like 'a'

--If these records are showing the correct cover, you may need to investigate further.  If you find that you need to use the method I posted earlier to remove the 020 fields, you can use this query to narrow down your result set and have fewer titles to export, change, and import.
