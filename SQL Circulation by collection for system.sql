select col.Name as [Collection], count(th.TransactionID) as [Checkout Count]
from PolarisTransactions.Polaris.TransactionHeaders th with (nolock)
inner join PolarisTransactions.Polaris.TransactionDetails td1 (nolock)
on th.TransactionID = td1.TransactionID and td1.TransactionSubTypeID =  61
left join Polaris.Polaris.Collections col (nolock)
on td1.numValue = col.CollectionID
where th.TransactionDate >= '08/01/2021' --date of first day you want
and th.TransactionDate < '09/01/2022' --date _after_ the last day you want
and th.TransactionTypeID = 6001 --checkouts
group by col.Name
order by col.Name
