--It looks for records with data in an 035 field that starts with (OCoLC) that duplicate other records with this data.  You can add other fields from the --BibliographicRecords table if needed.  If you add fields they need to be added to the top select statement and to the second one (in t1).  The RecStatus field codes --are 1 for final, 4 for deleted.
--In our database, we have some bib records that have an OCLC number in more than one format (with and without ocm, ocn, etc.).  If there are duplicates of both numbers --in a record, the bib records will show up twice in the list (the second set of duplicate fields will probably be separate from the first on the list)

select
distinct (t1.BibliographicRecordID), t1.BrowseTitle, t1.Data, t1.RecStatus from 
(select br.Bibliographicrecordid, br.BrowseTitle, bs.Data, br.RecordStatusID as RecStatus from polaris.BibliographicRecords br with (nolock)
join polaris.BibliographicTags bt (nolock) on (br.BibliographicRecordID = bt.BibliographicRecordID)
join polaris.BibliographicSubfields bs (nolock) on (bs.BibliographicTagID = bt.BibliographicTagID)
where bt.TagNumber = 035 and bs.Data like '(OCoLC%') as t1
join
(select br.BibliographicRecordID, bs.Data from polaris.BibliographicRecords br with (nolock)
join polaris.BibliographicTags bt (nolock) on (br.BibliographicRecordID = bt.BibliographicRecordID)
join polaris.BibliographicSubfields bs (nolock) on (bs.BibliographicTagID = bt.BibliographicTagID)
where bt.TagNumber = 035) t2 on 
(t1.Data = t2.Data and t1.BibliographicRecordID <> t2.BibliographicRecordID)
order by t1.Data, t1.BibliographicRecordID
