--Thank you to Shannon Cole

select 
INVFY.FiscalYearName as FiscalYear,
INVLinSeg.FundAlternativeName AS FundName,
InvLin.BibliographicRecordID AS BibRecordID,
INVLinSegItm.ItemBarcode AS Barcode,
INVLinSegItm.ItemCallNumber AS CallNumber,
INVLinSegItm.ItemStatisticalCode As StatisticalCode,
InvLin.MARCBrowseTitle AS Title,
INVLinSeg.SegmentDestinationOrganizationName AS Branch, 
Invlin.InvoiceLineDiscPriceUnitBase AS DiscountPrice,
COUNT(DISTINCT th.TransactionID) AS transactioncount 
from 
Polaris.RwriterInvoiceFiscalYears INVFY with (nolock)  
left outer join Polaris.RwriterInvHeaderView INVHead with (nolock) on (INVFY.InvoiceID = INVHead.InvoiceID)  
inner join Polaris.RwriterInvlineView InvLin with (NOLOCK) on (INVHead.InvoiceID = InvLin.InvoiceID and INVFY.FiscalYearID = InvLin.FiscalYearID) 
inner join Polaris.RwriterInvlineSegmentView INVLinSeg with (NOLOCK) on (InvLin.InvoiceID = INVLinSeg.InvoiceID and InvLin.InvLineItemID = INVLinSeg.InvLineItemID and INVFY.FiscalYearID = INVLinSeg.FiscalYearID)
LEFT JOIN Polaris.InvLineItemSegments invlis WITH (NOLOCK)ON INVLinSeg.InvLineItemSegmentID = invlis.InvLineItemSegmentID
left outer join Polaris.RwriterLineItemToItemsView INVLinSegItm with (NOLOCK) on (INVLinSeg.InvLineItemSegmentID =INVLinSegItm.InvLineItemSegmentID)  
    LEFT JOIN PolarisTransactions.Polaris.TransactionDetails td WITH (NOLOCK) 
        ON INVLinSegItm.ItemRecordID = td.numvalue
    LEFT JOIN PolarisTransactions.Polaris.TransactionHeaders th WITH (NOLOCK) 
        ON th.TransactionID = td.TransactionID 
        AND th.TransactionTypeID = 6001 
        AND th.TranClientDate BETWEEN '2023-01-01 00:00:00.000' AND '2023-12-31 23:59:59.999'
where 
INVFY.FiscalYearID = 14
AND INVLinSeg.FundName NOT LIKE 'z%'
group by
INVFY.FiscalYearName,
INVLinSeg.FundAlternativeName,
InvLin.BibliographicRecordID,
INVLinSegItm.ItemBarcode,
INVLinSegItm.ItemCallNumber,
InvLin.MARCBrowseTitle,
INVLinSeg.SegmentDestinationOrganizationName,
Invlin.InvoiceLineDiscPriceUnitBase,
INVLinSegItm.ItemStatisticalCode
ORDER by 
FundAlternativeName asc,
BibliographicRecordID asc
