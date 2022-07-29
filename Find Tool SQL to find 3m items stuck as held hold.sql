/*This issue has been around for a while now and seems to appear with titles that expire on a given date, instead of after "x" number of uses. There are hold requests on the title, so the item record status in Polaris changes to "Held." However, the item record is expired in 3M. The SQL job to set expired items to withdrawn will not modify a "Held" record, so the item gets stuck in this "Held" limbo.

I've linked this ticket to an existing enhancement request for functionality to set these "Held" but expired items to "Withdrawn." In the meantime, feel free to delete these item records. If you accidentally delete an item you shouldn't, the API Consumer Service will recreate it. 

I have identified all the 3M items currently stuck in held status and placed them in a record set called "3M Items stuck in held status" in case you would like to delete them. Additionally, below is a SQL script that can be ran within an Item Record Find Tool to find any more 3M records stuck in held status:*/

Select ItemrecordId
from polaris.polaris.CircItemRecords c (nolock)
join polaris.polaris.ResourceEntities re (nolock)
on c.ResourceEntityID = re.ResourceEntityID
join polaris.polaris.VendorAccounts va (nolock)
on re.VendorAccountID = va.VendorAccountID
where ItemStatusID = 4
and ItemStatusDate < DATEADD(dd,7,itemstatusdate)
and c.ResourceEntityID is not null
and va.VendorAccountName like '%3M%'
