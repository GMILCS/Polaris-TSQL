--Find Tool

SELECT ItemRecordID
FROM Polaris.Polaris.ItemRecordDetails AS [item] WITH (NOLOCK)
WHERE item.Price IS NULL
