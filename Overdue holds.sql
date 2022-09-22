-- SSMS or Report Builder

select o.Abbreviation
[Checkout Org]

, p.Barcode
[PatronBarcode]

, pr.PatronFullName

, ic.DueDate

, do.DeliveryOption

, case when pr.DeliveryOptionID
= 3 then pr.PhoneVoice1

       when pr.DeliveryOptionID
= 4 then pr.PhoneVoice2

       when pr.DeliveryOptionID
= 5 then pr.PhoneVoice3

       else 

              case when pr.TxtPhoneNumber = 1 then pr.PhoneVoice1

                     when pr.TxtPhoneNumber
= 2 then pr.PhoneVoice2

                     when pr.TxtPhoneNumber
= 3 then pr.PhoneVoice3

                     else COALESCE(pr.PhoneVoice1, pr.PhoneVoice2, pr.PhoneVoice3) + ' : First #' end

       end [PhoneNumber]

, br.BrowseTitle

, br.BrowseAuthor

, cir.Barcode
[ItemBarcode]

from polaris.ItemCheckouts ic (nolock)

inner join polaris.CircItemRecords cir (nolock) on cir.ItemRecordID = ic.ItemRecordID

inner join polaris.Patrons p (nolock) on p.PatronID = ic.PatronID

inner join polaris.PatronRegistration pr (nolock) on pr.PatronID = ic.PatronID

inner join polaris.BibliographicRecords br (nolock) on br.BibliographicRecordID =
cir.AssociatedBibRecordID

left outer join polaris.DeliveryOptions
do (nolock) on do.DeliveryOptionID
= pr.DeliveryOptionID

inner join polaris.Organizations o (nolock) on o.OrganizationID = ic.OrganizationID

where cir.AssociatedBibRecordID
IN

       (

       select shr.BibliographicRecordID
from polaris.SysHoldRequests
shr (nolock) where shr.SysHoldStatusID
= 3 and (shr.ItemLevelHoldItemRecordID =
ic.ItemRecordID or
shr.ItemLevelHoldItemRecordID is null)

       )

and ic.DueDate < getdate()

--and p.PatronCodeID IN (1)   -- if you want to limit to specific patron
codes  -- 
select * from polaris.patroncodes (nolock)

--and ic.OrganizationID IN (3)  -- optional branch limiter   --   
select * from polaris.organizations (nolock)

order by o.Abbreviation, pr.PatronFullName, ic.DueDate, br.BrowseTitle, br.BrowseAuthor, cir.Barcode   -- Choose your own ordering that works best

 

 

-- Find Tool (Item Records)

select distinct cir.ItemRecordID

from polaris.ItemCheckouts ic (nolock)

inner join polaris.CircItemRecords cir (nolock) on cir.ItemRecordID = ic.ItemRecordID

where cir.AssociatedBibRecordID
IN

       (

       select shr.BibliographicRecordID
from polaris.SysHoldRequests
shr (nolock) where shr.SysHoldStatusID
= 3 and (shr.ItemLevelHoldItemRecordID =
ic.ItemRecordID or
shr.ItemLevelHoldItemRecordID is null)

       )

and ic.DueDate < getdate()

and ic.OrganizationID in (3)
