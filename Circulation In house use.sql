--Rex Helwig It work for me.  Here is the Query in a more compact format with the date range changed and formatted differently.  Try pasting this into the MS SQL Server Management Studio query window.  Make sure you have selected the "Polaris" database.

select COL.name, count(th.transactionid) as Counts 
from polaristransactions.polaris.transactionheaders th (NOLOCK) 
inner join polaristransactions.polaris.transactiondetails td (NOLOCK) 
ON (th.transactionid = td.transactionid) and td.transactionsubtypeid = 38 
inner join polaristransactions.polaris.transactiondetails td2 (NOLOCK) 
ON (th.transactionid = td2.transactionid) and td2.transactionsubtypeid = 128 
inner join circitemrecords cir (NOLOCK) 
ON (cir.itemrecordid = td.numvalue) 
inner join bibliographicrecords br (NOLOCK) 
ON (cir.associatedbibrecordid = br.bibliographicrecordid)
inner join collections col 
ON (col.collectionid = cir.assignedcollectionid) 
and td2.numvalue = 6 
and th.tranclientdate between '2013-01-01' and '2013-10-2 23:59:59.999' 
and th.organizationid = 3
and th.transactiontypeid = 6002 
Group by COL.name 
Order by COL.name


