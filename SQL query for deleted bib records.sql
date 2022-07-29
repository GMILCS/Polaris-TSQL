--Because of the individual pieces of information you are looking for are stored in separate table it is difficult to extract and reassemble everything you are asking for.  I run a query every month of the items we need to delete from OCLC also and I am able to accomplish it by doing a batch deletion from the OCLC Connexion client by pasting in all the OCLC numbers of our deleted Bibs.  Below is the query I use and hopefully it will be enough information for you cataloger:

select bs.data


from bibliographicrecords b (NOLOCK)


join bibliographictags bt (NOLOCK)


on bt.bibliographicrecordid = b.bibliographicrecordid


join bibliographicsubfields bs (NOLOCK)


on bs.bibliographictagid = bt.bibliographictagid


where b.recordstatusid = 4


and bt.tagnumber = 35


and bs.data like '%OC%'


and b.recordstatusdate between '2016-03-25' and '2016-03-26'

--If you want all the information and are willing to pick through it try this:

SELECT *


FROM BibliographicTagsAndSubfields_View BV (NOLOCK)


JOIN BibliographicRecords B (NOLOCK)


ON B.BibliographicRecordID = BV.BibliographicRecordID


WHERE B.RecordStatusDate BETWEEN '2016-03-25' AND '2016-03-26'


AND B.RecordStatusID = 4


AND B.BibliographicRecordID IN (


SELECT B.BibliographicRecordID


FROM BibliographicRecords B (NOLOCK)


JOIN BibliographicTags BT (NOLOCK)


ON BT.BibliographicRecordID = B.BibliographicRecordID


JOIN BibliographicSubfields BS (NOLOCK)


ON BS.BibliographicTagID = BT.BibliographicTagID


WHERE B.RecordStatusID = 4


AND BT.TagNumber = 35


AND BS.Data LIKE '%OC%'


AND B.RecordStatusDate BETWEEN '2016-03-25' AND '2016-03-26')


ORDER BY B.BibliographicRecordID, TagNumber
