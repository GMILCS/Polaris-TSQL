-- Thanks to wesochuck
SELECT 
    pc.Description AS PatronCodeDescription,
    c.Name AS CollectionName,
    COUNT(DISTINCT td_p.numValue) AS Patrons,
    COUNT(DISTINCT th.TransactionID) AS Circs
FROM 
    PolarisTransactions.Polaris.TransactionHeaders th
JOIN 
    PolarisTransactions.Polaris.TransactionDetails td_p
        ON th.TransactionID = td_p.TransactionID
        AND td_p.TransactionSubTypeID = 6
JOIN 
    PolarisTransactions.Polaris.TransactionDetails td_c
        ON th.TransactionID = td_c.TransactionID
        AND td_c.TransactionSubTypeID = 61
LEFT JOIN 
    Polaris.Collections c
        ON c.CollectionID = td_c.numValue
JOIN 
    Polaris.Patrons p
        ON p.PatronID = td_p.numValue
JOIN 
    Polaris.PatronCodes pc
        ON pc.PatronCodeID = p.PatronCodeID
WHERE 
    th.TransactionTypeID = 6001
    AND th.TranClientDate BETWEEN '2023-01-01' AND '2024-01-01' -- change 
GROUP BY 
    pc.Description,
    c.Name
ORDER BY 
    c.Name,
    pc.Description;