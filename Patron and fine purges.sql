/* BEGIN PURGING OF NON-RESIDENT ACCOUNTS FIRST

We delete non-resident accounts after 2 years of inactivity and $25 or less in fines
We delete resident accounts after 3 years of inactivity and $25 or less in fines.

*/

/* STEP 1: Run these BEFORE and AFTER borrower purge. Record figures and send # of juvenile and adult accounts to Ann. */

select count(*) 'Juvenile Accts'
from patrons WITH (NOLOCK)
join PatronCodes
on patrons.PatronCodeID = PatronCodes.PatronCodeID
where patroncodes.PatronCodeID in (2,4,15,16) --youth accounts

select count(*) 'Adult Accts'
from patrons WITH (NOLOCK)
join PatronCodes
on patrons.PatronCodeID = PatronCodes.PatronCodeID
where patroncodes.PatronCodeID not in (2,4,15,16) -- NOT youth accounts

SELECT count(*) '# of inactive accounts'
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-365,getdate())

SELECT count(*) '# of accounts'
from Polaris.Patrons WITH (NOLOCK)

-- BEGIN NON-RESIDENT PURGE (Steps 2-6)

/* STEP 2: Create spreadsheet with all of the non-resident records to be deleted. Sum the charges field. */
SELECT *
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-730,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024 --exclude accts submitted to collection agency
and PatronCodeID in (3,13,14,15,16) --non-resident accounts

/* STEP 3: Get a count Non-resident cardholders */
SELECT count(*) 'Non-resident cardholders'
from Polaris.Patrons WITH (NOLOCK)
where 
PatronCodeID in (3,13,14,15,16) --non-resident accounts

/* STEP 4: Get a count of non-resident accounts to be deleted (No activity 2 years and $25 or less in fines) */
SELECT count(*) 'To be deleted'
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-730,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024 --exclude accts submitted to collection agency
and PatronCodeID in (3,13,14,15,16) --non-resident accounts
--order by LastActivityDate

/* STEP 5: Use the following query in the find tool. Create a record set, and delete records. */
SELECT PatronID
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-730,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024
and PatronCodeID in (3,13,14,15,16)

/* STEP 6: Manually delete remaining non-resident accounts
You'll have to go to the claims/lost screen and go to the item view of each items in order to delete the items. 
After all items have been deleted, you'll then be able to delete the patron account. */

-- BEGIN RESIDENT PURGE (Steps 7-11) 

/* STEP 7: Create spreadsheet with all of the resident records to be deleted. */
SELECT *
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-1095,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024 --exclude accts submitted to collection agency
and PatronCodeID not in (3,13,14,15,16) --NOT non-resident accounts

/* STEP 8: Get a count resident cardholders */
SELECT count(*) 'Resident Accts - Total # of accts'
from Polaris.Patrons WITH (NOLOCK)
where 
PatronCodeID not in (3,13,14,15,16) --non-resident accounts

/* STEP 9: Get a count of resident accounts to be deleted (No activity 3 years and $25 or less in fines) */
SELECT count(*) 'Resident Accts - # to be deleted'
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-1095,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024 --exclude accts submitted to collection agency
and PatronCodeID not in (3,13,14,15,16) --NOT non-resident accounts

/* STEP 10: Use the following query in the find tool. Create a record set, and delete records. */
SELECT PatronID
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-1095,getdate())
and (ChargesAmount-CreditsAmount) <= 25
and systemblocks <> 1024
and PatronCodeID not in (3,13,14,15,16)

/* STEP 11: Manually delete remaining resident accounts
You'll have to go to the claims/lost screen and go to the item view of each items in order to delete the items. 
After all items have been deleted, you'll then be able to delete the patron account. */

/* STEP 12: MUST WAIT UNTIL OVERNIGHT JOBS REMOVES DELETED RECORDS.
Record new numbers in spreadsheet */

select count(*) 'Juvenile Accts'
from patrons
join PatronCodes
on patrons.PatronCodeID = PatronCodes.PatronCodeID
where patroncodes.PatronCodeID in (2,4,15,16) --youth accounts

select count(*) 'Adult Accts'
from patrons
join PatronCodes
on patrons.PatronCodeID = PatronCodes.PatronCodeID
where patroncodes.PatronCodeID not in (2,4,15,16) --NOT youth accounts

SELECT count(*) '# of inactive accounts'
from Polaris.Patrons WITH (NOLOCK)
where 
LastActivityDate < dateadd(dd,-365,getdate())

SELECT count(*) '# of accounts'
from Polaris.Patrons WITH (NOLOCK)
