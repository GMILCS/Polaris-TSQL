--Hello Does anyone have a report that will list the top 100 circulating 
--titles (with circ total) within last 365 days by collection or format?
-- Or, is there a way in Simply Reports to produce this report? Any help 
--is appreciated. We are on 3.5, build 455.

--I think I have something along those lines...

--This will have to be modified, since it has some things in it specific to our site (e.g., which stat codes are in each category).  But it could serve as a starting point.  --Hopefully the mailing list software won't censor it too badly...

DECLARE @SomeWhileAgo DATETIME;
SET     @SomeWhileAgo = DATEADD(Year, -1, GETDATE());

DECLARE @result TABLE (
    BibID INTEGER,
    Genre VARCHAR(20),
    SubGenre VARCHAR(50),
    Circs INTEGER,
    Items INTEGER
);
DECLARE @bib  TABLE (
    BibID INTEGER,
    Circs INTEGER,
    Items INTEGER,
    CallNo VARCHAR(50),
    Genre VARCHAR(50)
);
DECLARE @item TABLE (
    ItemID INTEGER,
    Circs INTEGER,
    StatCode INTEGER,
    Genre VARCHAR(50)
);

INSERT  INTO @item (ItemID, Circs, StatCode) SELECT  I.ItemRecordID AS 'ItemID',
    (
        SELECT  COUNT(*)
        FROM    PolarisTransactions.Polaris.TransactionDetails XD
        JOIN    PolarisTransactions.Polaris.TransactionHeaders XH ON XH.TransactionID = XD.TransactionID
        WHERE   XD.TransactionSubTypeID = 38
        AND     XD.numValue = I.ItemRecordID
        AND     XH.TransactionTypeID = 6001
        AND     XH.TranClientDate >= @SomeWhileAgo
    ) AS 'Circs',
    I.StatisticalCodeID AS 'StatCode'
FROM    Polaris.CircItemRecords I(NOLOCK);

INSERT    INTO @bib (BibID, Circs, Items, CallNo)
SELECT    B.BibliographicRecordID AS 'BibID',
    (SUM(X.Circs)) AS 'Circs',
    (COUNT(X.Circs)) AS 'Items',
    B.BrowseCallNo AS 'CallNo'
FROM    Polaris.BibliographicRecords B(NOLOCK)
JOIN    Polaris.CircItemRecords I(NOLOCK) ON I.AssociatedBibRecordID = B.BibliographicRecordID
JOIN    @item X ON X.ItemID = I.ItemRecordID
GROUP    BY B.BibliographicRecordID, B.BrowseCallNo
;

UPDATE    @bib
SET    Genre =
(SELECT  TOP 1
         S.[Description] AS 'Genre'
 FROM    Polaris.CircItemRecords I
 JOIN    Polaris.StatisticalCodes S ON S.StatisticalCodeID = I.StatisticalCodeID
 WHERE   I.AssociatedBibRecordID = BibID);

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items) SELECT TOP 200
       X.BibID AS 'BibID',
       'Adult Fiction' AS 'Genre',
       X.Genre AS 'SubGenre',
       X.Circs AS Circs,
       X.Items AS Items
FROM   @bib X
WHERE  ((
        SELECT  COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE   XI.AssociatedBibRecordID = X.BibID
        AND     XI.StatisticalCodeID IN (101, 102, 103, 104,
                         141, 142, 143, 144, 145,
                         151, 152, 153, 170)
     ) > 0)
ORDER BY X.Circs DESC;

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items) SELECT  TOP 200
        X.BibID AS 'BibID',
        'Adult Non-Fiction' AS 'Genre',
        X.CallNo AS 'SubGenre',
        X.Circs AS Circs,
        X.Items AS Items
FROM    @bib X
WHERE   ((
        SELECT  COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE   XI.AssociatedBibRecordID = X.BibID
        AND     XI.StatisticalCodeID IN (110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
                         120, 149, 158, 159,
                         160, 161, 162, 163, 164, 165, 166, 167, 168, 169)
     ) > 0)
ORDER BY X.Circs DESC;

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items) SELECT TOP 100
       X.BibID AS 'BibID',
       'Adult Audiobook' AS 'Genre',
       X.CallNo AS 'SubGenre',
       X.Circs AS Circs,
       X.Items AS Items
FROM   @bib X
WHERE  ((
        SELECT  COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE   XI.AssociatedBibRecordID = X.BibID
        AND     XI.StatisticalCodeID IN (201, 202, 203, 204)
     ) > 0)
ORDER BY X.Circs DESC;

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items)
SELECT    TOP 40
    X.BibID AS 'BibID',
    'Adult Periodical' AS 'Genre',
    X.CallNo AS 'SubGenre',
    X.Circs AS Circs,
    X.Items AS Items
FROM    @bib X
WHERE    ((
        SELECT    COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE    XI.AssociatedBibRecordID = X.BibID
        AND    XI.StatisticalCodeID IN (250)
     ) > 0)
ORDER BY X.Circs DESC;

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items) SELECT TOP 100
       X.BibID AS 'BibID',
       'Adult Music' AS 'Genre',
       X.CallNo AS 'SubGenre',
       X.Circs AS Circs,
       X.Items AS Items
FROM    @bib X
WHERE    ((
        SELECT  COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE   XI.AssociatedBibRecordID = X.BibID
        AND     XI.StatisticalCodeID IN (211, 212)
     ) > 0)
ORDER BY X.Circs DESC;

INSERT INTO @result (BibID, Genre, SubGenre, Circs, Items) SELECT TOP 100
       X.BibID AS 'BibID',
       'Adult Movies' AS 'Genre',
       X.CallNo AS 'SubGenre',
       X.Circs AS Circs,
       X.Items AS Items
FROM   @bib X
WHERE  ((
        SELECT  COUNT(*)
        FROM    Polaris.CircItemRecords XI(NOLOCK)
        WHERE   XI.AssociatedBibRecordID = X.BibID
        AND     XI.StatisticalCodeID IN (221, 222)
     ) > 0)
ORDER BY X.Circs DESC;

SELECT X.Genre AS 'Page'
 ,     X.SubGenre AS 'Genre'
 ,     B.BrowseTitle AS 'Title'
 ,     B.BrowseAuthor AS 'Author'
 ,     X.Circs
 ,     X.Items
 ,     (CAST(X.Circs AS FLOAT) / CAST(X.Items AS FLOAT)) AS 'CPI'
FROM   @result X
JOIN   Polaris.BibliographicRecords B(NOLOCK) ON B.BibliographicRecordID = X.BibID
;
