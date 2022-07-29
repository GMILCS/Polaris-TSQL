Select pr.PatronID
    , convert(varchar(20), cir.Barcode) as ItemBarcode
    , convert(varchar(255), br.BrowseTitle) as Title
    , convert(varchar(10), ic.DueDate, 120) as DueDate
    , cir.ItemRecordID
    , '' as Dummy1
    , '' as Dummy2
    , '' as Dummy3
    , '' as Dummy4
    , ic.Renewals
    , br.BibliographicRecordID
    , cir.RenewalLimit
    , convert(varchar(20), p.Barcode) as PatronBarcode
From
    Polaris.ItemCheckouts ic (nolock)
    join Polaris.PatronRegistration pr (nolock) on ic.PatronID=pr.PatronID
    join Polaris.Patrons p (nolock) on pr.PatronID=p.PatronID
    join Polaris.CircItemRecords cir (nolock) on ic.ItemRecordID=cir.ItemRecordID
    join Polaris.BibliographicRecords br (nolock) on cir.AssociatedBibRecordID=br.BibliographicRecordID
Where
    pr.DeliveryOptionID=3 and
    convert(varchar (11),ic.DueDate, 101)=convert(varchar (11), getdate()+3, 101) and
    cir.MaterialTypeID!=12 and
    ic.PatronID not in (Select pcd.PatronID From polaris.PatronCustomDataBoolean pcd (nolock) Where pcd.PatronCustomDataDefinitionID=1 and pcd.CustomDataEntry=1) and
    p.PatronID not in (Select pcd.PatronID From polaris.PatronCustomDataBoolean pcd (nolock) Where pcd.PatronCustomDataDefinitionID=1 and pcd.CustomDataEntry=1)
Order By 
    ic.PatronID
