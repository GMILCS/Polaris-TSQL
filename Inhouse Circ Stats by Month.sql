--This will give you the In House and Checkout numbers for all collections between two dates specified at the top.



declare @startDate datetime = '1/1/2014'

declare @endDate datetime = '2/19/2014'



select	c.Name, 

		inhouse.InHouseUse, 

		checkouts.Checkouts

from

(

	select td_coll.numValue as CollectionID, COUNT(distinct td_coll.TransactionID) as InHouseUse

	from PolarisTransactions.polaris.TransactionHeaders th

	join PolarisTransactions.polaris.TransactionDetails td on

		th.TransactionID = td.TransactionID and td.TransactionSubTypeID = 128

	join PolarisTransactions.polaris.TransactionDetails td_coll on

		td_coll.TransactionID = th.TransactionID and td_coll.TransactionSubTypeID = 61

	where td.TransactionSubTypeID = 128 and td.numValue = 6 and th.TransactionDate between @startDate and @endDate

	group by td_coll.numValue

) inhouse

join 

(

	select td_coll.numValue as CollectionID, COUNT(distinct td_coll.TransactionID) as Checkouts

	from PolarisTransactions.polaris.TransactionHeaders th

	join PolarisTransactions.polaris.TransactionDetails td_coll on

		th.TransactionID = td_coll.TransactionID and td_coll.TransactionSubTypeID = 61 

	where th.TransactionTypeID = 6001 and th.TransactionDate between @startDate and @endDate

	group by td_coll.numValue

) checkouts on checkouts.CollectionID = inhouse.CollectionID

join polaris.polaris.Collections c on

	c.CollectionID = inhouse.CollectionID

order by c.Name
