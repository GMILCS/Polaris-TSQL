SELECT

	PA.PatronID

FROM Polaris.Polaris.Patrons AS P WITH (NOLOCK)

INNER JOIN Polaris.Polaris.Organizations AS O WITH (NOLOCK)

	ON (P.OrganizationID = O.OrganizationID)

LEFT OUTER JOIN Polaris.Polaris.PatronAddresses AS PA WITH (NOLOCK)

	ON (P.PatronID = PA.PatronID)

LEFT OUTER JOIN Polaris.Polaris.Addresses AS A WITH (NOLOCK)

	ON (PA.AddressID = A.AddressID AND PA.AddressTypeID IN (1, 2))

WHERE P.OrganizationID = 3

and PA.AddressTypeID IN (1,2)

GROUP BY PA.PatronID

HAVING COUNT(*) > 1
