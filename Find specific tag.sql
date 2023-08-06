--Find Tool
--From the Bib Find Tool and using the SQL option you could paste the following into it.  Replace the "TAG_HERE" with the tag you want to search for and click on the Search button.  This will return Bibs with an instance of that tag in it.  If this is something you'll use then click on Save As and name it then you'll have it whenever you need it.

SELECT BibliographicRecordID as recordid
FROM Polaris.BibliographicTags with (nolock)
WHERE EffectiveTagNumber=--TAG_HERE
