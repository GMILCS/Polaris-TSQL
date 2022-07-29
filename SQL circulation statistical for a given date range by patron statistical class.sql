
DECLARE @CircTrans TABLE (
   TransID INTEGER,
   MatType INTEGER,
   PSCCode INTEGER,
   PatrBrn INTEGER,
   ColCode INTEGER,
   IsRenew INTEGER
  );
  
INSERT INTO @CircTrans (TransID, MatType) SELECT TH.TransactionID,
       TD.numValue
FROM   PolarisTransactions.Polaris.TransactionDetails TD
JOIN   PolarisTransactions.Polaris.TransactionHeaders TH
    ON TH.TransactionID = TD.TransactionID WHERE  TH.TransactionTypeID = 6001
AND    TD.TransactionSubTypeID = 4
AND    TH.TranClientDate >= @StartDate
AND    TH.TranClientDate 
;

UPDATE @CircTrans
SET    PSCCode = TD.numValue
FROM   PolarisTransactions.Polaris.TransactionDetails TD
WHERE  TD.TransactionID = TransID
AND    TD.TransactionSubTypeID = 7
;

UPDATE @CircTrans
SET    PatrBrn = TD.numValue
FROM   PolarisTransactions.Polaris.TransactionDetails TD
WHERE  TD.TransactionID = TransID
AND    TD.TransactionSubTypeID = 123
;

UPDATE @CircTrans
SET    ColCode = TD.numValue
FROM   PolarisTransactions.Polaris.TransactionDetails TD
WHERE  TD.TransactionID = TransID
AND    TD.TransactionSubTypeID = 61
;
UPDATE @CircTrans
SET    IsRenew = TD.numValue
FROM   PolarisTransactions.Polaris.TransactionDetails TD
WHERE  TD.TransactionID = TransID
AND    TD.TransactionSubTypeID = 124
;


SELECT    COUNT(CT.TransID) AS 'Circulations',
          O.[Name]          AS 'Organization',
          PSC.[Description] AS 'PatronStatCode',
          M.[Description]   AS 'MaterialType',
          C.[Name]          AS 'Collection',
          CT.IsRenew        AS 'IsRenewal'
FROM      @CircTrans CT
LEFT JOIN Polaris.PatronStatClassCodes PSC
       ON PSC.StatisticalClassID = CT.PSCCode
      AND PSC.OrganizationID = CT.PatrBrn LEFT JOIN Polaris.MaterialTypes M
       ON M.MaterialTypeID = CT.MatType
LEFT JOIN Polaris.Collections C
       ON C.CollectionID = CT.ColCode
JOIN      Polaris.Organizations O
       ON O.OrganizationID = CT.PatrBrn
GROUP BY CT.PatrBrn, CT.PSCCode, PSC.[Description],
         CT.MatType, CT.IsRenew, M.[Description],
         C.[Name], O.[Name]
;
