--Not quite, but if you open the Mobile Phone Carriers table and order by SMS Address, they should kind of come together that way for you, and you can adjust the where clause a bit to reflect the list of IDs.

--For the different carrier IDs (I have 1 here for each of these queries, but it depends on what you need), if you're looking for a specific one, you'll just refer to the database table in SA "Mobile phone carriers" which should have them listed out.

--I have three different queries here since there are three phone number fields that might be selected for text messaging and have different carriers selected.


select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=1
and pr.phone1carrierid in (1,4,10)

select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=2
and pr.phone2carrierid in (1,4,10)

select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=3
and pr.phone3carrierid in (1,4,10)
--or singles

select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=1
and pr.phone1carrierid=1

select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=2
and pr.phone2carrierid=1

select pr.patronid
from patronregistration pr (nolock)
where pr.txtphonenumber=3
and pr.phone3carrierid=1
