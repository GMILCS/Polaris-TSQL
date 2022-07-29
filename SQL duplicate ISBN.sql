--Finds all bib records that have an ISBN that matches another bib record in your database: 

SELECT DISTINCT BR.bibliographicrecordid AS RecordID 
from polaris.bibliographicRecords BR WITH (NOLOCK) 
join polaris.bibliographicISBNindex BIN1 WITH (NOLOCK) 
ON BIN1.BibliographicrecordID = BR.BibliographicrecordID 
join polaris.bibliographicISBNindex BIN2 WITH (NOLOCK) 
ON (BIN1.bibliographicrecordid <> BIN2.BibliographicrecordID) and 
(BIN1.ISBNstring = BIN2.ISBNstring)
