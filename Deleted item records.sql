--You could use something like the SQL I've attached to give you the number of item deletions minus the number of item undeletions.



declare @startDate datetime = '1/1/20013'

declare @endDate datetime = '1/1/2014'



select	

(	-- Item Deletions

	select COUNT(*) 

	from PolarisTransactions.polaris.TransactionHeaders th 

	where th.TransactionTypeID = 3007 and th.TransactionDate between @startDate and @endDate 

) -

(	-- Minus Item Undeletions

	select COUNT(*) 

	from PolarisTransactions.polaris.TransactionHeaders th 

	where th.TransactionTypeID = 3028 and th.TransactionDate between @startDate and @endDate 

)
