Yes, those are the parameters you would have to change.  You can find collection and statistical code ids in Administration.  Go to Administration—Collection, search for your collection and then right-click and open the collection.  The Collection ID number will be in the Title Bar.  It is also available by checking the File—Properties, About tab.  It’s listed as ‘Polaris ID number.’  Statistical codes are available in System—Policy Tables—Item Statistical Class Codes.  When you double-click a line in that table, you will get the statistical code id in the Title Bar.
 
You can also use SQL to look up all of your collection and statistical codes.  I printed those out and tacked them to my bulletin board since I use them so much.
 
Or you could just eliminate some of those parameters completely—some libraries don’t use the stat class code for much.
 
Chris
 
Chris Accardo
Assistant Director
Weatherford Public Library
1014 Charles Street
Weatherford, TX  76086
817.598.4158
caccardo@weatherfordtx.gov
www.wpltx.com
 
From: Jeff Gentry [mailto:bounce-Jeff_Gentry@polarislibrary.com] 
Sent: Wednesday, May 02, 2012 11:31 AM
To: Chris Accardo
Subject: RE: [Polaris General Forum] help with top 10 lists
 
Hi Chris,
Won’t the id numbers in these lines vary from library to library. I know my assigned branch id =3 and not 9, for example
 
where th.transactiontypeid=6001 
and td.transactionsubtypeid=38 
and cir.statisticalcodeid=110
 
Where do we go find ID numbers? In Administration? 
 
Jeff Gentry
Flower Mound Library
 
 
From: Chris Accardo [mailto:bounce-Chris_Accardo@polarislibrary.com] 
Sent: Wednesday, May 02, 2012 11:01 AM
To: Jeff Gentry
Subject: RE: [Polaris General Forum] help with top 10 lists
 
If you run this in the SQL find tool, you will get the top 10 bib records associated with items having a particular statistical code, collection code, and owning library.  This totals up all of the circs for all items associated with the bib record that meet the criteria you set:
 
SELECT BR.BibliographicRecordID as RecordID
from bibliographicrecords br (nolock)
where br.bibliographicrecordID in
(select top 10 cir.associatedbibrecordid 
from PolarisTransactions.Polaris.TransactionHeaders TH (nolock)
JOIN PolarisTransactions.Polaris.TransactionDetails TD (nolock)
on th.Transactionid = td.transactionid
JOIN Polaris.CircItemRecords CIR (nolock)
on CIR.ItemRecordID=TD.numvalue
JOIN Polaris.bibliographicrecords br (nolock)
on CIR.AssociatedBibRecordID=BR.BibliographicRecordID
where th.transactiontypeid=6001 
and td.transactionsubtypeid=38 
and th.transactiondate > '04-01-2012'
and th.transactiondate < '05-01-2012'
and cir.assignedbranchid=9
and cir.assignedcollectionid=6
and cir.statisticalcodeid=110
group by cir.associatedbibrecordid, BR.LifetimeCircCount
order by count(th.Transactionid) DESC, BR.LifetimeCircCount DESC)
 
Chris
 
Chris Accardo
Assistant Director
Weatherford Public Library
1014 Charles Street
Weatherford, TX  76086
817.598.4158
caccardo@weatherfordtx.gov
www.wpltx.com
 
From: Ginger Olson [mailto:bounce-Ginger_Olson@polarislibrary.com] 
Sent: Tuesday, May 01, 2012 1:09 PM
To: Chris Accardo
Subject: [Polaris General Forum] help with top 10 lists
 
I am looking for a report of the 10 most popular titles in a collection.  I thought I had seen this request in the  past but am not finding it anywhere and am stumped on how to go about this.  I’d like to do this with simply reports if possible.
 
Ginger Olson
Head of Circulation
Rochester Hills Public Library
500 Olde Towne Rd
Rochester, MI 48307
 
248-650-7162
ginger.olson@rhpl.org
 
 
 
________________________________________

Weatherford is a family focused community known for valuing historic traditions while planning for the future. It is a safe, livable city with a healthy economy that recognizes the importance of working with citizens and local partners.

This message (and any associated files) is intended only for the use of the individual or entity to which it is addressed and may contain information that is confidential, or subject to copyright. If you are not the intended recipient you are hereby notified that any dissemination, copying or distribution of this message, or files associated with this message, is strictly prohibited. If you have received this message in error, please notify us immediately by replying to the message and deleting it from your computer. Messages sent to and from the City of Weatherford may be monitored.

Internet communications cannot be guaranteed to be secure or error-free as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete, or contain viruses. Therefore, we do not accept responsibility for any errors or omissions that are present in this message, or any attachment, that have arisen as a result of e-mail transmission. If verification is required, please request a hard-copy version. Any views or opinions presented are solely those of the author and do not necessarily represent those of the City of Weatherford.



--
View this message online at: http://forums.polarislibrary.com/forums/p/3710/16064.aspx#16064
--
