--Iterate through PhoneVoice1, PhoneVoice2 and PhoneVoice3
select *
from Polaris.ViewPatronRegistration
where Polaris.ViewPatronRegistration.PhoneVoice1 = '603'
and Polaris.ViewPatronRegistration.DeliveryOptionID = 8

--Modify as necessary depending on the incompleteness 

SELECT patronid
FROM ViewPatronRegistration
WHERE ViewPatronRegistration.PhoneVoice3 LIKE '%603%404%'
  AND ViewPatronRegistration.DeliveryOptionID = 8

--or

SELECT patronid
FROM ViewPatronRegistration
WHERE ViewPatronRegistration.PhoneVoice3 LIKE '%603%404%'
  AND ViewPatronRegistration.DeliveryOptionID = 8


