select th.TranClientDate, pu.Name, w.ComputerName, o.DisplayName
from PolarisTransactions.polaris.TransactionHeaders th
join Polaris.Polaris.PolarisUsers pu on pu.PolarisUserID = th.PolarisUserID
join Polaris.Polaris.Workstations w on w.WorkstationID = th.WorkstationID
join Polaris.Polaris.Organizations o on o.OrganizationID = th.OrganizationID
where TransactionTypeID = 7200 and TranClientDate between '2021-07-01' and '2021-09-15'
order by th.TranClientDate, pu.Name
