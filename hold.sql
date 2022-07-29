Select convert(varchar (255), hn.BrowseTitle) as BTitle
    , convert(varchar(10), q.CreationDate, 120) as CreationDate
    , hr.SysHoldRequestID
    , q.PatronID
    , hn.PickupOrganizationID
    , convert(varchar(10), hn.HoldTillDate, 120) as HoldTillDate
    , convert(varchar(20), p.Barcode) as PBarcode
From
    Results.polaris.NotificationQueue q (nolock)
    join Results.polaris.HoldNotices hn (nolock) on q.ItemRecordID=hn.ItemRecordID and q.PatronID=hn.PatronID and q.NotificationTypeID=hn.NotificationTypeID
    join polaris.Patrons p (nolock) on q.PatronID=p.PatronID
    left join polaris.SysHoldRequests hr on q.PatronID=hr.PatronID and q.ItemRecordID=hr.TrappingItemRecordID
Where
    q.DeliveryOptionID=3
    and hn.HoldTillDate>GETDATE()
Order By 
    p.Barcode