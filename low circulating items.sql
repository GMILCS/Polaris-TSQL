SELECT *
FROM Polaris.Polaris.CircItemRecords AS [cir] WITH (NOLOCK)
WHERE cir.FirstAvailableDate < DATEADD(year,-5,GETDATE())
AND cir.ItemRecordID NOT IN (
SELECT td.numValue
FROM PolarisTransactions.Polaris.TransactionHeaders AS [th] WITH (NOLOCK)
INNER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td] WITH (NOLOCK)
ON th.TransactionID = td.TransactionID AND td.TransactionSubTypeID = '38'
LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [renew] WITH (NOLOCK)
ON th.TransactionID = renew.TransactionID AND renew.TransactionSubTypeID = '124'
WHERE th.TransactionTypeID = '6001'
AND renew.numValue IS NULL
AND th.TranClientDate > DATEADD(year,-5,GETDATE())
GROUP BY td.numValue
HAVING COUNT(td.numValue) > '3')