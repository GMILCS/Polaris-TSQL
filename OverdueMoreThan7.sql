
/*Find items more than seven days overdue*/
SELECT *
FROM polaris.ItemCheckouts
WHERE ItemRecordID IN (6800564, 6800565)
AND duedate <= GETDATE() -7;