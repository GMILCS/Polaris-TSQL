
--This brings up again all users who (I'm guessing) modified the ILL. 
--Even if use the th.PolarisUserID (instead of pid.Namme), it does not work.
SELECT ill.ILLRequestID, pid.Name, tt.TransactionTypeDescription, ill.CreationDate
FROM TransactionHeaders AS th WITH (NOLOCK)
JOIN TransactionTypes AS tt WITH (NOLOCK)
ON th.TransactionTypeID = tt.TransactionTypeID
JOIN PolarisUsers AS pid WITH (NOLOCK)
ON th.PolarisUserID = pid.PolarisUserID
JOIN Polaris.ILLRequests AS ill WITH (NOLOCK)
ON th.OrganizationID = ill.PickupBranchID
WHERE th.OrganizationID = 3
AND th.TransactionTypeID = 6034
AND ill.ILLRequestID =  82884
AND th.TranClientDate BETWEEN '2022-06-28 00:00:00' and '2022-06-29 23:59:59'
GROUP BY ill.ILLRequestID, pid.Name, tt.TransactionTypeDescription, ill.CreationDate

--This brings up all users for ATL. Not linked to transaction type.
SELECT ill.ILLRequestID, pid.Name
FROM ILLRequests AS ill WITH (NOLOCK)
JOIN PolarisUsers AS pid WITH (NOLOCK)
ON ill.PickupBranchID = pid.OrganizationID
JOIN TransactionHeaders AS th WITH (NOLOCK)
ON ill.PickupBranchID = th.OrganizationID
WHERE ill.ILLRequestID =  82884
AND th.TransactionTypeID = 6033


--ILLs created at ATL between 7/20-7/25
--Returns two users for each ILL. Basically I can't successfuly link the userID with the creation of the ILL.
SELECT th.PolarisUserID, ill.ILLRequestID
FROM PolarisTransactions.Polaris.TransactionHeaders AS th WITH (NOLOCK)
JOIN Polaris.ILLRequests AS ill WITH (NOLOCK)
ON th.OrganizationID = ill.PickupBranchID
WHERE th.TransactionTypeID = 6033 --ILL request created
--AND th.PolarisUserID = 449--userid responsible for the transaction, but doesn't seem to work
--AND ill.ILLRequestID = 83532 --this does not work, you get everyone who ever touched it
AND th.OrganizationID = 3 --organization id where the transaction originated
AND th.TranClientDate BETWEEN '2022-07-20' AND '2022-07-25' --Seem to need both of these dates. The TranClientDate does not correlate to the Action.
AND ill.CreationDate BETWEEN '2022-07-20' AND '2022-07-25'
GROUP BY ill.ILLRequestID, th.PolarisUserID







SELECT *
FROM TransactionSubTypes;



--You could join the PolarisUsers table and use that to get usernames.
--One caveat that got me - 
	--if you're going to limit between two times, 
	--use the TranClientDate in the TransactionHeaders rather than the TransactionDate. 
	--The TranClientDate is indexed while the TransactionDate isn't.