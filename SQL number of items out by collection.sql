
select c.Name, COUNT(*) as Checkouts

from polaris.polaris.CircItemRecords cir

join polaris.polaris.ItemCheckouts ic on

	cir.ItemRecordID = ic.ItemRecordID

join polaris.polaris.Collections c on

	cir.AssignedCollectionID = c.CollectionID

where ic.CheckOutDate between '10/1/2013' and '10/31/2013'

group by c.Name
order by c.Name
