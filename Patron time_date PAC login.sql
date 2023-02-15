--..making the date whatever you'd like and replacing the Barcode with the patron's


SELECT th.TransactionDate AS 'Login' 

FROM PolarisTransactions.Polaris.TransactionHeaders th (NOLOCK)

JOIN PolarisTransactions.Polaris.TransactionDetails td (NOLOCK)

ON td.TransactionID = th.TransactionID

JOIN Polaris.Polaris.Patrons p (NOLOCK)

ON td.numValue = p.PatronID

WHERE th.TransactionTypeID = '2200'

AND th.TransactionDate > '3/24/2014'

AND p.Barcode = 'barcodeGoesHere'

