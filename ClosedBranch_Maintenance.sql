USE [Polaris]
GO
/****** Object:  StoredProcedure [Polaris].[SILS_ClosedBranch_Maintenance]    Script Date: 18/03/2021 2:13:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jason Tenter
-- Create date: 2020-08-04
-- Description:	This procedure is for removing hold routing, and pushing forward checkout due dates/hold unclaimed dates, for branches that are closed for a long period.
--				It was created during the Covid19 closures, to prevent physical materials being shipped to branches without staff.
-- =============================================


ALTER PROCEDURE [Polaris].[SILS_ClosedBranch_Maintenance] 

AS
BEGIN
	SET NOCOUNT ON;

DECLARE @NewDate datetime = (SELECT DATEADD(ss, -1, CONVERT(Datetime, CONVERT(Date, DATEADD(ww, 2, GETDATE())))))


-- List of Branches to include in the update, based on the Polaris.SILS_ClosedBranch_List table
-- That table also includes exception branches, which this process excludes

-- Hold Routing updating branches - includes all DatesCloded branches
CREATE TABLE #LibList (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)
INSERT INTO #LibList
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 and cb.DatesClosed = 1
LEFT JOIN Polaris.SILS_ClosedBranch_List cbe -- Exceptions
    on o.OrganizationID = cbe.OrganizationID and cbe.OrganizationCodeID = 3
	and cbe.Exception = 1
WHERE o.OrganizationCodeID = 3
AND cbe.OrganizationID is NULL
AND (cb.OrganizationID is not null
OR o.ParentOrganizationID IN 
    (SELECT 
        cb.OrganizationID
    FROM Polaris.SILS_ClosedBranch_List cb
    WHERE cb.OrganizationCodeID = 2
    ))

-- Due Date updating branches
CREATE TABLE #LibListDue (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)
INSERT INTO #LibListDue
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 AND cb.DueDates = 1 -- specifies due date updating
LEFT JOIN Polaris.SILS_ClosedBranch_List cbe -- Exceptions
    on o.OrganizationID = cbe.OrganizationID and cbe.OrganizationCodeID = 3
	and cbe.Exception = 1
WHERE o.OrganizationCodeID = 3
AND cbe.OrganizationID is NULL
AND (cb.OrganizationID is not null
OR o.ParentOrganizationID IN 
    (SELECT 
        cb.OrganizationID
    FROM Polaris.SILS_ClosedBranch_List cb
    WHERE cb.OrganizationCodeID = 2
    AND cb.DueDates = 1 
    ))

-- Hold Unclaimed date updating branches
CREATE TABLE #LibListHold (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)

INSERT INTO #LibListHold
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 AND cb.HoldUntilDates = 1 -- specifies hold unclaimed dates updating
LEFT JOIN Polaris.SILS_ClosedBranch_List cbe -- Exceptions
    on o.OrganizationID = cbe.OrganizationID and cbe.OrganizationCodeID = 3
	and cbe.Exception = 1
WHERE o.OrganizationCodeID = 3
AND cbe.OrganizationID is NULL
AND (cb.OrganizationID is not null
OR o.ParentOrganizationID IN 
    (SELECT 
        cb.OrganizationID
    FROM Polaris.SILS_ClosedBranch_List cb
    WHERE cb.OrganizationCodeID = 2
    AND cb.DueDates = 1 
    ))


-- Update branch closed days
-- Add to backup table, then update the branch hours to be closed
INSERT INTO Polaris.SILS_ClosedBranch_OriginalHours (OrganizationID, BranchHours, AddedDate)
SELECT 
	h.OrganizationID,
	h.Value,
	CURRENT_TIMESTAMP
FROM polaris.polaris.OrganizationsPPPP h (nolock)
INNER JOIN #LibList ll
    on h.OrganizationID = ll.OrganizationID
LEFT JOIN Polaris.SILS_ClosedBranch_OriginalHours oh
	on h.OrganizationID = oh.organizationid
		AND oh.RestoredDate IS NULL
WHERE h.AttrID = 96
and h.Value != 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED'
and oh.organizationid is null

UPDATE h
SET h.value = 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED'
FROM polaris.polaris.OrganizationsPPPP h (nolock)
INNER JOIN #LibList ll
    on h.OrganizationID = ll.OrganizationID
WHERE h.AttrID = 96
and h.Value != 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED'


-- Update overdue settings on checkouts, if there are any
UPDATE ic
SET ic.OVDNoticeCount = 0, 
    ic.OVDNoticeDate = NULL
FROM Polaris.ItemCheckouts ic
INNER JOIN Polaris.Organizations o (nolock)
    on ic.OrganizationID = o.OrganizationID
INNER JOIN #LibListDue ll
    on o.OrganizationID = ll.OrganizationID
WHERE ic.dueDate BETWEEN '2020-03-01' AND @NewDate
and ic.OVDNoticeCount != 0

-- Update due dates
UPDATE ic
SET ic.dueDate = @NewDate
FROM Polaris.ItemCheckouts ic
INNER JOIN Polaris.Organizations o (nolock)
    on ic.OrganizationID = o.OrganizationID
INNER JOIN #LibListDue ll
    on o.OrganizationID = ll.OrganizationID
WHERE ic.dueDate BETWEEN '2020-03-01' AND @NewDate


-- Update hold unclaimed dates
UPDATE shr
SET shr.HoldTillDate = @NewDate
FROM Polaris.SysHoldRequests shr
INNER JOIN Polaris.Organizations o (nolock)
    on shr.PickupBranchID = o.OrganizationID
INNER JOIN #LibListHold ll
    on o.OrganizationID = ll.OrganizationID
WHERE shr.SysHoldStatusID = 6
AND shr.HoldTillDate < @NewDate


DROP TABLE #LibList
DROP TABLE #LibListDue
DROP TABLE #LibListHold

END
