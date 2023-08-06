--I originally spent quite a bit of time thinking about this.  Since the due date is not stored as part of the check out transactions (and you would still have to account for renewals and reset due dates), I figured this would be a delightfully devilish piece of code that tried to calculate the due dated based on loan periods at the the time of checkout/renewals.  Very complicated!

--Then it occurred to me to look at the Check In subtransactions.  There is a "Checkin overdue" flag, which I assume works like the the Renewal flag for checkouts.  In addition, I'm working on the assumption that items being checked in (because they were previously checked out) will always have patron data associated with the checkin information.  With these two assumptions, the following code will let you know how many items were checked in late since October 01, 2015.

SELECT COUNT(td1.numValue)
FROM PolarisTransactions.Polaris.TransactionHeaders AS [th] WITH (NOLOCK)
--ItemRecordID
INNER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td1] WITH (NOLOCK)
ON th.TransactionID = td1.TransactionID AND td1.TransactionSubTypeID = '38'
--patronID
LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td2] WITH (NOLOCK)
ON th.TransactionID = td2.TransactionID AND td2.TransactionSubTypeID = '6'
--Checkin overdue
LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td3] WITH (NOLOCK)
ON th.TransactionID = td3.TransactionID AND td3.TransactionSubTypeID = '127'
WHERE th.TransactionTypeID = '6002'
AND td2.numValue IS NOT NULL
AND td3.numValue IS NOT NULL
AND th.TransactionDate > '20151001'

--Adjust the date parameter as needed.  In order to find the total number of check ins, comment out the td3.numValue to get:

SELECT COUNT(td1.numValue)
FROM PolarisTransactions.Polaris.TransactionHeaders AS [th] WITH (NOLOCK)
--ItemRecordID
INNER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td1] WITH (NOLOCK)
ON th.TransactionID = td1.TransactionID AND td1.TransactionSubTypeID = '38'
--patronID
LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td2] WITH (NOLOCK)
ON th.TransactionID = td2.TransactionID AND td2.TransactionSubTypeID = '6'
--Checkin overdue
LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td3] WITH (NOLOCK)
ON th.TransactionID = td3.TransactionID AND td3.TransactionSubTypeID = '127'
WHERE th.TransactionTypeID = '6002'
AND td2.numValue IS NOT NULL
--AND td3.numValue IS NOT NULL
AND th.TransactionDate > '20151001'

--This only looks at the items that were returned and does not consider items that might be lost or still out.  Given your question, I suspect this would be sufficient.
--Trevor Diamond
