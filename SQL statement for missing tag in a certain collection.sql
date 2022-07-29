select distinct br.BibliographicRecordID as RecordID

from polaris.polaris.CircItemRecords cir

join polaris.polaris.BibliographicRecords br on

	cir.AssociatedBibRecordID = br.BibliographicRecordID

left join polaris.polaris.BibliographicTags bt on

	bt.BibliographicRecordID = br.BibliographicRecordID and bt.TagNumber = 526

where bt.BibliographicTagID is null and cir.AssignedCollectionID in ( 1,2,3 ) --Change these to your Collection IDs
