--to add Stat Codes: 
--add at the system level and select all branches even though table doesn't open


--To delete Stat Codes

begin tran
DELETE FROM StatisticalCodes
WHERE OrganizationID IN (3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,32,33,35,36,38)
AND Description = 'NES CD Music'
	--'HPL CD''s' --example of how to capture 's: use two single quotes
--commit

--To change a stat code
begin tran
update StatisticalCodes
set Description = 'NES Juvenile Graphic Novels NF' -- New name
where OrganizationID IN (3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,32,33,35,36,38) 
AND Description = 'NES Juvenile Comix NF' -- Old name
--commit

--For reference
SELECT * 
FROM StatisticalCodes with (nolock)
WHERE Description = 'HPL Learning Kits';


SELECT *
FROM StatisticalCodes  with (nolock)

SELECT *
FROM Organizations with (nolock)
