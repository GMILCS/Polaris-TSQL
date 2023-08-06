SELECT p.Barcode, p.PatronID, count(*) AS 'Holds' FROM Polaris.Polaris.SysHoldRequests shr (NOLOCK)
JOIN Polaris.Polaris.Patrons p (NOLOCK) 
ON p.PatronID = shr.PatronID 
WHERE SysHoldStatusID IN (1,2,3,4,5,6)
GROUP BY p.PatronID, p.Barcode
HAVING Count(shr.PatronID) > 50
ORDER BY Holds DESC
