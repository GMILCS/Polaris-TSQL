USE [Polaris]
GO
/****** Object:  StoredProcedure [Polaris].[SILS_ClosedBranch_Restore]    Script Date: 18/03/2021 2:13:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jason Tenter
-- Create date: 2020-08-24
-- Description:	This procedure is for re-opening libraries that were managed by the branch closures process.
--              It reactivates holds, and restores branch hours so that picklists will run properly.
--				It was created during the Covid19 closures, to prevent physical materials being shipped to branches without staff.
-- =============================================


ALTER PROCEDURE [Polaris].[SILS_ClosedBranch_Restore] 

AS
BEGIN
	SET NOCOUNT ON;

-- List of Branches to include in the update, based on the Polaris.SILS_ClosedBranch_List table
-- That table also includes exception branches, which this process excludes

CREATE TABLE #LibList (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)

INSERT INTO #LibList
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 AND cb.Restored = 1
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
	AND cb.Restored = 1
    ))



CREATE TABLE #LibListHolds (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)
INSERT INTO #LibListHolds
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 AND cb.Restored = 1 and cb.HoldInactivation = 1
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
	AND cb.Restored = 1
    and cb.HoldInactivation = 1
    ))


-- History of hold inactivations
CREATE TABLE #HoldHist (SysHoldRequestID int)

INSERT INTO #HoldHist
SELECT
    shr.SysHoldRequestID
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN #LibListHolds ll
    on shr.PickupBranchID = ll.OrganizationID
INNER JOIN Polaris.SILS_Hold_Inactivations hi (nolock)
    on shr.SysHoldRequestID = hi.SysholdrequestID
WHERE shr.SysHoldStatusID = 1
GROUP BY shr.SysHoldRequestID

-- These updates will queue the holds to be reactivated by the job 'Hold Request Process Inactive Requests Nightly'
UPDATE shr
SET shr.ActivationDate = Getdate()
FROM Polaris.SysHoldRequests shr
INNER JOIN #HoldHist hl
    on shr.SysholdrequestID = hl.SysholdrequestID

UPDATE hi
SET hi.DateRestored = Getdate()
FROM Polaris.SILS_Hold_Inactivations hi
INNER JOIN #HoldHist hl
    on hi.SysholdrequestID = hl.SysholdrequestID




-- Restore branch hours

UPDATE h
SET h.value = oh.BranchHours
FROM polaris.polaris.OrganizationsPPPP h (nolock)
INNER JOIN #LibList ll
    on h.OrganizationID = ll.OrganizationID
INNER JOIN Polaris.SILS_ClosedBranch_OriginalHours oh (nolock)
	on ll.OrganizationID = oh.OrganizationID
WHERE h.AttrID = 96
and h.Value = 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED'

UPDATE oh
SET oh.RestoredDate = CURRENT_TIMESTAMP
FROM Polaris.SILS_ClosedBranch_OriginalHours oh
INNER JOIN #LibList ll
	on ll.OrganizationID = oh.OrganizationID
INNER JOIN polaris.polaris.OrganizationsPPPP h (nolock)
    on h.OrganizationID = ll.OrganizationID and h.AttrID = 96
WHERE oh.BranchHours is not null and oh.RestoredDate is null
and h.Value != 'MONCLOSED,TUECLOSED,WEDCLOSED,THUCLOSED,FRICLOSED,SATCLOSED,SUNCLOSED'



-- Remove branch from updating list

DELETE FROM cb
FROM Polaris.SILS_ClosedBranch_List cb
INNER JOIN #LibList ll
	on cb.OrganizationID = ll.OrganizationID
WHERE cb.Restored = 1 and cb.Exception != 1

-- Delete exceptions when the restored org is a library
DELETE FROM cb
FROM Polaris.SILS_ClosedBranch_List cb
INNER JOIN Polaris.Organizations o (nolock)
	on o.OrganizationID = cb.OrganizationID
INNER JOIN Polaris.SILS_ClosedBranch_List cbp
	on o.ParentOrganizationID = cbp.OrganizationID and cbp.OrganizationCodeID = 2
	and cbp.Exception != 1 and cbp.Restored = 1
INNER JOIN #LibList ll
	on cbp.OrganizationID = ll.ParentOrganizationID
WHERE cb.Exception = 1 and cb.OrganizationCodeID = 3

-- Delete restored libraries
DELETE FROM cb
FROM Polaris.SILS_ClosedBranch_List cb
INNER JOIN #LibList ll
	on cb.OrganizationID = ll.ParentOrganizationID
WHERE cb.OrganizationCodeID = 2 and cb.Exception != 1 and cb.Restored = 1



DROP TABLE #LibList
DROP TABLE #HoldHist
DROP TABLE #LibListHolds

END