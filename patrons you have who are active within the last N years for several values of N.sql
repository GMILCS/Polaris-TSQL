DECLARE @refdate DATETIME;
SET     @refdate = GETDATE();

DECLARE @Y TABLE (
	numofyears	integer,
	magicdate	datetime,
	patroncount	integer
);

INSERT INTO @Y (numofyears) VALUES (1);
INSERT INTO @Y (numofyears) VALUES (2);
INSERT INTO @Y (numofyears) VALUES (3);
INSERT INTO @Y (numofyears) VALUES (4);
INSERT INTO @Y (numofyears) VALUES (5);
INSERT INTO @Y (numofyears) VALUES (6);
INSERT INTO @Y (numofyears) VALUES (7);
INSERT INTO @Y (numofyears) VALUES (8);
INSERT INTO @Y (numofyears) VALUES (9);
INSERT INTO @Y (numofyears) VALUES (10);
INSERT INTO @Y (numofyears) VALUES (15);

UPDATE	@Y
SET	magicdate = DATEADD(Year, (0 - numofyears), @refdate)
;

UPDATE	@Y
SET	patroncount =
	(SELECT	COUNT(P.PatronID) AS 'Patrons'
	 FROM	Polaris.Patrons P
	 JOIN	Polaris.PatronRegistration R ON R.PatronID = P.PatronID
	 WHERE	P.LastActivityDate >= magicdate
	 AND	(NOT (R.PatronFullName LIKE '*%'))
	 AND	(NOT ( (SELECT	COUNT(*)
			FROM	Polaris.PatronStops YS(NOLOCK)
			JOIN	Polaris.PatronStopDescriptions YD(NOLOCK) ON YD.PatronStopID = YS.PatronStopID
			WHERE	YS.PatronID = P.PatronID
			AND	YD.[Description] IN ('Deceased')
			) > 0)
                 )

	)
;

SELECT * FROM @Y;
