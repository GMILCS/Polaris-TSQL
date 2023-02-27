SELECT DISTINCT(td1.numValue)

FROM PolarisTransactions.Polaris.TransactionHeaders AS [th] WITH (NOLOCK)

INNER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td1] WITH (NOLOCK)

ON th.TransactionID = td1.TransactionID AND td1.TransactionSubTypeID = '6'

LEFT OUTER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td2] WITH (NOLOCK)

ON th.TransactionID = td2.TransactionID AND td2.TransactionSubTypeID = '124'

WHERE th.TransactionTypeID = '6001'

AND td2.numValue IS NULL

AND th.TransactionDate BETWEEN '08/01/2013' AND '09/02/2013'
