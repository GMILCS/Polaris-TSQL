--potentially large query so filter by Patron Account via "AccountID" or maybe something else like "CreationDate". You could do a quick top 100 to see the available values for your filter. 
SELECT *
FROM [Polaris].[Polaris].[IRRecordStores] IRS (nolock)
  JOIN [Polaris].[Polaris].[IRRecords] IR (nolock)
    ON irs.RecordStoreID = ir.RecordID
  JOIN [Polaris].[Polaris].[IRRecordIndex] IRI (nolock)
    ON ir.RecordStoreID = iri.RecordStoreID
--WHERE AccountID = ''