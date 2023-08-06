/*The following SQL uses a WHERE based on the first letter of the last name but can be deleted if you want.  
May depend on how many patrons are in your database.  
You may need to make adjustments for the Leagal Names if you're using them.
*/
SELECT NameFirst, NameMiddle, NameLast, NameSuffix 
FROM PatronRegistration 
WHERE NameLast LIKE 'A%'  --SQL to view names. Delete Where if not needed.

 

BEGIN TRAN
UPDATE PatronRegistration
SET NameFirst=UPPER(NameFirst), NameMiddle=UPPER(NameMiddle), NameLast=UPPER(NameLast), NameSuffix=UPPER(NameSuffix)
WHERE NameLast LIKE 'A%'

-- COMMIT   -- Once the Update stement is run and you're happy with the results after running the SELECT again, Run COMMIT 
-- ROLLBACK   -- If you're not happy with the results,  Run ROLLBACK to restore.



/*Here's another one run as a nightly job */

UPDATE polaris.PatronRegistration
SET NameFirst = UPPER(NameFirst)
WHERE NameFirst != UPPER(NameFirst)
COLLATE Latin1_General_CS_AS


UPDATE polaris.PatronRegistration
SET NameLast = UPPER(NameLast)
WHERE NameLast != UPPER(NameLast)
COLLATE Latin1_General_CS_AS

UPDATE polaris.PatronRegistration
SET NameMiddle = UPPER(NameMiddle)
WHERE NameMiddle != UPPER(NameMiddle)
COLLATE Latin1_General_CS_AS

UPDATE polaris.Addresses
SET StreetOne = UPPER(StreetOne)
WHERE StreetOne != UPPER(StreetOne)
COLLATE Latin1_General_CS_AS

UPDATE polaris.Addresses
SET StreetTwo = UPPER(StreetTwo)
WHERE StreetTwo != UPPER(StreetTwo)
COLLATE Latin1_General_CS_AS

UPDATE polaris.PatronRegistration
SET LegalNameFirst = UPPER(LegalNameFirst)
WHERE LegalNameFirst != UPPER(LegalNameFirst)
COLLATE Latin1_General_CS_AS
and LegalNameFirst is not NULL

UPDATE polaris.PatronRegistration
SET LegalNameLast = UPPER(LegalNameLast)
WHERE LegalNameLast != UPPER(LegalNameLast)
COLLATE Latin1_General_CS_AS
and LegalNameLast is not NULL

UPDATE polaris.PatronRegistration
SET LegalNameMiddle = UPPER(LegalNameMiddle)
WHERE LegalNameMiddle != UPPER(LegalNameMiddle)
COLLATE Latin1_General_CS_AS
and LegalNameMiddle is not NULL
