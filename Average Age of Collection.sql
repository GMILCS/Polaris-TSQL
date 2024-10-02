--USE Polaris
WITH AvgPublicationYear AS (
    SELECT 
        COL.Name AS Collection, 
        DatePart(yyyy, GETDATE()) AS CurrYear,
        AVG(CAST(BR.PublicationYear AS FLOAT)) AS AvgAge
    FROM 
        polaris.BibliographicRecords BR
    JOIN 
        polaris.CircItemRecords CIR 
        ON CIR.AssociatedBibRecordID = BR.BibliographicRecordID
    JOIN 
        polaris.Collections COL 
        ON COL.CollectionID = CIR.AssignedCollectionID
    GROUP BY 
        COL.Name
)
SELECT 
    Collection, 
    AvgAge, 
    CurrYear - AvgAge AS CollAge
FROM 
    AvgPublicationYear
ORDER BY 
    Collection, 
    AvgAge, 
    CollAge;
