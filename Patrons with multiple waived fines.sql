--Here is a kind of complicated query that will give you a list of patrons with waives on more than one date, and how many dates they had waives on.


Select t2.NAME, t2.IDcount as [DATES]


from


(Select COUNT(t1.ID) as IDcount, t1.PatronFullName as NAME


from


(SELECT PR.PatronID as ID


,PR.PatronFullName


,CONVERT(VARCHAR(12),PA.TxnDate,101)AS [DATE]


,COUNT(PA.TxnID) as TxnCount


FROM Polaris.Polaris.PatronAccount pa WITH (NOLOCK)


JOIN Polaris.PatronRegistration pr WITH (NOLOCK) ON PR.PatronID = PA.PatronID


WHERE PA.TxnCodeID IN (5)


AND PA.TxnDate between '01/01/2014' and '04/30/2015'


GROUP BY PR.PatronID, PR.PatronFullName, CONVERT(VARCHAR(12),PA.TxnDate,101))as t1


GROUP BY t1.PatronFullName) as t2


where t2.IDcount > 1


ORDER BY t2.NAME

--There are three layers to the query.  The inner query finds patron names and dates (and groups multiple transactions on the same date), the middle one gets a count of patron IDs that are retrieved in the inner query, and the outer one lets you select based on how many times the patron ID shows up (The DATES column) in this case, more than once.

--You can omit the line that starts with AND PA.TxnDate... if you want to get all patrons you have patron account information on, or modify the dates to get a desired range.

--You can get more information in your final output, like the patron's barcode number, but I think you will need to add it to each layer.

--There may be (and I wouldn't be surprised if there is) a more efficient way to do this, but this may be a good start.
