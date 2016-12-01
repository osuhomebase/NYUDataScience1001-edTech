select c.*, 
IsNull(c1.[count],0) + IsNull(c2.[count],0) + IsNull(c3.[count],0) + IsNull(c4.[count],0) + IsNull(c5.[count],0) + IsNull(c6.[count],0) as neighborCount,
IsNull(c1.ThreeYearGrowthmavg3,0) + IsNull(c2.ThreeYearGrowthmavg3,0) + IsNull(c3.ThreeYearGrowthmavg3,0) + IsNull(c4.ThreeYearGrowthmavg3,0) + IsNull(c5.ThreeYearGrowthmavg3,0) + IsNull(c6.ThreeYearGrowthmavg3,0) as neighborThreeYearGrowthmavg3,
IsNull(c1.ThreeYearGrowth,0) + IsNull(c2.ThreeYearGrowth,0) + IsNull(c3.ThreeYearGrowth,0) + IsNull(c4.ThreeYearGrowth,0) + IsNull(c5.ThreeYearGrowth,0) + IsNull(c6.ThreeYearGrowth,0) as neighborThreeYearGrowth
from cleantable c inner join census_tracts_list_36 ct on c.LongTract = ct.GEOID
left join cleantable c1 on c1.LongTract = ct.Neighbor1 and c1.GradeLevel = c.GradeLevel and c1.SchoolYear = c.SchoolYear
left join cleantable c2 on c2.LongTract = ct.Neighbor1 and c2.GradeLevel = c.GradeLevel and c2.SchoolYear = c.SchoolYear
left join cleantable c3 on c3.LongTract = ct.Neighbor1 and c3.GradeLevel = c.GradeLevel and c3.SchoolYear = c.SchoolYear
left join cleantable c4 on c4.LongTract = ct.Neighbor1 and c4.GradeLevel = c.GradeLevel and c4.SchoolYear = c.SchoolYear
left join cleantable c5 on c5.LongTract = ct.Neighbor1 and c5.GradeLevel = c.GradeLevel and c5.SchoolYear = c.SchoolYear
left join cleantable c6 on c6.LongTract = ct.Neighbor1 and c6.GradeLevel = c.GradeLevel and c6.SchoolYear = c.SchoolYear