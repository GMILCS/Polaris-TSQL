SELECT
      PatronID,
      COUNT(ItemRecordID) [NumItemsOut]
FROM
      ItemCheckouts

GROUP BY
      PatronID
HAVING
      COUNT(ItemRecordID) > 20

