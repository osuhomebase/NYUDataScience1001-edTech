--- Extract previous grade ---
UPDATE d1 SET d1.PreviousGrade = d2.count FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.SchoolYear = d2.SchoolYear
	AND d2.GradeLevel = (d1.GradeLevel - 1)

-- Anytime the previousGrade is null, set to zero for any grade level greater than Kindergarten --
UPDATE nycDistrict20 SET PreviousGrade = 0 WHERE PreviousGrade IS NULL AND GradeLevel > 0

-- Set previousGrade = count where GradeLevel is Kindergarten.  Thought is there is this may be more accurate than assuming zero. --
UPDATE nycDistrict20 SET PreviousGrade = Count WHERE GradeLevel = 0

-- Just to verify results --
SELECT * FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.SchoolYear = d2.SchoolYear
	AND d2.GradeLevel = (d1.GradeLevel - 1)
ORDER BY d1.CensusTract, d1.SchoolYear, d1.GradeLevel
 