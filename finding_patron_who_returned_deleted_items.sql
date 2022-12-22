--do this first
select * from PatronAcctDeletedItemRecords with (nolock)
where Barcode = 'xxx'


--then put in ItemRecordID to get Patron ID
select * 
from PatronAccount with (nolock)
where ItemRecordID = 'xxx'
order by TxnDate

Select PatronID
	(Select Bottom ItemRecordID 
		From PatronAcctDeletedItemRecords with (nolock)
		Where Barcode = 'xxx')
From PatronAccount with (nolock)
Where ItemRecordID = ''
Order by TxnDate