declare @startDate datetime = DATEADD(YEAR, DATEDIFF(YEAR, 0,DATEADD(YEAR, -1, GETDATE())), 0)

declare @endDate datetime = DATEADD(MILLISECOND, -3, DATEADD(YEAR, DATEDIFF(YEAR, 0, DATEADD(YEAR, -1, GETDATE())) + 1, 0))

select c.name as [Collection], sl.Description as [Shelf Location], COUNT(distinct th.transactionid) as Circs

from PolarisTransactions.polaris.TransactionHeaders th 

join PolarisTransactions.polaris.TransactionDetails td_sl on

	th.TransactionID = td_sl.TransactionID

join PolarisTransactions.polaris.TransactionDetails td_c on

	th.TransactionID = td_c.TransactionID

left join polaris.polaris.ShelfLocations sl on

	td_sl.numValue = sl.ShelfLocationID

left join polaris.polaris.Collections c on

	td_c.numValue = c.CollectionID

where th.transactiontypeid = 6001 and td_sl.TransactionSubTypeID = 296 and td_c.TransactionSubTypeID = 61 and th.TransactionDate between @startDate and @endDate and th.OrganizationID in ( 3 )

group by sl.Description, c.Name

order by c.Name, sl.Description
