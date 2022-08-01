--USE Polaris
SELECT COL.Name AS 'Collection', DatePart(yyyy, getdate()) as 'CurrYear', AVG(BR.PublicationYear) AS 'AvgAge'
INTO #TEMP
FROM polaris.Bibliographicrecords BR
JOIN polaris.CircItemRecords CIR WITH (NOLOCK)
 ON CIR.AssociatedBibrecordID = BR.BibliographicRecordID
JOIN polaris.Collections COL WITH (NOLOCK)
 ON COL.CollectionID = CIR.AssignedCollectionID
GROUP BY COL.Name
Order By COL.Name
SELECT [Collection], AvgAge, CurrYear-AvgAge AS 'CollAge' 
FROM #TEMP
ORDER BY [Collection], AvgAge, CollAge
DROP Table #TEMP
