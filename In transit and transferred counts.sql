--This query uses the PolarisTransactions database, so no time limit on results if you keep your transactions:
Use PolarisTransactions
select org.name as SendingLibrary, orgn.name as ReceivingLibrary, count(td.transactionid) as NumberSent
from polaris.transactionheaders th with(nolock) 
left join polaris.transactiondetails td with(nolock) on th.Transactionid = td.transactionid
left join polaris.polaris.organizations org with(nolock) on th.organizationid = org.organizationid
left join polaris.polaris.organizations orgn with(nolock) on td.numValue = orgn.organizationid
where th.transactiontypeid=6012 and td.transactionsubtypeid=131 and th.transactiondate > '10-1-2020'
and th.transactiondate < '9-30-2021'
Group by org.name, orgn.name
order by org.name
