
--Below is a query that should give you what you want.  It is complex and takes a while to execute, so you may want to try it on your training server, if you have one.

--The query uses a number of select statements, but there are two main selects named olderitems and neweritems.  They are joined to give you both results together.

--The main selects have many of the same elements.  If you modify one element in olderitems, in most cases you will need to modify the same element in neweritems.

--There is a limit for transactions in the past year (one year back from today).  You can modify that, or remove the line to eliminate the date and include all --transactions in your transaction database.

--The assignedcollectionid can be changed to whichever you want.

--The dateadd function can be changed from months to years or vice-versa.  There are examples of each in the query.  You can also change to a specific date, but you --will need to include the date in single quotes, like '01/01/2014'.  If you use a specific date, remember that > '01/01/2014' will include transactions on Jan. 1 --(anything after midnight) and < '01/01/2014' will include transactions up until midnight of the day before.  You may need to adjust your dates a day one way or the --other to include the desired dates.


olderitems.TransactionBranchName, olderitems.Totalolder, neweritems.Totalnewer from

(select torg.name as TransactionBranchName, 

count(distinct th.transactionid) as Totalolder from PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK) 

left outer join PolarisTransactions.Polaris.TransactionDetails td (nolock) on (th.TransactionID = td.TransactionID) 

inner join Polaris.Polaris.Organizations torg (nolock) on (th.OrganizationID = torg.OrganizationID) 

where th.TransactionTypeID = 6001 

and th.TransactionDate > dateadd(yy,-1,getdate())

and td.transactionID in 

(select td.TransactionID from Polaris.Polaris.TransactionDetails td with (nolock) 

where td.TransactionSubTypeID = 38

and td.numValue in (select ItemrecordID as numValue from Polaris.Polaris.CircItemRecords with (nolock)

where FirstAvailableDate < dateadd(mm,-6,getdate() )

and 

AssignedCollectionId = 4)

)

group by torg.Name) as olderitems
