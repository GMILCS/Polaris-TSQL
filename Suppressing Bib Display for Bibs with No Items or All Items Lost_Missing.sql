--We ran into the same problems at both library systems I've used Polaris with. JT Whit Whitfield posted some very useful SQL in a thread on --11/22/13 that I tweaked and use twice per week to lcoate bibs with no circulating items. I place them in a record set and turn off the --Display in PAC flag. I also run the reverse to find bibs where the flag is set to off but it does have circulating items. This helps catch --missing and lost items that have come back. As you can see from the SQL below it accounts for the status of "On-Order" so you shouldn't --accidentally grab any bibs that you want to keep. You may need to tweak the status or other fields to get it right for your system, but --this has worked great for us.



--We haven't upgraded to 5.0 yet, but in reading the release notes it looks like there's an automated SQL job you can set up that may help --with this issue so that you don't have to do this process manually. You may want to check with your Site Manager about that.



Select BibliographicrecordID as ID from Bibliographicrecords with (nolock)

WHERE RecordstatusID = 1

and Displayinpac = 1

and ( (SELECT COUNT(ItemRecordID) 

FROM Polaris.CircItemRecords XI(NOLOCK)

JOIN Polaris.ItemStatuses XS(NOLOCK)

ON XS.ItemStatusID = XI.ItemStatusID

WHERE XI.AssociatedBibRecordID =

BibliographicRecords.BibliographicRecordID

AND XS.[Description] IN ('In', 'Out', 'Held', 'Out-Ill', 'On-Order', 'Available Soon','Reshelving','Transferred')

) = 0) 
