select distinct br.BibliographicRecordID
from Polaris.polaris.BibliographicRecords br
where br.RecordStatusID = 1
       and br.MARCBibEncodingLevel != '5'
       and br.MARCLanguage = 'eng'
       and exists (
              select 1
              from polaris.polaris.BibliographicTags bt
              join polaris.polaris.BibliographicSubfields bs
                     on bs.BibliographicTagID = bt.BibliographicTagID
              where bt.BibliographicRecordID = br.BibliographicRecordID
                     and bt.TagNumber = 245
AND bt.INDICATORTWO = 0
                     and bs.Subfield = 'a'
                     and (bs.Data like 'a %' OR bs.Data like 'an %' OR bs.Data like 'the %' OR bs.Data like 'd %' OR bs.Data like 'de %' OR bs.Data like 'ye %')
       )
       and NOT exists (
              select 1
              from polaris.polaris.BibliographicTags bt
              join polaris.polaris.BibliographicSubfields bs
                     on bs.BibliographicTagID = bt.BibliographicTagID
              where bt.BibliographicRecordID = br.BibliographicRecordID
                     and bt.TagNumber = 245
AND bt.INDICATORTWO = 0
                     and bs.Subfield = 'a'
                     and (bs.Data like 'a is %' OR bs.Data like 'a to %' OR bs.Data like 'd is for %')
       )