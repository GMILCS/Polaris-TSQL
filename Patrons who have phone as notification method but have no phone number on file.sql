--We had a request for the same sort of report as the one on patrons with email as notification method but no email address on file, but rewritten for phones.  Here's the query (this works in the client's SQL search):
SELECT DISTINCT p.patronID
FROM PatronRegistration pr (NOLOCK)
JOIN Patrons p (NOLOCK) ON p.PatronID = pr.PatronID
WHERE (
(pr.DeliveryOptionID = '3'
AND pr.PhoneVoice1 IS NULL)
OR
(pr.DeliveryOptionID = '4'
AND pr.PhoneVoice2 IS NULL)
OR
(pr.DeliveryOptionID = '5'
AND pr.PhoneVoice3 IS NULL)
)
AND pr.ExpirationDate > getdate()
