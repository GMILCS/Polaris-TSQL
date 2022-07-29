select prh.PatronID, prh.ItemRecordID, mtom.Description, br.BrowseTitle, br.BrowseAuthor, prh.CheckOutDate from PatronReadingHistory prh 
inner join ItemRecordDetails ird on (prh.ItemRecordID=ird.ItemRecordID)
inner join CircItemRecords cir on (ird.ItemRecordID=cir.ItemRecordID) 
inner join BibliographicRecords br on (cir.AssociatedBibRecordID=br.BibliographicRecordID)
left join MARCTypeOfMaterial mtom on (br.PrimaryMarcTOMID = mtom.MARCTypeOfMaterialID)
where prh.PatronID=56100
order by prh.CheckOutDate