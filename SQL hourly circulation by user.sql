select pu.Name, 

--torg.name as TransactionBranchName,

--tstc.TransactionSubTypeCodeDesc as CheckoutType,

DATEPART(yy,th.TranClientDate) as 'Year', 

DATEPART(mm,th.TranClientDate) as 'Month', 

DATEPART(dd,th.TranClientDate) as 'Day',

DATEPART(dw,th.TranClientDate) as 'WeekDay',

case

when DATEPART(dw,th.TranClientDate) = 1 then 'Sunday' 

when DATEPART(dw,th.TranClientDate) = 2 then 'Monday' 

when datepart(dw,th.TranClientDate) = 3 then 'Tuesday' 

when datepart(dw,th.TranClientDate) = 4 then 'Wednesday' 

when datepart(dw,th.TranClientDate) = 5 then 'Thursday' 

when datepart(dw,th.TranClientDate) = 6 then 'Friday' 

when datepart(dw,th.TranClientDate) = 7 then 'Saturday' 

end as 'Day',

DATEPART(hh,th.TranClientDate) AS 'Hour', 

count(distinct th.transactionid) as Total  



from PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK) 

left outer join PolarisTransactions.Polaris.TransactionDetails td (nolock) 

on (th.TransactionID = td.TransactionID)  

inner join Polaris.Polaris.Organizations torg (nolock) 

on (th.OrganizationID = torg.OrganizationID)  

inner join PolarisTransactions.Polaris.TransactionSubTypeCodes tstc with (nolock) 

on (td.TransactionSubTypeID = tstc.TransactionSubTypeID) and (td.numvalue = tstc.TransactionSubTypeCode)  

INNER JOIN Polaris.Polaris.PolarisUsers pu (NOLOCK) 

ON pu.PolarisUserID = th.PolarisUserID 



where th.TransactionTypeID = 6001 and td.TransactionSubTypeID = 145  

and th.TranClientDate between @StartDate and @EndDate + ' 23:59:59'  

and th.OrganizationID in (@Branch)

and tstc.TransactionSubTypeCode in (15,23) 



Group by pu.Name, 

--tstc.TransactionSubTypeCodeDesc,

DATEPART(yy,th.TranClientDate),

DATEPART(mm,th.TranClientDate), 

DATEPART(dd,th.TranClientDate),

DATEPART(dw,th.TranClientDate),

DATEPART(hh,th.TranClientDate)



Order by 

--tstc.TransactionSubTypeCodeDesc,

--DATENAME(dw,th.TranClientDate),

DATEPART(yy,th.TranClientDate),

DATEPART(mm,th.TranClientDate), 

DATEPART(dd,th.TranClientDate),

DATEPART(dw,th.TranClientDate),

DATEPART(hh,th.TranClientDate),

pu.name 
