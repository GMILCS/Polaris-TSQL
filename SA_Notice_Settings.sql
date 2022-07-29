
--Jason Tenter (Library System Administrator) from Saskatchewan Information and Library Services shared with us a fantastic report on hunting down their notification settings. I've added the details below and attached the script to the post.

--a report on notification settings at the system, library, and branch-level (if the branch's settings don't match the library). I think the code should be ready for any environment...
--use Polaris

DROP TABLE IF EXISTS #Attrs
DROP TABLE IF EXISTS #AttrVal
DROP TABLE IF EXISTS #BranchDiffs
DROP TABLE IF EXISTS #Orgs


CREATE TABLE #Attrs (AttrID int)
INSERT INTO #Attrs
VALUES  (2699),
        (2149),
        (2150),
        (2152),
        (2151),
        (1971),
        (3081),
        (3080),
        (2696),
        (2144),
        (2145),
        (2147),
        (2146),
        (2697),
        (2188),
        (2698),
        (2189),
        (2351),
        (2701),
        (2702),
        (2341),
        (2165),
        (3029),
        (3030),
        (3028),
        (2268),
        (2269),
        (2271),
        (2265),
        (2264),
        (2270),
        (2272),
        (2273),
        (2267),
        (2275),
        (3180),
        (480),
        (2703),
        (3078),
        (3079),
        (1276),
        (1613),
        (1615),
        (1869),
        (1270),
        (1269),
        (1611),
        (1272),
        (1621),
        (1277),
        (1612),
        (1275),
        (1610),
        (2143),
        (1614),
        (3027),
        (2141),
        (1693),
        (2274),
        (2695),
        (998),
        (995),
        (996),
        (997),
        (2139)


CREATE TABLE #Orgs
(
    [Key] int,
    OrganizationID int,
    [Name] nvarchar(50),
    Org_Level int
)

INSERT INTO #Orgs
SELECT
    1,
    o.OrganizationID,
    o.name,
    o.OrganizationCodeID
FROM Polaris.Organizations o (nolock)
ORDER BY
    o.OrganizationCodeID,
    o.OrganizationID


CREATE TABLE #AttrVal
(
    [Key] int,
    OrganizationID int,
    Org_Level int,
    AttrID int,
    [Value] varchar(255),
    [Default] bit
)

INSERT INTO #AttrVal
select
    1,
    1,
    1,
    aa.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN aa.DefaultValue
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        ELSE 0
    END
FROM polaris.AdminAttributes aa (nolock)
INNER JOIN #Attrs a
    on aa.AttrID = a.AttrID
LEFT join polaris.OrganizationsPPPP oPP (nolock)
    on aa.AttrID = opp.AttrID
        and opp.OrganizationID = 1
Group BY
    aa.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN aa.DefaultValue
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        ELSE 0
    END
Order BY
    aa.AttrID


INSERT INTO #AttrVal
select
    1,
    o.OrganizationID,
    o.Org_Level,
    a.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN a.[Value]
        WHEN a.AttrID = 1272 AND oPP.[Value] like '%<%>%' THEN 
            TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1))
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        ELSE 0
    END
FROM #Orgs o
INNER JOIN #AttrVal a
    on o.[Key] = a.[Key]
LEFT JOIN 
(
    SELECT
        o.OrganizationID,
        opp.AttrID,
        opp.[Value]
    FROM Polaris.Organizations o (nolock)
    INNER JOIN polaris.OrganizationsPPPP oPP (nolock)
        on o.OrganizationID = opp.OrganizationID
    INNER JOIN #Attrs a
        on opp.AttrID = a.AttrID
    WHERE o.OrganizationCodeID = 2
    GROUP BY
        o.OrganizationID,
        opp.AttrID,
        opp.[Value]
) opp
    on opp.AttrID = a.AttrID
        and opp.OrganizationID = o.OrganizationID
WHERE o.Org_Level = 2
Group BY
    o.OrganizationID,
    o.Org_Level,
    a.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN a.[Value]
        WHEN a.AttrID = 1272 AND oPP.[Value] like '%<%>%' THEN 
            TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1))
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        ELSE 0
    END
Order BY
    o.OrganizationID,
    a.AttrID

--SELECT * FROM #AttrVal WHERE Org_Level = 2


INSERT INTO #AttrVal
select
    1,
    o.OrganizationID,
    o.Org_Level,
    a.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN a.[Value]
        WHEN a.AttrID = 1272 AND oPP.[Value] like '%<%>%' THEN 
            TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1))
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        WHEN oPP.[Value] = a.[Value] THEN 1
        WHEN oPP.[Value] like '%<%>%' THEN CASE 
            WHEN a.[Value] = TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1)) THEN 1
            ELSE 0 END
        ELSE 0
    END
FROM #Orgs o
INNER JOIN Polaris.Organizations op (nolock)
    on o.OrganizationID = op.OrganizationID
INNER JOIN #AttrVal a
    on o.[Key] = a.[Key]
        and a.Org_Level = 2
        and op.ParentOrganizationID = a.OrganizationID
LEFT JOIN 
(
    SELECT
        o.OrganizationID,
        o.ParentOrganizationID,
        opp.AttrID,
        opp.[Value]
    FROM Polaris.Organizations o (nolock)
    INNER JOIN polaris.OrganizationsPPPP oPP (nolock)
        on o.OrganizationID = opp.OrganizationID
    INNER JOIN #Attrs a
        on opp.AttrID = a.AttrID
    WHERE o.OrganizationCodeID = 3
    GROUP BY
        o.OrganizationID,
        o.ParentOrganizationID,
        opp.AttrID,
        opp.[Value]
) opp
    on opp.AttrID = a.AttrID
        and opp.OrganizationID = o.OrganizationID
        and opp.ParentOrganizationID = a.OrganizationID
WHERE o.Org_Level = 3
Group BY
    o.OrganizationID,
    o.Org_Level,
    a.AttrID,
    CASE
        WHEN oPP.[Value] IS NULL THEN a.[Value]
        WHEN a.AttrID = 1272 AND oPP.[Value] like '%<%>%' THEN 
            TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1))
        ELSE oPP.[Value] 
    END,
    CASE
        WHEN oPP.[Value] IS NULL THEN 1
        WHEN oPP.[Value] = a.[Value] THEN 1
        WHEN oPP.[Value] like '%<%>%' THEN CASE 
            WHEN a.[Value] = TRIM(SUBSTRING(oPP.[Value], CHARINDEX('<', oPP.[Value])+1, CHARINDEX('>', oPP.[Value])-CHARINDEX('<', oPP.[Value])-1)) THEN 1
            ELSE 0 END
        ELSE 0
    END
Order BY
    o.OrganizationID,
    a.AttrID

-- Remove branches that have different values than their parents
CREATE TABLE #BranchDiffs
(
    OrganizationID int,
    AttrID int,
    [Default] bit
)

INSERT INTO #BranchDiffs
SELECT
    a.OrganizationID,
    a.AttrID,
    a.[Default]
FROM #AttrVal a
WHERE a.Org_Level = 3
AND a.[Default] = 1
GROUP BY
    a.OrganizationID,
    a.AttrID,
    a.[Default]
/*
SELECT o.ParentOrganizationID,bd.* FROM #BranchDiffs bd
INNER JOIN Polaris.Organizations o (nolock) on bd.OrganizationID = o.OrganizationID
WHERE bd.AttrID = 1621
and o.ParentOrganizationID = 2
*/
DELETE FROM a
FROM #AttrVal a
INNER JOIN #BranchDiffs bd
    on a.OrganizationID = bd.OrganizationID
        and a.AttrID = bd.AttrID
WHERE a.Org_Level = 3
/*
SELECT o.ParentOrganizationID,a.* FROM #AttrVal a
INNER JOIN Polaris.Organizations o (nolock) on a.OrganizationID = o.OrganizationID
WHERE a.Org_Level = 3
--GROUP BY a.OrganizationID
--ORDER BY a.OrganizationID


SELECT o.ParentOrganizationID,a.* FROM #AttrVal a
INNER JOIN Polaris.Organizations o (nolock) on a.OrganizationID = o.OrganizationID
WHERE a.Org_Level = 3
and a.AttrID = 1621
and o.ParentOrganizationID = 2
--GROUP BY a.OrganizationID
--ORDER BY a.OrganizationID
*/

SELECT
    o.Org_Level,
    o.name,a1272.[Value] AS [Email_Sender],
a1621.[Value] AS [Email_ReplyTo],
CASE WHEN a2139.[Value] IS NULL THEN NULL WHEN a2139.[Value] = 1 THEN 'Use Main Email' ELSE 'Use Both Main & Alt. Email' END AS [PatronEmail_WhichToContact],
a1610.[Value] AS [NoticeMethod_On_Print],
a1611.[Value] AS [NoticeMethod_On_Email],
a480.[Value] AS [NoticeMethod_On_Phone],
a2695.[Value] AS [NoticeMethod_On_Txt],
a1612.[Value] AS [Overdue_NoticeEnabled],
CASE WHEN a2145.[Value] IS NULL THEN NULL WHEN a2145.[Value] = 1 THEN 'Item''s Branch' WHEN  a2145.[Value] = 2 THEN 'Lending Branch' ELSE 'Patron''s Branch' END AS [Overdue_NoticeLibrary],
CASE WHEN a2146.[Value] IS NULL THEN NULL WHEN a2146.[Value] = 1 THEN 'Use Notice Library' ELSE 'Use Selected Address' END AS [Overdue_ReturnAddress],
CASE WHEN a2147.[Value] = '-1' THEN '<None>' ELSE a2147.[Value] END AS [Overdue_ReturnAddress_Org],
a995.[Value] AS [Overdue_1_DayInterval],
Case WHEN a2144.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2144.[Value] = 1 THEN 'Print' 
WHEN a2144.[Value] = 2 THEN 'Email' 
WHEN a2144.[Value] = 3 THEN 'Phone' 
WHEN a2144.[Value] = 8 THEN 'Txt' 
WHEN a2144.[Value] = 100 THEN 'Both Email & Txt'
END AS [Overdue_1_NoticeMethod],
a2696.[Value] AS [Overdue_1_AdditionalText],
a996.[Value] AS [Overdue_2_DayInterval],
Case WHEN a2188.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2188.[Value] = 1 THEN 'Print' 
WHEN a2188.[Value] = 2 THEN 'Email' 
WHEN a2188.[Value] = 3 THEN 'Phone' 
WHEN a2188.[Value] = 8 THEN 'Txt' 
WHEN a2188.[Value] = 100 THEN 'Both Email & Txt'
END AS [Overdue_2_NoticeMethod],
a2697.[Value] AS [Overdue_2_AdditionalText],
a997.[Value] AS [Overdue_3_DayInterval],
Case WHEN a2189.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2189.[Value] = 1 THEN 'Print' 
WHEN a2189.[Value] = 2 THEN 'Email' 
WHEN a2189.[Value] = 3 THEN 'Phone' 
WHEN a2189.[Value] = 8 THEN 'Txt' 
WHEN a2189.[Value] = 100 THEN 'Both Email & Txt'
END AS [Overdue_3_NoticeMethod],
a2698.[Value] AS [Overdue_3_AdditionalText],
a1613.[Value] AS [Bill_NoticeEnabled],
a998.[Value] AS [Bill_DayInterval],
Case WHEN a2149.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2149.[Value] = 1 THEN 'Print' 
WHEN a2149.[Value] = 2 THEN 'Email' 
WHEN a2149.[Value] = 3 THEN 'Phone' 
WHEN a2149.[Value] = 8 THEN 'Txt' 
WHEN a2149.[Value] = 100 THEN 'Both Email & Txt'
END AS [Bill_NoticeMethod],
a2699.[Value] AS [Bill_AdditionalText],
CASE WHEN a2150.[Value] IS NULL THEN NULL WHEN a2150.[Value] = 1 THEN 'Item''s Branch' WHEN  a2150.[Value] = 2 THEN 'Lending Branch' ELSE 'Patron''s Branch' END AS [Bill_NoticeLibrary],
CASE WHEN a2151.[Value] IS NULL THEN NULL WHEN a2151.[Value] = 1 THEN 'Use Notice Library' ELSE 'Use Selected Address' END AS [Bill_ReturnAddress],
CASE WHEN a2152.[Value] = '-1' THEN '<None>' ELSE a2152.[Value]  END AS [Bill_ReturnAddress_Org],
a1615.[Value] AS [CombineNotices_NoticeEnabled],
a1614.[Value] AS [Request_NoticeEnabled],
Case WHEN a2165.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2165.[Value] = 1 THEN 'Print' 
WHEN a2165.[Value] = 2 THEN 'Email' 
WHEN a2165.[Value] = 3 THEN 'Phone' 
WHEN a2165.[Value] = 8 THEN 'Txt' 
WHEN a2165.[Value] = 100 THEN 'Both Email & Txt'
END AS [Request_NoticeMethod],
a2701.[Value] AS [Request_AdditionalText],
a3027.[Value] AS [Request_2_NoticeEnabled],
Case WHEN a3028.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3028.[Value] = 1 THEN 'Print' 
WHEN a3028.[Value] = 2 THEN 'Email' 
WHEN a3028.[Value] = 3 THEN 'Phone' 
WHEN a3028.[Value] = 8 THEN 'Txt' 
WHEN a3028.[Value] = 100 THEN 'Both Email & Txt'
END AS [Request_2_NoticeMethod],
a3029.[Value] AS [Request_2_AdditionalText],
a3030.[Value] AS [Request_2_DayInterval],
a2141.[Value] AS [CancelRequest_NoticeEnabled],
Case WHEN a2341.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2341.[Value] = 1 THEN 'Print' 
WHEN a2341.[Value] = 2 THEN 'Email' 
WHEN a2341.[Value] = 3 THEN 'Phone' 
WHEN a2341.[Value] = 8 THEN 'Txt' 
WHEN a2341.[Value] = 100 THEN 'Both Email & Txt'
END AS [CancelRequest_NoticeMethod],
a2702.[Value] AS [CancelRequest_AdditionalText],
a3078.[Value] AS [eContentRequest_NoticeEnabled],
Case WHEN a3080.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3080.[Value] = 1 THEN 'Print' 
WHEN a3080.[Value] = 2 THEN 'Email' 
WHEN a3080.[Value] = 3 THEN 'Phone' 
WHEN a3080.[Value] = 8 THEN 'Txt' 
WHEN a3080.[Value] = 100 THEN 'Both Email & Txt'
END AS [eContentRequest_NoticeMethod],
a3079.[Value] AS [Cancel_eRequest_NoticeEnabled],
Case WHEN a3081.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3081.[Value] = 1 THEN 'Print' 
WHEN a3081.[Value] = 2 THEN 'Email' 
WHEN a3081.[Value] = 3 THEN 'Phone' 
WHEN a3081.[Value] = 8 THEN 'Txt' 
WHEN a3081.[Value] = 100 THEN 'Both Email & Txt'
END AS [Cancel_eRequest_NoticeMethod],
a1971.[Value] AS [Fine_NoticeEnabled],
a1276.[Value] AS [AlmOverdue_NoticeEnabled],
a1270.[Value] AS [AlmOverdue_DaysBeforeOverdue],
a1869.[Value] AS [AlmOverdue_DaysBetweenReminders],
a2703.[Value] AS [AlmOverdue_AdditionalText],
a1275.[Value] AS [ExpiringPatron_NoticeEnabled],
a1269.[Value] AS [ExpiringPatron_DayInterval],
a2703b.[Value] AS [ExpiringPatron_AdditionalText],
a1277.[Value] AS [InactivePatron_NoticeEnabled],
a3180.[Value] AS [MissingPart_NoticeEnabled],
a2274.[Value] AS [SerialClaim_NoticeEnabled],
a2275.[Value] AS [Serial_AutoClaiming],
Case WHEN a2264.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2264.[Value] = 1 THEN 'Print' 
WHEN a2264.[Value] = 2 THEN 'Email' 
WHEN a2264.[Value] = 3 THEN 'Phone' 
WHEN a2264.[Value] = 8 THEN 'Txt' 
WHEN a2264.[Value] = 100 THEN 'Both Email & Txt'
END AS [Serial_NoticeMethod],
a2268.[Value] AS [Serial_ContactPerson],
a2269.[Value] AS [Serial_ContactDept],
a2270.[Value] AS [Serial_Phone],
a2271.[Value] AS [Serial_Email],
a2265.[Value] AS [Serial_NoticeText],
CASE WHEN a2267.[Value] = '1' THEN 'SILS (sys)' ELSE a2267.[Value]  END AS [Serial_ReturnAddress_Org],
a2273.[Value] AS [Serial_InclClaimReason],
a2272.[Value] AS [Serial_InclClaimNote],
a1693.[Value] AS [Routing_NoticeEnabled]
FROM #Orgs o (nolock)
INNER JOIN #AttrVal a
    on a.[Key] = o.[Key]
LEFT JOIN #AttrVal a1272 ON o.OrganizationID = a1272.OrganizationID AND a1272.AttrID = 1272
LEFT JOIN #AttrVal a1621 ON o.OrganizationID = a1621.OrganizationID AND a1621.AttrID = 1621
LEFT JOIN #AttrVal a1610 ON o.OrganizationID = a1610.OrganizationID AND a1610.AttrID = 1610
LEFT JOIN #AttrVal a1611 ON o.OrganizationID = a1611.OrganizationID AND a1611.AttrID = 1611
LEFT JOIN #AttrVal a480 ON o.OrganizationID = a480.OrganizationID AND a480.AttrID = 480
LEFT JOIN #AttrVal a2695 ON o.OrganizationID = a2695.OrganizationID AND a2695.AttrID = 2695
LEFT JOIN #AttrVal a1612 ON o.OrganizationID = a1612.OrganizationID AND a1612.AttrID = 1612
LEFT JOIN #AttrVal a2145 ON o.OrganizationID = a2145.OrganizationID AND a2145.AttrID = 2145
LEFT JOIN #AttrVal a2146 ON o.OrganizationID = a2146.OrganizationID AND a2146.AttrID = 2146
LEFT JOIN #AttrVal a2147 ON o.OrganizationID = a2147.OrganizationID AND a2147.AttrID = 2147
LEFT JOIN #AttrVal a995 ON o.OrganizationID = a995.OrganizationID AND a995.AttrID = 995
LEFT JOIN #AttrVal a2144 ON o.OrganizationID = a2144.OrganizationID AND a2144.AttrID = 2144
LEFT JOIN #AttrVal a2696 ON o.OrganizationID = a2696.OrganizationID AND a2696.AttrID = 2696
LEFT JOIN #AttrVal a996 ON o.OrganizationID = a996.OrganizationID AND a996.AttrID = 996
LEFT JOIN #AttrVal a2188 ON o.OrganizationID = a2188.OrganizationID AND a2188.AttrID = 2188
LEFT JOIN #AttrVal a2697 ON o.OrganizationID = a2697.OrganizationID AND a2697.AttrID = 2697
LEFT JOIN #AttrVal a997 ON o.OrganizationID = a997.OrganizationID AND a997.AttrID = 997
LEFT JOIN #AttrVal a2189 ON o.OrganizationID = a2189.OrganizationID AND a2189.AttrID = 2189
LEFT JOIN #AttrVal a2698 ON o.OrganizationID = a2698.OrganizationID AND a2698.AttrID = 2698
LEFT JOIN #AttrVal a1613 ON o.OrganizationID = a1613.OrganizationID AND a1613.AttrID = 1613
LEFT JOIN #AttrVal a998 ON o.OrganizationID = a998.OrganizationID AND a998.AttrID = 998
LEFT JOIN #AttrVal a2149 ON o.OrganizationID = a2149.OrganizationID AND a2149.AttrID = 2149
LEFT JOIN #AttrVal a2699 ON o.OrganizationID = a2699.OrganizationID AND a2699.AttrID = 2699
LEFT JOIN #AttrVal a2150 ON o.OrganizationID = a2150.OrganizationID AND a2150.AttrID = 2150
LEFT JOIN #AttrVal a2151 ON o.OrganizationID = a2151.OrganizationID AND a2151.AttrID = 2151
LEFT JOIN #AttrVal a2152 ON o.OrganizationID = a2152.OrganizationID AND a2152.AttrID = 2152
LEFT JOIN #AttrVal a1615 ON o.OrganizationID = a1615.OrganizationID AND a1615.AttrID = 1615
LEFT JOIN #AttrVal a1614 ON o.OrganizationID = a1614.OrganizationID AND a1614.AttrID = 1614
LEFT JOIN #AttrVal a2165 ON o.OrganizationID = a2165.OrganizationID AND a2165.AttrID = 2165
LEFT JOIN #AttrVal a2701 ON o.OrganizationID = a2701.OrganizationID AND a2701.AttrID = 2701
LEFT JOIN #AttrVal a3027 ON o.OrganizationID = a3027.OrganizationID AND a3027.AttrID = 3027
LEFT JOIN #AttrVal a3028 ON o.OrganizationID = a3028.OrganizationID AND a3028.AttrID = 3028
LEFT JOIN #AttrVal a3029 ON o.OrganizationID = a3029.OrganizationID AND a3029.AttrID = 3029
LEFT JOIN #AttrVal a3030 ON o.OrganizationID = a3030.OrganizationID AND a3030.AttrID = 3030
LEFT JOIN #AttrVal a2141 ON o.OrganizationID = a2141.OrganizationID AND a2141.AttrID = 2141
LEFT JOIN #AttrVal a2341 ON o.OrganizationID = a2341.OrganizationID AND a2341.AttrID = 2341
LEFT JOIN #AttrVal a2702 ON o.OrganizationID = a2702.OrganizationID AND a2702.AttrID = 2702
LEFT JOIN #AttrVal a3078 ON o.OrganizationID = a3078.OrganizationID AND a3078.AttrID = 3078
LEFT JOIN #AttrVal a3080 ON o.OrganizationID = a3080.OrganizationID AND a3080.AttrID = 3080
LEFT JOIN #AttrVal a3079 ON o.OrganizationID = a3079.OrganizationID AND a3079.AttrID = 3079
LEFT JOIN #AttrVal a3081 ON o.OrganizationID = a3081.OrganizationID AND a3081.AttrID = 3081
LEFT JOIN #AttrVal a1971 ON o.OrganizationID = a1971.OrganizationID AND a1971.AttrID = 1971
LEFT JOIN #AttrVal a1276 ON o.OrganizationID = a1276.OrganizationID AND a1276.AttrID = 1276
LEFT JOIN #AttrVal a1270 ON o.OrganizationID = a1270.OrganizationID AND a1270.AttrID = 1270
LEFT JOIN #AttrVal a1869 ON o.OrganizationID = a1869.OrganizationID AND a1869.AttrID = 1869
LEFT JOIN #AttrVal a2703 ON o.OrganizationID = a2703.OrganizationID AND a2703.AttrID = 2703
LEFT JOIN #AttrVal a1275 ON o.OrganizationID = a1275.OrganizationID AND a1275.AttrID = 1275
LEFT JOIN #AttrVal a1269 ON o.OrganizationID = a1269.OrganizationID AND a1269.AttrID = 1269
LEFT JOIN #AttrVal a2703b ON o.OrganizationID = a2703b.OrganizationID AND a2703b.AttrID = 2703
LEFT JOIN #AttrVal a1277 ON o.OrganizationID = a1277.OrganizationID AND a1277.AttrID = 1277
LEFT JOIN #AttrVal a3180 ON o.OrganizationID = a3180.OrganizationID AND a3180.AttrID = 3180
LEFT JOIN #AttrVal a2274 ON o.OrganizationID = a2274.OrganizationID AND a2274.AttrID = 2274
LEFT JOIN #AttrVal a2275 ON o.OrganizationID = a2275.OrganizationID AND a2275.AttrID = 2275
LEFT JOIN #AttrVal a2264 ON o.OrganizationID = a2264.OrganizationID AND a2264.AttrID = 2264
LEFT JOIN #AttrVal a2268 ON o.OrganizationID = a2268.OrganizationID AND a2268.AttrID = 2268
LEFT JOIN #AttrVal a2269 ON o.OrganizationID = a2269.OrganizationID AND a2269.AttrID = 2269
LEFT JOIN #AttrVal a2270 ON o.OrganizationID = a2270.OrganizationID AND a2270.AttrID = 2270
LEFT JOIN #AttrVal a2271 ON o.OrganizationID = a2271.OrganizationID AND a2271.AttrID = 2271
LEFT JOIN #AttrVal a2265 ON o.OrganizationID = a2265.OrganizationID AND a2265.AttrID = 2265
LEFT JOIN #AttrVal a2267 ON o.OrganizationID = a2267.OrganizationID AND a2267.AttrID = 2267
LEFT JOIN #AttrVal a2273 ON o.OrganizationID = a2273.OrganizationID AND a2273.AttrID = 2273
LEFT JOIN #AttrVal a2272 ON o.OrganizationID = a2272.OrganizationID AND a2272.AttrID = 2272
LEFT JOIN #AttrVal a1693 ON o.OrganizationID = a1693.OrganizationID AND a1693.AttrID = 1693
LEFT JOIN #AttrVal a2139 ON o.OrganizationID = a2139.OrganizationID AND a2139.AttrID = 2139
WHERE o.OrganizationID IN (
    SELECT
        a.OrganizationID
    FROM #AttrVal a
    GROUP BY a.OrganizationID
)

GROUP BY
    o.Org_Level,
    o.name,a1272.[Value],
a1621.[Value],
CASE WHEN a2139.[Value] IS NULL THEN NULL WHEN a2139.[Value] = 1 THEN 'Use Main Email' ELSE 'Use Both Main & Alt. Email' END,
a1610.[Value],
a1611.[Value],
a480.[Value],
a2695.[Value],
a1612.[Value],
CASE WHEN a2145.[Value] IS NULL THEN NULL WHEN a2145.[Value] = 1 THEN 'Item''s Branch' WHEN  a2145.[Value] = 2 THEN 'Lending Branch' ELSE 'Patron''s Branch' END,
CASE WHEN a2146.[Value] IS NULL THEN NULL WHEN a2146.[Value] = 1 THEN 'Use Notice Library' ELSE 'Use Selected Address' END,
CASE WHEN a2147.[Value] = '-1' THEN '<None>' ELSE a2147.[Value] END,
a995.[Value],
Case WHEN a2144.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2144.[Value] = 1 THEN 'Print' 
WHEN a2144.[Value] = 2 THEN 'Email' 
WHEN a2144.[Value] = 3 THEN 'Phone' 
WHEN a2144.[Value] = 8 THEN 'Txt' 
WHEN a2144.[Value] = 100 THEN 'Both Email & Txt'
END,
a2696.[Value],
a996.[Value],
Case WHEN a2188.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2188.[Value] = 1 THEN 'Print' 
WHEN a2188.[Value] = 2 THEN 'Email' 
WHEN a2188.[Value] = 3 THEN 'Phone' 
WHEN a2188.[Value] = 8 THEN 'Txt' 
WHEN a2188.[Value] = 100 THEN 'Both Email & Txt'
END,
a2697.[Value],
a997.[Value],
Case WHEN a2189.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2189.[Value] = 1 THEN 'Print' 
WHEN a2189.[Value] = 2 THEN 'Email' 
WHEN a2189.[Value] = 3 THEN 'Phone' 
WHEN a2189.[Value] = 8 THEN 'Txt' 
WHEN a2189.[Value] = 100 THEN 'Both Email & Txt'
END,
a2698.[Value],
a1613.[Value],
a998.[Value],
Case WHEN a2149.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2149.[Value] = 1 THEN 'Print' 
WHEN a2149.[Value] = 2 THEN 'Email' 
WHEN a2149.[Value] = 3 THEN 'Phone' 
WHEN a2149.[Value] = 8 THEN 'Txt' 
WHEN a2149.[Value] = 100 THEN 'Both Email & Txt'
END,
a2699.[Value],
CASE WHEN a2150.[Value] IS NULL THEN NULL WHEN a2150.[Value] = 1 THEN 'Item''s Branch' WHEN  a2150.[Value] = 2 THEN 'Lending Branch' ELSE 'Patron''s Branch' END,
CASE WHEN a2151.[Value] IS NULL THEN NULL WHEN a2151.[Value] = 1 THEN 'Use Notice Library' ELSE 'Use Selected Address' END,
CASE WHEN a2152.[Value] = '-1' THEN '<None>' ELSE a2152.[Value] END,
a1615.[Value],
a1614.[Value],
Case WHEN a2165.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2165.[Value] = 1 THEN 'Print' 
WHEN a2165.[Value] = 2 THEN 'Email' 
WHEN a2165.[Value] = 3 THEN 'Phone' 
WHEN a2165.[Value] = 8 THEN 'Txt' 
WHEN a2165.[Value] = 100 THEN 'Both Email & Txt'
END,
a2701.[Value],
a3027.[Value],
Case WHEN a3028.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3028.[Value] = 1 THEN 'Print' 
WHEN a3028.[Value] = 2 THEN 'Email' 
WHEN a3028.[Value] = 3 THEN 'Phone' 
WHEN a3028.[Value] = 8 THEN 'Txt' 
WHEN a3028.[Value] = 100 THEN 'Both Email & Txt'
END,
a3029.[Value],
a3030.[Value],
a2141.[Value],
Case WHEN a2341.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2341.[Value] = 1 THEN 'Print' 
WHEN a2341.[Value] = 2 THEN 'Email' 
WHEN a2341.[Value] = 3 THEN 'Phone' 
WHEN a2341.[Value] = 8 THEN 'Txt' 
WHEN a2341.[Value] = 100 THEN 'Both Email & Txt'
END,
a2702.[Value],
a3078.[Value],
Case WHEN a3080.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3080.[Value] = 1 THEN 'Print' 
WHEN a3080.[Value] = 2 THEN 'Email' 
WHEN a3080.[Value] = 3 THEN 'Phone' 
WHEN a3080.[Value] = 8 THEN 'Txt' 
WHEN a3080.[Value] = 100 THEN 'Both Email & Txt'
END,
a3079.[Value],
Case WHEN a3081.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a3081.[Value] = 1 THEN 'Print' 
WHEN a3081.[Value] = 2 THEN 'Email' 
WHEN a3081.[Value] = 3 THEN 'Phone' 
WHEN a3081.[Value] = 8 THEN 'Txt' 
WHEN a3081.[Value] = 100 THEN 'Both Email & Txt'
END,
a1971.[Value],
a1276.[Value],
a1270.[Value],
a1869.[Value],
a2703.[Value],
a1275.[Value],
a1269.[Value],
a2703b.[Value],
a1277.[Value],
a3180.[Value],
a2274.[Value],
a2275.[Value],
Case WHEN a2264.[Value] = 0 THEN 'Patron Notice Setting'
WHEN a2264.[Value] = 1 THEN 'Print' 
WHEN a2264.[Value] = 2 THEN 'Email' 
WHEN a2264.[Value] = 3 THEN 'Phone' 
WHEN a2264.[Value] = 8 THEN 'Txt' 
WHEN a2264.[Value] = 100 THEN 'Both Email & Txt'
END,
a2268.[Value],
a2269.[Value],
a2270.[Value],
a2271.[Value],
a2265.[Value],
CASE WHEN a2267.[Value] = '1' THEN 'SILS (sys)' ELSE a2267.[Value]  END,
a2273.[Value],
a2272.[Value],
a1693.[Value]
ORDER BY
    o.Org_Level,
    o.name


DROP TABLE IF EXISTS #Attrs
DROP TABLE IF EXISTS #AttrVal
DROP TABLE IF EXISTS #BranchDiffs
DROP TABLE IF EXISTS #Orgs