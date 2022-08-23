SELECT psc.description, COUNT(*) [Quantity] 
FROM PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK) 
JOIN PolarisTransactions.Polaris.TransactionTypes tt WITH (NOLOCK) 
ON th.TransactionTypeID = tt.TransactionTypeID 
JOIN PolarisTransactions.Polaris.TransactionDetails td WITH (NOLOCK) 
ON th.TransactionID = td.TransactionID 
AND td.TransactionSubTypeID = 6 
JOIN PolarisTransactions.Polaris.TransactionSubTypes sub WITH (NOLOCK) 
ON td.TransactionSubTypeID = sub.TransactionSubTypeID 
JOIN Polaris.Polaris.PatronRegistration pr WITH (NOLOCK) 
ON td.numValue = pr.PatronID 
JOIN Polaris.Polaris.PatronStatClassCodes psc WITH (NOLOCK) 
ON pr.StatisticalClassID = psc.StatisticalClassID 
JOIN PolarisTransactions.Polaris.TransactionDetails tdMat WITH (NOLOCK) 
ON tdMat.TransactionID = th.TransactionID 
AND tdMat.TransactionSubTypeID = 4 
JOIN PolarisTransactions.Polaris.TransactionSubTypes subMat WITH (NOLOCK) 
ON tdMat.TransactionSubTypeID = subMat.TransactionSubTypeID 
JOIN Polaris.Polaris.MaterialTypes mt WITH (NOLOCK) 
ON tdMat.numValue = mt.MaterialTypeID 
WHERE th.TransactionTypeID IN (6001) 
AND MONTH(TransactionDate) = MONTH(DateAdd(Month,-1,GETDATE())) 
AND YEAR(TransactionDate) = YEAR(DATEADD(Month,-1,GETDATE())) 
GROUP BY psc.Description 
ORDER BY psc.Description 
