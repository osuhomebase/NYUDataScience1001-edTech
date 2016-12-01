SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests

DECLARE @sql varchar(max)
DECLARE @type varchar(50) 
DECLARE @first tinyint

-- Grab unique request types from 311 Requests... remove the obvious features that aren't good predictors --
DECLARE curs CURSOR FOR SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests 
	WHERE Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  NOT IN
	('Squeegee','RadioactiveMaterial','Snow','Lifeguard','BikeRollerSkateChronic','InvestigationsandDisciplineIAD','NONCONST','IllegalFireworks','HarboringBeesWasps','FoodPoisoning',
		'DisciplineandSuspension','CalorieLabeling','AdoptABasket','AnnualCycleInspection','APPLIANCE','BeachPoolSaunaComplaint','BottledWater','BridgeCondition',
		'DOFPropertyCityRebate','Elevator','HazardousMaterials','IllegalTreeDamage','HighwaySignDangling','BESTSiteSafety','RegistrationandTransfers','PoisonIvy','RadioactiveMaterial',
		'STARExemption','CollectionTruckNoise','FoundProperty','HighwayCondition','HighwaySignDamaged','MiscellaneousCategories','StalledSites','TaxiComplaint','XRayMachineEquipment')
OPEN curs

SET @sql = 'CREATE TABLE nyc311counts (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CensusTract] [varchar](50) NULL,
	[CensusYear] [int] NULL CONSTRAINT [DF_nyc311counts_CensusYear]  DEFAULT ((2000))'
FETCH NEXT FROM curs INTO @type
WHILE @@FETCH_STATUS=0
BEGIN
	SET @sql = @sql + ',' + @type + ' int DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'Previous int DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'Growth int DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'PercentGrowth numeric(9,6) DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'PreviousThree int DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'GrowthThree int DEFAULT 0'
	SET @sql = @sql + ',' + @type + 'PercentGrowthThree numeric(9,6) DEFAULT 0'
	
	FETCH NEXT FROM curs INTO @type
END
CLOSE curs
DEALLOCATE curs

set @sql = @sql + ')'
print @sql
exec(@sql)