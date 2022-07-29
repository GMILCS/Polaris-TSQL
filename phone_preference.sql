SELECT pr.Phonevoice1,'|', p.Barcode
	FROM polaris.Polaris.PatronRegistration pr
		inner join Polaris.polaris.patrons p
	ON pr.PatronID = p.PatronID
	WHERE pr.DeliveryOptionID = 3
	AND pr.PhoneVoice1 IS NOT NULL
	AND p.PatronCodeID NOT IN (2,3,4,5,8,9,13,21,22,25,27,28,29,34,35,36)
	AND pr.Expirationdate > GETDATE ()
