/* 
Note sections commented out so that I could do one chunk at a time.  Easier than writing the whole query twice.
*/

UPDATE d SET NeighborCount = isNull(d2.[Count],0) +  isNull(d3.[Count],0) +  isNull(d4.[Count],0) +  isNull(d5.[Count],0) +  isNull(d6.[Count],0) +  isNull(d7.[Count],0) ,
--NeighborPreviousCount =  isNull(dp2.[Count],0) +  isNull(dp3.[Count],0) +  isNull(dp4.[Count],0) +  isNull(dp5.[Count],0) +  isNull(dp6.[Count],0) +  isNull(dp7.[Count],0) 
NeighborPreviousThreeCount = isNull(d3p2.[Count],0) + isNull(d3p3.[Count],0) + isNull(d3p4.[Count],0) + isNull(d3p5.[Count],0) + isNull(d3p6.[Count],0) + isNull(d3p7.[Count],0) 
 FROM nycDistrict20 d 
	INNER JOIN census_tracts_list_36 c ON d.longTract = c.GEOID 
	LEFT JOIN nycDistrict20 d2 ON d2.longTract = c.Neighbor1 AND d2.GradeLevel = d.GradeLevel AND d2.SchoolYear = d.SchoolYear
	LEFT JOIN nycDistrict20 d3 ON d3.longTract = c.Neighbor2 AND d3.GradeLevel = d.GradeLevel AND d3.SchoolYear = d.SchoolYear
	LEFT JOIN nycDistrict20 d4 ON d4.longTract = c.Neighbor3 AND d4.GradeLevel = d.GradeLevel AND d4.SchoolYear = d.SchoolYear
	LEFT JOIN nycDistrict20 d5 ON d5.longTract = c.Neighbor4 AND d5.GradeLevel = d.GradeLevel AND d5.SchoolYear = d.SchoolYear
	LEFT JOIN nycDistrict20 d6 ON d6.longTract = c.Neighbor5 AND d6.GradeLevel = d.GradeLevel AND d6.SchoolYear = d.SchoolYear
	LEFT JOIN nycDistrict20 d7 ON d7.longTract = c.Neighbor6 AND d7.GradeLevel = d.GradeLevel AND d7.SchoolYear = d.SchoolYear
	
	--LEFT JOIN nycDistrict20 dp2 ON dp2.longTract = c.Neighbor1 AND dp2.GradeLevel = d.GradeLevel AND dp2.SchoolYear = d.SchoolYear - 1
	--LEFT JOIN nycDistrict20 dp3 ON dp3.longTract = c.Neighbor2 AND dp3.GradeLevel = d.GradeLevel AND dp3.SchoolYear = d.SchoolYear - 1
	--LEFT JOIN nycDistrict20 dp4 ON dp4.longTract = c.Neighbor3 AND dp4.GradeLevel = d.GradeLevel AND dp4.SchoolYear = d.SchoolYear - 1
	--LEFT JOIN nycDistrict20 dp5 ON dp5.longTract = c.Neighbor4 AND dp5.GradeLevel = d.GradeLevel AND dp5.SchoolYear = d.SchoolYear - 1
	--LEFT JOIN nycDistrict20 dp6 ON dp6.longTract = c.Neighbor5 AND dp6.GradeLevel = d.GradeLevel AND dp6.SchoolYear = d.SchoolYear - 1
	--LEFT JOIN nycDistrict20 dp7 ON dp7.longTract = c.Neighbor6 AND dp7.GradeLevel = d.GradeLevel AND dp7.SchoolYear = d.SchoolYear - 1
	
	LEFT JOIN nycDistrict20 d3p2 ON d3p2.longTract = c.Neighbor1 AND d3p2.GradeLevel = d.GradeLevel AND d3p2.SchoolYear = d.SchoolYear - 3
	LEFT JOIN nycDistrict20 d3p3 ON d3p3.longTract = c.Neighbor2 AND d3p3.GradeLevel = d.GradeLevel AND d3p3.SchoolYear = d.SchoolYear - 3
	LEFT JOIN nycDistrict20 d3p4 ON d3p4.longTract = c.Neighbor3 AND d3p4.GradeLevel = d.GradeLevel AND d3p4.SchoolYear = d.SchoolYear - 3
	LEFT JOIN nycDistrict20 d3p5 ON d3p5.longTract = c.Neighbor4 AND d3p5.GradeLevel = d.GradeLevel AND d3p5.SchoolYear = d.SchoolYear - 3
	LEFT JOIN nycDistrict20 d3p6 ON d3p6.longTract = c.Neighbor5 AND d3p6.GradeLevel = d.GradeLevel AND d3p6.SchoolYear = d.SchoolYear - 3
	LEFT JOIN nycDistrict20 d3p7 ON d3p7.longTract = c.Neighbor6 AND d3p7.GradeLevel = d.GradeLevel AND d3p7.SchoolYear = d.SchoolYear - 3

-- Now set 2001 = NeighborCount 
UPDATE nycDistrict20 SET NeighborPreviousCount = NeighborCount WHERE SchoolYear = 2001

-- Now set 2001, 2002, 2003 = NeighborCount for 3 year 
UPDATE nycDistrict20 SET NeighborPreviousThreeCount = NeighborCount WHERE SchoolYear IN (2001,2002,2003)

UPDATE nycDistrict20 SET NeighborOnYearGrowth = NeighborCount - NeighborPreviousCount,
		NeighborThreeYearGrowth = NeighborCount - NeighborPreviousThreeCount
 FROM nycDistrict20
 
UPDATE nycDistrict20 SET NeighborOneYearPercentGrowth = (convert(numeric(9,6),NeighborCount)-NeighborPreviousCount)/NeighborPreviousCount FROM nycDistrict20  WHERE NeighborPreviousCount > 0

-- set some base cases for when PreviousThreeYear is equal to zero
UPDATE nycDistrict20 SET NeighborOneYearPercentGrowth = 1 WHERE NeighborPreviousCount = 0 AND NeighborCount > 0
UPDATE nycDistrict20 SET NeighborOneYearPercentGrowth = 0 WHERE NeighborPreviousCount = 0 AND NeighborCount = 0

UPDATE nycDistrict20 SET NeighborThreeYearPercentGrowth = (convert(numeric(9,6),NeighborCount)-NeighborPreviousThreeCount)/NeighborPreviousThreeCount FROM nycDistrict20  WHERE NeighborPreviousThreeCount > 0

-- set some base cases for when PreviousThreeYear is equal to zero
UPDATE nycDistrict20 SET NeighborThreeYearPercentGrowth = 1 WHERE NeighborPreviousThreeCount = 0 AND NeighborCount > 0
UPDATE nycDistrict20 SET NeighborThreeYearPercentGrowth = 0 WHERE NeighborPreviousThreeCount = 0 AND NeighborCount = 0


SELECT * FROM nycDistrict20