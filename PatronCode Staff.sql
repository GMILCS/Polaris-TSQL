SELECT p.PatronID  
FROM Polaris.Polaris.PatronRegistration AS [pr] WITH (NOLOCK)
INNER JOIN Polaris.Polaris.Patrons AS  [p] WITH (NOLOCK) ON pr.PatronID = p.PatronID 
WHERE p.PatronCodeID = '29' AND p.OrganizationID = '15'



