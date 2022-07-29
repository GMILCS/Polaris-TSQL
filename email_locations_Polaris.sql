select * from Polaris.polaris.AdminAttributes where AttrID in 
(select AttrID from polaris.polaris.Organizationspppp where Value like '%@%' or Mnemonic like '%email%' or Mnemonic like '%addr%')
