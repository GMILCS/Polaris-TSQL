--This will work in the client, and pulls only accounts which have "email" as the notification method, have no email address on file, and haven't yet expired: 

SELECT DISTINCT 
p.PatronID 
FROM PatronRegistration pr (NOLOCK) 
JOIN Patrons p (NOLOCK) ON 
p.PatronID = pr.PatronID 
WHERE pr.DeliveryOptionID = '2' 
AND pr.EmailAddress IS NULL 
AND pr.ExpirationDate > getdate() 
