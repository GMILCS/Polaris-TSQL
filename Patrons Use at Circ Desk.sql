--What information do you already have?  Are you just looking for SQL or something for the Find Tool?  Here's the barest bones --kind of query, which assumes you know the workstation ID and the time frame.


Select DISTINCT(td1.NumValue)
FROM PolarisTransactions.Polaris.TransactionHeaders AS [th] WITH (NOLOCK)
INNER JOIN PolarisTransactions.Polaris.TransactionDetails AS [td1] WITH (NOLOCK)
ON th.TransactionID = td1.TransactionID AND td1.TransactionSubTypeID = '6'
WHERE th.WorkstationID = 'X'
AND th.TransactionDate BETWEEN '20161001 00:00:00.000' AND '20161002 00:00:00.000'
