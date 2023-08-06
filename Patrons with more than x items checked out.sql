--Find Tool
select Ic.PatronID as RecordID
from Polaris.Polaris.ItemCheckouts as IC with (nolock)
group by IC.PatronID having count (IC.PatronID) > 20
