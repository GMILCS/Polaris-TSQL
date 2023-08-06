select COUNT(*) as 'Number of times searched', transactionstring as 'Search word' 
from transactionheaders th with (nolock) 
inner join transactiondetails td with (nolock) on (th.transactionid = td.transactionid) 
inner join transactiondetailstrings tds with (nolock) on (td.numvalue = tds.transactionstringid) 
where transactiontypeid in (1006,1007,1008,1009,1010,1011,1012,1013) 
and transactionsubtypeid = 23 
and tranclientdate between @StartDate and @EndDate 
group by transactionstring 
having COUNT(*) >25 
order by COUNT(*) desc;
--You can comment out the "having" line if you don't care if it's been searched more than 25 times.
