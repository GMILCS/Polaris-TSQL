select top 10 br.BrowseTitle,

count(th.Transactionid) as Circs

from PolarisTransactions.Polaris.TransactionHeaders TH (nolock)

JOIN PolarisTransactions.Polaris.TransactionDetails TD(nolock)

on th.Transactionid = td.transactionid

JOIN polaris.Polaris.CircItemRecords CIR (nolock)

on CIR.ItemRecordID=TD.numvalue

JOIN polaris.Polaris.bibliographicrecords br (nolock)

on CIR.AssociatedBibRecordID=BR.BibliographicRecordID

where th.transactiontypeid=6001 

and td.TransactionSubTypeID = 38

group by br.BrowseTitle

order by count(th.Transactionid) DESC
