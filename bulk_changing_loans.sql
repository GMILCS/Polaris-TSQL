--IUG 2021 The code attached allows you bulk change loan limits (max items out and max holds) for your organization without having to go line by line. Our example will not run directly in your environment but it can act as a plug'n'play template.

--derek.brown@rhpl.org

-- Print Materials Residents/Staff/OTBS

-- Library Material Type (Print Materials) - Authors in April (35)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (35)

-- Library Material Type (Print Materials) - Books (1)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (1)

-- Library Material Type (Print Materials) - Adult Hot New Books (36)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (36)

-- Library Material Type (Print Materials) - Book Discussion Kits (4,17)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (4,17)

-- Library Material Type (Print Materials) - Books in Demand (37)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=1
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (37)

-- Library Material Type (Print Materials) - Circulating Periodicals (9,14,38)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (9,14,38)

-- Library Material Type (Print Materials) - ILL Items (Excludes 29 OTBS-NonResident 31,32,33,34)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=70
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28)
and MaterialTypeID in (31,32,33,34)

-- Library Material Type (Print Materials) - Reference Material (39)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (39)


-- Non-Print Materials

-- Library Material Type (Non-Print Materials) - Audiobooks(CD) (2,40)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (2,40)

-- Library Material Type (Non-Print Materials) - Library Cloth Bag (20)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,2,3,4,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (20)

-- Library Material Type (Non-Print Materials) - DVD - Feature Length (41)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (41)

-- Library Material Type (Non-Print Materials) - DVD - Television Series (42)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (42)

-- Library Material Type (Non-Print Materials) - Blu-ray (30)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (30)

-- Library Material Type (Non-Print Materials) - Hooked on Phonics (43)
update polaris.polaris.MaterialLoanLimits
set MaxItems=1, MaxRequestItems=1
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (43)

-- Library Material Type (Non-Print Materials) - Low Vision Aids (18)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=1
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (18)

-- Library Material Type (Non-Print Materials) - Music CDs - Compact Disk (5)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=10
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (5)

-- Library Material Type (Non-Print Materials) - Playaway Audiobooks (44)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=10
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (44)

-- Library Material Type (Non-Print Materials) - Playaway Launchpads (45)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=10
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (45)

-- Library Material Type (Non-Print Materials) - Playaway Views (46)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=10
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (46)

-- Library Material Type (Non-Print Materials) - Puppets (10)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (10)

-- Library Material Type (Non-Print Materials) - Video Games (13)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (13)



-- Experiential Learning Kits

-- Library Material Type (Experiential Materials) - Adventure Kits (47)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (47)

-- Library Material Type (Experiential Materials) - Game Kits (48)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (48)

-- Library Material Type (Experiential Materials) - Hobby Kits (49)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (49)

-- Library Material Type (Experiential Materials) - Outreach MYLE Kits (50)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (50)

-- Library Material Type (Experiential Materials) - Puzzles Kits (51)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (51)

-- Library Material Type (Experiential Materials) - Steam Kits (52)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (52)

-- Library Material Type (Experiential Materials) - Story Kits (53)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=2
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (53)

-- Library Material Type (Experiential Materials) - Tech Kits (54)
update polaris.polaris.MaterialLoanLimits
set MaxItems=1, MaxRequestItems=1
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (54)

-- Library Material Type (Experiential Materials) - Hotspot (28)
update polaris.polaris.MaterialLoanLimits
set MaxItems=1, MaxRequestItems=1
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (28)

-- Library Material Type (Experiential Materials) - Laptops (23)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29)
and MaterialTypeID in (23)


-- E-material

-- Library Material Type (Non-Print Materials) - eBook (16)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29,20,27)
and MaterialTypeID in (16)

-- Library Material Type (Non-Print Materials) - eAudioBook (25)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=20
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (1,3,6,7,8,11,12,13,14,19,24,25,26,28,29,20,27)
and MaterialTypeID in (25)



-- NON-RESIDENT REMOVALS

-- Library Material Type (Print Materials) - Authors in April (35)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (35)

-- Library Material Type (Print Materials) - Books (1)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (1)

-- Library Material Type (Print Materials) - Adult Hot New Books (36)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (36)

-- Library Material Type (Print Materials) - Book Discussion Kits (4,17)
update polaris.polaris.MaterialLoanLimits
set MaxItems=2, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (4,17)

-- Library Material Type (Print Materials) - Books in Demand (37)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (37)

-- Library Material Type (Print Materials) - Circulating Periodicals (9,14,38)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (9,14,38)

-- Library Material Type (Print Materials) - Reference Material (39)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (39)


-- Non-Print Materials REMOVAL

-- Library Material Type (Non-Print Materials) - Audiobooks(CD) (2,40)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (2,40)

-- Library Material Type (Non-Print Materials) - DVD - Feature Length (41)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (41)

-- Library Material Type (Non-Print Materials) - DVD - Television Series (42)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (42)

-- Library Material Type (Non-Print Materials) - Blu-ray (30)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (30)

-- Library Material Type (Non-Print Materials) - Hooked on Phonics (43)
update polaris.polaris.MaterialLoanLimits
set MaxItems=1, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (43)

-- Library Material Type (Non-Print Materials) - Low Vision Aids (18)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (18)

-- Library Material Type (Non-Print Materials) - Music CDs - Compact Disk (5)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (5)

-- Library Material Type (Non-Print Materials) - Playaway Audiobooks (44)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (44)

-- Library Material Type (Non-Print Materials) - Playaway Launchpads (45)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (45)

-- Library Material Type (Non-Print Materials) - Playaway Views (46)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (46)

-- Library Material Type (Non-Print Materials) - Puppets (10)
update polaris.polaris.MaterialLoanLimits
set MaxItems=100, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (10)

-- Library Material Type (Non-Print Materials) - Video Games (13)
update polaris.polaris.MaterialLoanLimits
set MaxItems=10, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2)
and MaterialTypeID in (13)



-- Experiential Learning Kits Non-Resident/MILibrary BLOCK

-- Library Material Type (Experiential Materials) - Adventure Kits (47)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (47)

-- Library Material Type (Experiential Materials) - Game Kits (48)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (48)

-- Library Material Type (Experiential Materials) - Hobby Kits (49)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (49)

-- Library Material Type (Experiential Materials) - Outreach MYLE Kits (50)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (50)

-- Library Material Type (Experiential Materials) - Puzzles Kits (51)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (51)

-- Library Material Type (Experiential Materials) - Steam Kits (52)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (52)

-- Library Material Type (Experiential Materials) - Story Kits (53)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (53)

-- Library Material Type (Experiential Materials) - Tech Kits (54)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (54)

-- Library Material Type (Experiential Materials) - Hotspot (28)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (28)

-- Library Material Type (Experiential Materials) - Laptops (23)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (23)





-- E-material  Non-Resident/MILibrary BLOCK

-- Library Material Type (E-Material) - eBook (16)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (16)

-- Library Material Type (E-Material) - eAudioBook (25)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4)
and MaterialTypeID in (25)





-- NO CHECK OUT BLOCK

-- Library Material Type (Print Materials) - Authors in April (35)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (35)

-- Library Material Type (Print Materials) - Books (1)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (1)

-- Library Material Type (Print Materials) - Adult Hot New Books (36)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (36)

-- Library Material Type (Print Materials) - Book Discussion Kits (4,17)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (4,17)

-- Library Material Type (Print Materials) - Books in Demand (37)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (37)

-- Library Material Type (Print Materials) - Circulating Periodicals (9,14,38)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (9,14,38)

-- Library Material Type (Print Materials) - ILL Items (Excludes OTBS-NonResident 31,32,33,34)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (2,4,9,15,17,20,22,27,29)
and MaterialTypeID in (31,32,33,34)

-- Library Material Type (Print Materials) - Reference Material (39)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (39)




-- Non-Print Materials BLOCK

-- Library Material Type (Non-Print Materials) - Audiobooks(CD) (2,40)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (2,40)

-- Library Material Type (Non-Print Materials) - DVD - Feature Length (41)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (41)

-- Library Material Type (Non-Print Materials) - DVD - Television Series (42)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (42)

-- Library Material Type (Non-Print Materials) - Blu-ray (30)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (30)

-- Library Material Type (Non-Print Materials) - Hooked on Phonics (43)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (43)

-- Library Material Type (Non-Print Materials) - Low Vision Aids (18)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (18)

-- Library Material Type (Non-Print Materials) - Music CDs - Compact Disk (5)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (5)

-- Library Material Type (Non-Print Materials) - Playaway Audiobooks (44)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (44)

-- Library Material Type (Non-Print Materials) - Playaway Launchpads (45)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (45)

-- Library Material Type (Non-Print Materials) - Playaway Views (46)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (46)

-- Library Material Type (Non-Print Materials) - Puppets (10)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (10)

-- Library Material Type (Non-Print Materials) - Video Games (13)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (4,9,15,17,20,22,27)
and MaterialTypeID in (13)




-- Experiential Learning Kits BLOCK

-- Library Material Type (Experiential Materials) - Adventure Kits (47)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (47)

-- Library Material Type (Experiential Materials) - Game Kits (48)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (48)

-- Library Material Type (Experiential Materials) - Hobby Kits (49)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (49)

-- Library Material Type (Experiential Materials) - Outreach MYLE Kits (50)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (50)

-- Library Material Type (Experiential Materials) - Puzzles Kits (51)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (51)

-- Library Material Type (Experiential Materials) - Steam Kits (52)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (52)

-- Library Material Type (Experiential Materials) - Story Kits (53)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (53)

-- Library Material Type (Experiential Materials) - Tech Kits (54)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (54)

-- Library Material Type (Experiential Materials) - Hotspot (28)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (28)

-- Library Material Type (Experiential Materials) - Laptops (23)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,20,22,27)
and MaterialTypeID in (23)



-- E-material BLOCK

-- Library Material Type (Non-Print Materials) - eBook (16)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,22)
and MaterialTypeID in (16)

-- Library Material Type (Non-Print Materials) - eAudioBook (25)
update polaris.polaris.MaterialLoanLimits
set MaxItems=0, MaxRequestItems=0
where OrganizationID in (3,4,5,6,7,8,9,10,11,12,13)
and PatronCodeID in (9,15,17,22)
and MaterialTypeID in (25)

