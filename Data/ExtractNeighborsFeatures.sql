SELECT d2.[Count] + d3.[Count] + d4.[Count] + d5.[Count] + d6.[Count] + d7.[Count] as neighborCount,
dp2.[Count] + dp3.[Count] + dp4.[Count] + dp5.[Count] + dp6.[Count] + dp7.[Count] as neighborPreviousCount,
--d3p2.[Count] + d3p3.[Count] + d3p4.[Count] + d3p5.[Count] + d3p6.[Count] + d3p7.[Count] as neighborPreviousThreeCount,
 * FROM nycDistrict20 d 
	INNER JOIN census_tracts_list_36 c ON d.longTract = c.GEOID 
	INNER JOIN nycDistrict20 d2 ON d2.longTract = c.Neighbor1 AND d2.GradeLevel = d.GradeLevel AND d2.SchoolYear = d.SchoolYear
	INNER JOIN nycDistrict20 d3 ON d3.longTract = c.Neighbor2 AND d3.GradeLevel = d.GradeLevel AND d3.SchoolYear = d.SchoolYear
	INNER JOIN nycDistrict20 d4 ON d4.longTract = c.Neighbor3 AND d4.GradeLevel = d.GradeLevel AND d4.SchoolYear = d.SchoolYear
	INNER JOIN nycDistrict20 d5 ON d5.longTract = c.Neighbor4 AND d5.GradeLevel = d.GradeLevel AND d5.SchoolYear = d.SchoolYear
	INNER JOIN nycDistrict20 d6 ON d6.longTract = c.Neighbor5 AND d6.GradeLevel = d.GradeLevel AND d6.SchoolYear = d.SchoolYear
	INNER JOIN nycDistrict20 d7 ON d7.longTract = c.Neighbor6 AND d7.GradeLevel = d.GradeLevel AND d7.SchoolYear = d.SchoolYear
	
	INNER JOIN nycDistrict20 dp2 ON dp2.longTract = c.Neighbor1 AND dp2.GradeLevel = d.GradeLevel AND dp2.SchoolYear = d.SchoolYear - 1
	INNER JOIN nycDistrict20 dp3 ON dp3.longTract = c.Neighbor2 AND dp3.GradeLevel = d.GradeLevel AND dp3.SchoolYear = d.SchoolYear - 1
	INNER JOIN nycDistrict20 dp4 ON dp4.longTract = c.Neighbor3 AND dp4.GradeLevel = d.GradeLevel AND dp4.SchoolYear = d.SchoolYear - 1
	INNER JOIN nycDistrict20 dp5 ON dp5.longTract = c.Neighbor4 AND dp5.GradeLevel = d.GradeLevel AND dp5.SchoolYear = d.SchoolYear - 1
	INNER JOIN nycDistrict20 dp6 ON dp6.longTract = c.Neighbor5 AND dp6.GradeLevel = d.GradeLevel AND dp6.SchoolYear = d.SchoolYear - 1
	INNER JOIN nycDistrict20 dp7 ON dp7.longTract = c.Neighbor6 AND dp7.GradeLevel = d.GradeLevel AND dp7.SchoolYear = d.SchoolYear - 1
	
	--INNER JOIN nycDistrict20 d3p2 ON dp2.longTract = c.Neighbor1 AND d3p2.GradeLevel = d.GradeLevel AND d3p2.SchoolYear = d.SchoolYear - 3
	--INNER JOIN nycDistrict20 d3p3 ON dp3.longTract = c.Neighbor2 AND d3p3.GradeLevel = d.GradeLevel AND d3p3.SchoolYear = d.SchoolYear - 3
	--INNER JOIN nycDistrict20 d3p4 ON dp4.longTract = c.Neighbor3 AND d3p4.GradeLevel = d.GradeLevel AND d3p4.SchoolYear = d.SchoolYear - 3
	--INNER JOIN nycDistrict20 d3p5 ON dp5.longTract = c.Neighbor4 AND d3p5.GradeLevel = d.GradeLevel AND d3p5.SchoolYear = d.SchoolYear - 3
	--INNER JOIN nycDistrict20 d3p6 ON dp6.longTract = c.Neighbor5 AND d3p6.GradeLevel = d.GradeLevel AND d3p6.SchoolYear = d.SchoolYear - 3
	--INNER JOIN nycDistrict20 d3p7 ON dp7.longTract = c.Neighbor6 AND d3p7.GradeLevel = d.GradeLevel AND d3p7.SchoolYear = d.SchoolYear - 3