--This should be what you're asking. It is two queries, one for yesterday, and one for the previous year. I commented out the organization from the select, just in case you wanted a total number. If you want per organization you can uncomment those lines. 

--Yesterday of the previous year

select 

--	torg.name as TransactionBranchName,

	day(th.TranClientDate) as 'Day',

	count(distinct th.transactionid) as Total 

from PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)

	left outer join PolarisTransactions.Polaris.TransactionDetails td (nolock) on (th.TransactionID = td.TransactionID) 

	inner join Polaris.Polaris.Organizations torg (nolock) on (th.OrganizationID = torg.OrganizationID)

where th.TransactionTypeID = 6002 

    and td.TransactionSubTypeID = 38  

    and th.TranClientDate between Dateadd(YEAR,-1,cast(getdate()-1 as date) )and Dateadd(YEAR,-1,cast(getdate() as date) )

    and th.OrganizationID in (4,2,5,17,16,18,6,20,7,3,8,15,9,19,10,11,12,13,14)

Group by

--	torg.name,

	day(th.TranClientDate)

Order by

--	torg.name,

	day(th.TranClientDate)





--yesterday

select  

--	torg.name as TransactionBranchName,

	day(th.TranClientDate) as 'Day',

	count(distinct th.transactionid) as Total 

from PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK)

	left outer join PolarisTransactions.Polaris.TransactionDetails td (nolock) on (th.TransactionID = td.TransactionID) 

	inner join Polaris.Polaris.Organizations torg (nolock) on (th.OrganizationID = torg.OrganizationID)

where th.TransactionTypeID = 6002 

	and td.TransactionSubTypeID = 38  

	and th.TranClientDate between cast(getdate()-1 as date) and cast(getdate() as date) 

	and th.OrganizationID in (4,2,5,17,16,18,6,20,7,3,8,15,9,19,10,11,12,13,14)

Group by

--	torg.name,

	day(th.TranClientDate)

Order by  

--	torg.name,

	day(th.TranClientDate)
