USE [Polaris]
GO
/****** Object:  StoredProcedure [Polaris].[SILS_Holds_Inactivations]    Script Date: 18/03/2021 2:25:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jason Tenter
-- Create date: 2020-07-21
-- Description:	This procedure is for inactivating hold requests, for branches that are closed for a long period.
--				It was created during the Covid19 closures, to prevent physical materials being shipped to branches without staff.
-- =============================================


ALTER PROCEDURE [Polaris].[SILS_Holds_Inactivations] 

AS
BEGIN
	SET NOCOUNT ON;

DECLARE @ActiveDate datetime = (SELECT DATEADD(ss, -1, CONVERT(Datetime, CONVERT(Date, DATEADD(ww, 2, GETDATE())))))


-- List of Branches to include in the update, based on the Polaris.SILS_ClosedBranch_List table
-- That tabnle also includes exception branches, which this process excludes

CREATE TABLE #LibList (OrganizationID int, ParentOrganizationID int, OrganizationCodeID int)

INSERT INTO #LibList
SELECT o.OrganizationID, o.ParentOrganizationID, o.OrganizationCodeID
FROM Polaris.Organizations o (NOLOCK)
LEFT JOIN Polaris.SILS_ClosedBranch_List cb
    on o.OrganizationID = cb.OrganizationID and cb.OrganizationCodeID = 3
	and cb.Exception != 1 AND cb.HoldInactivation = 1
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
	AND cb.HoldInactivation = 1
    ))

/*
-- Data select query
SELECT 
    op.name "Pickup Branch",
    shs.Name "Hold Status",
    Count(distinct shr.SysHoldRequestID) Holds
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN Polaris.Organizations o (nolock)
    on shr.PickupBranchID = o.OrganizationID    
INNER JOIN Polaris.Organizations op (nolock)
    on o.ParentOrganizationID = op.OrganizationID   
INNER JOIN #LibList ll
    on shr.PickupBranchID = ll.OrganizationID   
INNER JOIN Polaris.SysHoldStatuses shs (nolock)
    on shr.SysHoldStatusID = shs.SysHoldStatusID
WHERE shr.SysHoldStatusID in (3,4)
GROUP BY
    op.name,
    shs.Name
ORDER BY
    op.name,
    shs.Name
*/


-- Narrow the list of holds to adjust
CREATE TABLE #Holds (SysHoldRequestID int, SysHoldStatusID int)
INSERT INTO #Holds
SELECT 
    shr.SysHoldRequestID,
    shr.SysHoldStatusID
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN Polaris.Organizations o (nolock)
    on shr.PickupBranchID = o.OrganizationID    
INNER JOIN Polaris.Organizations op (nolock)
    on o.ParentOrganizationID = op.OrganizationID   
INNER JOIN #LibList ll
    on shr.PickupBranchID = ll.OrganizationID   
WHERE shr.SysHoldStatusID in (3,4)
GROUP BY
    shr.SysHoldRequestID,
    shr.SysHoldStatusID
ORDER BY
    shr.SysHoldRequestID,
    shr.SysHoldStatusID


-----------                     Work through the denial process for all pending holds                     ----------------


-- process for denying unwanted holds
DECLARE @Hold int

DECLARE HoldDenials CURSOR FOR
SELECT
    h.SysholdrequestID
FROM #Holds h
WHERE h.SysHoldStatusID = 4
GROUP BY 
    h.SysholdrequestID

OPEN HoldDenials

FETCH NEXT FROM HoldDenials INTO @Hold

WHILE @@FETCH_STATUS = 0

BEGIN

    INSERT INTO [Polaris].[SILS_HoldDenials_Suspension] ([SysholdrequestID], [ItemRecordID], [DateDenied], [Undenied])
    SELECT
        shr.SysHoldRequestID,
        shr.TrappingItemRecordID,
        GetDate(),
        0
    FROM Polaris.SysHoldRequests shr (nolock)
    WHERE shr.SysHoldRequestID = @Hold
    GROUP BY 
        shr.SysHoldRequestID,
        shr.TrappingItemRecordID

    EXEC Polaris.[Polaris].[Circ_DenyItemForHold]
        @Hold, -8, 0, 255, 2159, 2591
            -- The second variable indicates the denial reason, 3rd does not deny all items, and the remainder provide Jason Tenter's login details for the Transaction log

    FETCH NEXT FROM HoldDenials INTO @Hold

END

CLOSE HoldDenials

DEALLOCATE HoldDenials


-- Track which holds will be undenied
CREATE TABLE #Undenials
(
    [SysholdrequestID] [int],
	[ItemRecordID] [int]
)

INSERT INTO #Undenials
SELECT 
    ra.SysHoldRequestID,
    ra.ItemRecordID
FROM Polaris.SysHoldItemRecordsRTFAvailable ra
INNER JOIN [Polaris].[SILS_HoldDenials_Suspension] hd
    on ra.SysHoldRequestID = hd.SysholdrequestID and ra.ItemRecordID = hd.ItemRecordID and hd.Undenied != 1


-- Undeny the holds
DELETE FROM ra
FROM Polaris.SysHoldItemRecordsRTFAvailable ra
INNER JOIN [Polaris].[SILS_HoldDenials_Suspension] hd
    on ra.SysHoldRequestID = hd.SysholdrequestID and ra.ItemRecordID = hd.ItemRecordID and hd.Undenied != 1


DELETE FROM sc
FROM Polaris.SysHoldItemRecordRTFSecondaryCycles sc
INNER JOIN [Polaris].[SILS_HoldDenials_Suspension] hd
    on sc.SysHoldRequestID = hd.SysholdrequestID and sc.ItemRecordID = hd.ItemRecordID and hd.Undenied != 1


UPDATE hd
SET hd.Undenied = 1
FROM [Polaris].[SILS_HoldDenials_Suspension] hd
INNER JOIN #Undenials u
    on hd.SysholdrequestID = u.SysholdrequestID
WHERE hd.Undenied != 1
AND hd.DateDenied > DATEADD(hh, -1, GETDATE())  -- arbitrary time, to make sure we're deleting what's appropriate, and flagging as such



-- Update all active holds in the hold list; should now include the previously pending holds
UPDATE shr
SET shr.SysHoldStatusID = 1,
    shr.ActivationDate = @ActiveDate
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN #Holds h
    on shr.SysHoldRequestID = h.SysHoldRequestID
WHERE shr.SysHoldStatusID = 3

INSERT INTO [Polaris].[SILS_Hold_Inactivations] ([SysholdrequestID],[DateInactivated])
SELECT
	shr.SysHoldRequestID,
	GetDate()
FROM Polaris.SysHoldRequests shr (nolock)
INNER JOIN #Holds h
    on shr.SysHoldRequestID = h.SysHoldRequestID


DROP TABLE #LibList
DROP TABLE #Holds
DROP TABLE #Undenials

END
