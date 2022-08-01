--DECLARE @CurrentDate DateTime 
--DECLARE @PrevMonthDate DateTime

--SET @CurrentDate=dateadd(dd,datediff(d,0,getdate()),0)
--SET @PrevMonthDate = dateadd(month,-1,@CurrentDate)

select o.displayname as Library, pmt.Description as MaterialType, count(distinct th.TransactionID) as InHouseUse,

CASE WHEN MONTH(GETDATE()) IN (1, 3, 5, 7, 8, 10, 12) THEN 31
            WHEN MONTH(GETDATE()) IN (4, 6, 9, 1) THEN 30
            WHEN (YEAR(GETDATE()) % 4 = 0 AND YEAR(GETDATE()) % 100 != 0) OR
                  YEAR(GETDATE()) % 400 = 0
            THEN 29
            ELSE 28 
			END AS NumberOfDaysInAMonth


from PolarisTransactions.Polaris.TransactionHeaders th with (nolock)

inner join Polaris.Polaris.Organizations o with (nolock)
on (th.organizationid = o.organizationid)

inner join PolarisTransactions.polaris.TransactionTypes tt with (nolock)

on (th.TransactionTypeID = tt.TransactionTypeID)


inner join PolarisTransactions.polaris.TransactionDetails td2 with (nolock)
on (td2.TransactionID = th.TransactionID)

inner join Polaris.Polaris.MaterialTypes pmt with (nolock) 
on (td2.numvalue = pmt.MaterialTypeID)

inner join PolarisTransactions.polaris.TransactionDetails td with (nolock)
on (td.TransactionID = th.TransactionID)

where tt.IsImplemented = 1 -- yes

and th.TransactionTypeID = 6002 -- Check In
and td.TransactionSubTypeID = 128 -- Checkin Type (Normal, Bulk, or Inventory)
and td.numValue in (6, 56) -- 6:check-in type = In House, 56:Checkin Leap In House
and td2.TransactionSubTypeID = 4 -- Material Type

--and th.TranClientDate >=@PrevMonthDate --does this account for days in a month?
--and th.TranClientDate <=@CurrentDate
AND th.TranClientDate BETWEEN DATEADD(MONTH, -1, GETDATE()) AND GETDATE()
--'07/01/2022 00:00:00' and '07/31/2022 23:59:59'
--dateadd(m,datediff(m,0,getdate())-1,0) and dateadd(m,datediff(m,0,getdate()),0) --does this account for days in a month?


group by o.displayname, pmt.Description

order by o.displayname, pmt.Description
