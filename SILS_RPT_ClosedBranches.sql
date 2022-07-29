USE [Polaris]
GO
/****** Object:  StoredProcedure [Polaris].[SILS_RPT_ClosedBranches]    Script Date: 18/03/2021 2:31:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jason Tenter
-- Create date: 2020-08-06
-- Description:	A report tracking details managed for branches remaining or temporarily closed during the C19 pandemic
-- =============================================


ALTER PROCEDURE [Polaris].[SILS_RPT_ClosedBranches] 

AS
BEGIN
	SET NOCOUNT ON;


CREATE TABLE #LibList (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)
INSERT INTO #LibList
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1
LEFT JOIN Polaris.SILS_ClosedBranch_List cbe -- Exceptions
    on o.OrganizationID = cbe.OrganizationID and cbe.OrganizationCodeID = 3
	and cbe.Exception = 1
WHERE o.OrganizationCodeID = 3
AND cbe.OrganizationID is NULL
AND o.name not like '%- PAC'
AND o.name not like '%- Online'
AND (cb.OrganizationID is not null
OR o.ParentOrganizationID IN 
    (SELECT 
        cb.OrganizationID
    FROM Polaris.SILS_ClosedBranch_List cb
    WHERE cb.OrganizationCodeID = 2
    ))


-- History for finding and counting hold inactivations
CREATE TABLE #HoldList (SysHoldRequestID int, PickupBranchID int)

-- Daily history, then earlier history if there wasn't an update today
INSERT INTO #HoldList
SELECT
    shr.SysHoldRequestID,
    shr.PickupBranchID
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN Polaris.SILS_Hold_Inactivations hi
    on shr.SysHoldRequestID = hi.SysholdrequestID
WHERE shr.SysHoldStatusID = 1
    and hi.DateRestored is null
GROUP BY 
    shr.SysHoldRequestID,
    shr.PickupBranchID


CREATE TABLE #Settings
(
    OrganizationID int,
    HoldInactivation bit,
    HoldUntilDates bit,
    DueDates bit,
    HoldRouting bit
)

INSERT INTO #Settings
SELECT 
    ll.OrganizationID,
    cb.HoldInactivation,
    cb.HoldUntilDates,
    cb.DueDates,
    cb.DatesClosed
FROM #LibList ll (nolock)
INNER JOIN Polaris.SILS_ClosedBranch_List cb (nolock)
    on ll.OrganizationID = cb.OrganizationID

INSERT INTO #Settings
SELECT 
    ll.OrganizationID,
    cbp.HoldInactivation,
    cbp.HoldUntilDates,
    cbp.DueDates,
    cbp.DatesClosed
FROM #LibList ll (nolock)
INNER JOIN Polaris.SILS_ClosedBranch_List cbp (nolock)
    on ll.ParentOrganizationID = cbp.OrganizationID


CREATE TABLE #Checkouts
(
    OrganizationID int,
    Checkouts int,
    EarliestDueDate datetime
)

INSERT INTO #Checkouts
SELECT
    ll.OrganizationID,
    ISNULL(Count(DISTINCT ic.ItemRecordID),0) Checkouts,
    MIN(ic.DueDate) EarliestDueDate
FROM #LibList ll (nolock)
LEFT JOIN Polaris.ItemCheckouts ic (nolock)
    on ll.OrganizationID = ic.OrganizationID and ic.duedate > '2020-03-01'
GROUP BY ll.OrganizationID


CREATE TABLE #HeldHolds
(
    OrganizationID int,
    HeldHolds int,
    EarliestUnclaimedDate datetime
)

INSERT INTO #HeldHolds
SELECT
    ll.OrganizationID,
    ISNULL(COUNT(DISTINCT shrh.SysHoldRequestID),0) HeldHolds,
    MIN(shrh.HoldTillDate) EarliestUnclaimedDate
FROM #LibList ll (nolock)
LEFT JOIN Polaris.SysHoldRequests shrh (nolock) -- held holds
    on ll.OrganizationID = shrh.PickupBranchID and shrh.SysHoldStatusID = 6
GROUP BY ll.OrganizationID


SELECT
    o.OrganizationID,
    o.Name,
    s.HoldInactivation,
    s.HoldUntilDates,
    s.DueDates,
    s.HoldRouting,
    co.Checkouts,
    co.EarliestDueDate,
    hh.HeldHolds,
    hh.EarliestUnclaimedDate,
    ISNULL(count(distinct hl.SysHoldRequestID),0) InactiveHolds,
    CASE 
		WHEN h.Value = 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED' then 'Closed'
		ELSE ''
	END AS BranchClosed

FROM #LibList ll (nolock)
INNER JOIN polaris.Organizations o (nolock)
    on o.OrganizationID = ll.OrganizationID
LEFT JOIN #Settings s 
    on ll.OrganizationID = s.OrganizationID
left join polaris.polaris.OrganizationsPPPP h (nolock)
	on h.OrganizationID = ll.OrganizationID and h.AttrID = 96
LEFT JOIN #HeldHolds hh (nolock) -- held holds
    on ll.OrganizationID = hh.OrganizationID
LEFT JOIN #Checkouts co
    on ll.OrganizationID = co.OrganizationID
LEFT JOIN #HoldList hl -- Inactive holds
    on ll.OrganizationID = hl.PickupBranchID
GROUP BY
    o.OrganizationID,
    o.Name,
    s.HoldInactivation,
    s.HoldUntilDates,
    s.DueDates,
    s.HoldRouting,
    co.Checkouts,
    co.EarliestDueDate,
    hh.HeldHolds,
    hh.EarliestUnclaimedDate,
    CASE 
		WHEN h.Value = 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED' then 'Closed'
		ELSE ''
	END
ORDER BY o.Name


DROP TABLE #LibList
DROP TABLE #HoldList
DROP TABLE #Settings
DROP TABLE #Checkouts
DROP TABLE #HeldHolds

END
