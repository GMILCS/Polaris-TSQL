select prh.PatronID, prh.ItemRecordID, br.BrowseAuthor, br.BrowseTitle, prh.CheckOutDate from PatronReadingHistory prh inner join ItemRecordDetails ird on (prh.ItemRecordID=ird.ItemRecordID)
inner join CircItemRecords cir on (ird.ItemRecordID=cir.ItemRecordID) 
inner join BibliographicRecords br on (cir.AssociatedBibRecordID=br.BibliographicRecordID)
where prh.PatronID=56100
order by prh.CheckOutDate
