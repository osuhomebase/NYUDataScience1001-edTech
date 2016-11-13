-- set School Year = single integer year for easier data handling --
update nycDistrict20 SET SchoolYear = left(SchoolYear,4)


--- Extract previous year ---
UPDATE d1 SET d1.previousYear = d2.count FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 1)


-- Anytime the previous Year is null, set to zero for any grade level greater than Kindergarten --
UPDATE nycDistrict20 SET previousYear = 0 WHERE previousYear IS NULL AND SchoolYear > 2001

-- Set previousGrade = count where GradeLevel is Kindergarten.  Thought is there is this may be more accurate than assuming zero. --
UPDATE nycDistrict20 SET previousYear = [Count] WHERE SchoolYear = 2001

-- Figure out the YoY Percentage Growth
UPDATE nycDistrict20 SET OneYearPercentGrowth = (convert(numeric(9,6),[Count])-PreviousYear)/[PreviousYear] WHERE PreviousYear > 0

-- Figure out the YoY Actual Growth
UPDATE nycDistrict20 SET OneYearGrowth = [Count] - [PreviousYear] 


-- Just to verify results --
SELECT * FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 1)
	AND d1.GradeLevel=3
ORDER BY d1.CensusTract, d1.SchoolYear, d1.GradeLevel

 