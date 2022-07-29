select distinct  td_item.numValue [RecordID]

from PolarisTransactions.Polaris.TransactionHeaders th

join PolarisTransactions.Polaris.TransactionDetails td_coll on

	td_coll.TransactionID = th.TransactionID and td_coll.TransactionSubTypeID = 61

join PolarisTransactions.Polaris.TransactionDetails td_item on

	td_item.TransactionID = th.TransactionID and td_item.TransactionSubTypeID = 38		

where TransactionTypeID = 6001 and 

/* CHANGE ME */ td_coll.numValue = 5 and -- YOUR COLLECTION ID

/* CHANGE ME */ th.TransactionDate > ' 1/1/2014' -- YOUR START DATE

group by td_item.numValue

/* CHANGE ME */ having COUNT(distinct th.transactionid) =< 5 -- YOUR MINIMUM CHECKOUTS
