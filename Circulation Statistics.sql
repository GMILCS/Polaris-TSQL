select count (td.TransactionID) as 'PAC Renewals', o.Name 
from PolarisTransactions..TransactionHeaders th (nolock)
join PolarisTransactions..transactiondetails td (nolock)
on th.TransactionID = td.TransactionID
join organizations o (nolock)
on o.OrganizationID = th.OrganizationID
where transactiontypeID=6001 and transactionsubtypeID = 145 and numvalue=13 
and tranclientdate between '2014-10-01' and '2014-10-24'
group by o.Name
