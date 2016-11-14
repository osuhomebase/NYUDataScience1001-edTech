-- set School Year = single integer year for easier data handling --
update nycDistrict20 SET SchoolYear = left(SchoolYear,4)

-- look for missing values
DECLARE @tract varchar(25)
DECLARE @2010Tract varchar(25)
DECLARE @zip varchar(5)
DECLARE curs CURSOR FOR SELECT DISTINCT TRACT, Zip, [2010 Census Tract] FROM zipMapper
OPEN curs

FETCH NEXT FROM curs INTO @tract, @zip, @2010Tract
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @year INT
	SET @year = 2001
	WHILE @year < 2010
	BEGIN
		DECLARE @grade INT
		SET @grade = 0
		WHILE @grade < 6
		BEGIN
			IF (SELECT COUNT(*) FROM nycDistrict20 WHERE SchoolYear = @year AND GradeLevel = @grade AND LongTract = @tract) = 0
			BEGIN
				INSERT INTO nycDistrict20 (CensusTract, schoolYear,GradeLevel, [count],LongTract, Zip)
				VALUES(@2010Tract,@year,@grade,0,@tract,@zip)
			END
			SET @grade = @grade + 1
		END
		SET @year = @year + 1
	END
	FETCH NEXT FROM curs INTO @tract, @zip, @2010Tract
END
CLOSE curs
DEALLOCATE curs

--- Extract previous year ---
UPDATE d1 SET d1.previousYear = d2.[count] FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 1)

-- Anytime the previous Year is null, set to zero for any grade level greater than Kindergarten --
UPDATE nycDistrict20 SET previousYear = 0 WHERE previousYear IS NULL AND SchoolYear > 2001

-- Set previousGrade = count where GradeLevel is Kindergarten.  Thought is there is this may be more accurate than assuming zero. --
UPDATE nycDistrict20 SET previousYear = [Count] WHERE SchoolYear = 2001

-- Figure out the YoY Percentage Growth
UPDATE nycDistrict20 SET OneYearPercentGrowth = (convert(numeric(9,6),[Count])-PreviousYear)/[PreviousYear] WHERE PreviousYear > 0

-- set some base cases for when PreviousYear is equal to zero
UPDATE nycDistrict20 SET OneYearPercentGrowth = 1 WHERE PreviousYear = 0 AND [count] > 0
UPDATE nycDistrict20 SET OneYearPercentGrowth = 0 WHERE PreviousYear = 0 AND [count] = 0

-- Figure out the YoY Actual Growth
UPDATE nycDistrict20 SET OneYearGrowth = [Count] - [PreviousYear] 

--- Extract previous **three** year ---
UPDATE d1 SET d1.previousThreeYear = d2.[count] FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 3)

-- Anytime the previous **three** Year is null, set to zero for any grade level greater than Kindergarten --
UPDATE nycDistrict20 SET previousThreeYear = 0 WHERE previousThreeYear IS NULL AND SchoolYear > 2003

-- Set Thought is there is this may be more accurate than assuming zero. --
UPDATE nycDistrict20 SET previousThreeYear = [Count] WHERE SchoolYear IN(2001,2002,2003)

-- Figure out the Year over **Three** Year Percentage Growth
UPDATE nycDistrict20 SET ThreeYearPercentGrowth = (convert(numeric(9,6),[Count])-PreviousThreeYear)/PreviousThreeYear WHERE PreviousThreeYear > 0

-- set some base cases for when PreviousThreeYear is equal to zero
UPDATE nycDistrict20 SET ThreeYearPercentGrowth = 1 WHERE PreviousThreeYear = 0 AND [count] > 0
UPDATE nycDistrict20 SET ThreeYearPercentGrowth = 0 WHERE PreviousThreeYear = 0 AND [count] = 0

-- Figure out the YoY Actual Growth
UPDATE nycDistrict20 SET ThreeYearGrowth = [Count] - PreviousThreeYear 




--- Extract previous **Five** year ---
UPDATE d1 SET d1.previousFiveYear = d2.[count] FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 3)

-- Anytime the previous **Five** Year is null, set to zero for any grade level greater than Kindergarten --
UPDATE nycDistrict20 SET previousFiveYear = 0 WHERE previousFiveYear IS NULL AND SchoolYear > 2003

-- Set Thought is there is this may be more accurate than assuming zero. --
UPDATE nycDistrict20 SET previousFiveYear = [Count] WHERE SchoolYear IN(2001,2002,2003)

-- Figure out the Year over **Five** Year Percentage Growth
UPDATE nycDistrict20 SET FiveYearPercentGrowth = (convert(numeric(9,6),[Count])-PreviousFiveYear)/PreviousFiveYear WHERE PreviousFiveYear > 0

-- set some base cases for when PreviousFiveYear is equal to zero
UPDATE nycDistrict20 SET FiveYearPercentGrowth = 1 WHERE previousFiveYear = 0 AND [count] > 0
UPDATE nycDistrict20 SET FiveYearPercentGrowth = 0 WHERE previousFiveYear = 0 AND [count] = 0

-- Figure out the YoY Actual Growth
UPDATE nycDistrict20 SET FiveYearGrowth = [Count] - PreviousFiveYear 

-- Set Target Variables
-- Default = 0
UPDATE nycDistrict20 SET TargetVariable = 0
-- 1 if increase over previous year
UPDATE nycDistrict20 SET TargetVariable = 1 WHERE [Count] > PreviousYear


-- Just to verify results --
SELECT * FROM nycDistrict20 d1
	INNER JOIN nycDistrict20 d2 on d1.censusTract = d2.CensusTract AND d1.GradeLevel = d2.GradeLevel
	AND d2.SchoolYear = (d1.SchoolYear - 3)
	AND d1.GradeLevel=3
ORDER BY d1.CensusTract, d1.SchoolYear, d1.GradeLevel

