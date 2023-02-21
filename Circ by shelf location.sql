select torg.name as TransactionBranchName, sl.description as ShelfLocation,count(distinct th.transactionid) as Total
from PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)
left outer join PolarisTransactions.Polaris.TransactionDetails td296 (nolock) --I changed your alias to account for a second join to TransactionDetails
on (th.TransactionID = td296.TransactionID)
inner join PolarisTransactions.Polaris.TransactionDetails td125 (nolock) --I added a second join to TransactionDetails to get the Items Assigned Brannch Field
on (th.TransactionID = td125.TransactionID)
inner join Polaris.Polaris.Organizations torg (nolock)
on (th.OrganizationID = torg.OrganizationID)
inner join Polaris.Polaris.ShelfLocations sl (nolock)
on (td296.numvalue = sl.ShelfLocationID)
where th.TransactionTypeID = 6001
and td296.TransactionSubTypeID = 296
and td125.TransactionSubTypeID = 125 --limits the second TransactionDetails join to the Items Assigned Branch subtype
and th.TranClientDate between '01/01/2021' and '12/31/2021'
and th.OrganizationID = 16
and td125.numValue = 16 --limits transactions to items assigned to your target banch
and (sl.description in
(Select description from POLARIS.Polaris.ShelfLocations where organizationid = 16)) --I added the second Polaris so that I could test this locally
Group by torg.name,sl.description
Order by torg.name,sl.description
