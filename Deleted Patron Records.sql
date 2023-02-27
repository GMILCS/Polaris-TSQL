--I’m going to assume you have transaction logging turned on for Patron registration deleted. (To check, go to SA > Database Tables > Transaction logging and look for the entry)
--If you do, then this should tell you what you need to know.
 
select td.numvalue as PatronID, o.Name as Location,  w.ComputerName, pu.Name as DeletedBy, th.TransactionDate 
from PolarisTransactions.polaris.TransactionHeaders th (nolock)
inner join PolarisTransactions.polaris.TransactionDetails td (nolock)
on td.TransactionID = th.TransactionID and td.TransactionSubTypeID = 6  -- Transactionsubtype 6 is the patron ID
inner join polaris.PolarisUsers pu (nolock)
on pu.PolarisUserID = th.PolarisUserID   -- get Polaris username
inner join polaris.Workstations w (nolock)
on w.WorkstationID = th.WorkstationID   -- get the workstation
inner join polaris.Organizations o (nolock)
on o.OrganizationID = th.OrganizationID   -- get the Org name (assuming you have more than one branch/lib)
Where th.TransactionTypeID =2002   ----- patron registration deleted
and td.numvalue = ###### ---- replace ###### with your patron ID
