--If you can get the infromation you need from the Find Tool, you can use this, collecitonID is specific to yourlibrary and ActionTakenID is checkouts:

select distinct irh.PatronID

	from polaris.ItemRecordHistory irh (nolock)

	inner join polaris.CircItemRecords ci (nolock)

		on irh.ItemRecordID = ci.ItemRecordID

	where irh.TransactionDate  between '10/1/2013' and '12/31/2013'

	and irh.PatronID is not null

	and irh.ActionTakenID =13

	and ci.AssignedCollectionID=6





--I built this with Simply Reports and added to my query above, so if you have access to your server, and SQL server management Studio you can use this:



select pr.Birthdate, pr.PatronFullName ,addr.StreetOne,addr.StreetTwo,pos.PostalCode,pos.City,pos.county 

 from Polaris.PatronRegistration pr with (nolock) 

inner join Polaris.Patrons p with (nolock) 

	on (pr.PatronID = p.PatronID)  

left join Polaris.PatronAddresses pa with (nolock) 

	on (pr.PatronID = pa.PatronID and pa.AddressTypeID = 2 ) 

left join Polaris.Addresses addr with (nolock) 

	on (pa.AddressID = addr.AddressID) 

left join Polaris.PostalCodes pos with (nolock) 

	on (addr.PostalCodeID = pos.PostalCodeID)  

inner join(

select distinct irh.PatronID

	from polaris.ItemRecordHistory irh (nolock)

	inner join polaris.CircItemRecords ci (nolock)

		on irh.ItemRecordID = ci.ItemRecordID

	where irh.TransactionDate  between '10/1/2013' and '12/31/2013'

	and irh.PatronID is not null

	and irh.ActionTakenID =13

	and ci.AssignedCollectionID=6

) sub on sub.patronid=p.Patronid
