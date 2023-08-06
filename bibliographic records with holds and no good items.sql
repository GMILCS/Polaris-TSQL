--This query finds non-suppressed, non-deleted bibs that have active holds, but where the total number of items equals the total number of withdrawn, missing, and lost items: 

SELECT BR.BibliographicRecordID as RecordID 
FROM BibliographicRecords BR (NOLOCK) 
LEFT OUTER JOIN RWRITER_BibDerivedDataView RW (NOLOCK) 
ON BR.BibliographicRecordID = RW.BibliographicRecordID 
WHERE RW.NumberofItems = (RW.NumberWithdrawnItems + RW.NumberLostItems + RW.NumberMissingItems) AND RW.NumberOfItems > 0 
AND RW.NumberActiveHolds > 0 
AND BR.RecordStatusID= 1 AND BR.DisplayInPac = 1 


--If you do not care about whether a bib is suppressed from the PAC, you can delete the last "AND..." from the last line. 
--If you want to include bibs with Claimed Returned items, you can add "+ RW.NumberClaimRetItems" to the end of the terms in the parentheses. 
