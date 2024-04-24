--Iterate through PhoneVoice1, PhoneVoice2 and PhoneVoice3
select *
from Polaris.ViewPatronRegistration
where Polaris.ViewPatronRegistration.PhoneVoice1 = '603'
and Polaris.ViewPatronRegistration.DeliveryOptionID = 8
