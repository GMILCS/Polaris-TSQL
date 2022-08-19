--Find with TXT as notification option
SELECT DISTINCT P.Barcode, P.LastActivityDate,pr.ExpirationDate
FROM Patrons P WITH (NOLOCK)
JOIN PatronRegistration PR WITH (NOLOCK)
ON P.PatronID = PR.PatronID
WHERE PR.DeliveryOptionID = '8'
AND pr.PhoneVoice3 = '111-111-1111'
AND pr.TxtPhoneNumber = 2
ORDER BY LastActivityDate Desc;

--Find with email as notification option
SELECT DISTINCT P.Barcode, P.LastActivityDate,pr.ExpirationDate
FROM Patrons P WITH (NOLOCK)
JOIN PatronRegistration PR WITH (NOLOCK) ON P.PatronID = PR.PatronID WHERE PR.DeliveryOptionID = '2'
AND pr.PhoneVoice2 = '111-111-1111'
AND pr.TxtPhoneNumber = 2
order by LastActivityDate desc;
