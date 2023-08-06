select tt.transactionTypeDescription, 

count (th.transactiontypeid)

from polaristransactions.polaris.TransactionTypes tt

right outer join polaristransactions.polaris.transactionHeaders th on th.transactiontypeid = tt.transactiontypeid

where th.transactiondate between '2013-12-01 12:01:00.000' and '2013-12-31 23:59:59.000'

and th.transactiontypeid in (1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1038, 1039, 1040)

group by tt.transactiontypedescription

order by tt.transactiontypedescription
