

DECLARE @count int
DECLARE @complaint varchar(255)
DECLARE @tract varchar(25)
DECLARE @year int
DECLARE @sql varchar(max)

DECLARE curs CURSOR FOR select count(*),Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&',''),Tract,year(convert(datetime,[created date])) from nyc311Requests
GROUP BY [complaint type],Tract,year(convert(datetime,[created date]))
ORDER BY year(convert(datetime,[created date]))
OPEN curs

FETCH NEXT FROM curs INTO @count, @complaint, @tract, @year

WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF (SELECT count(*) from nyc311Counts WHERE censusTract = @tract AND CensusYear = convert(varchar(10),@year)) > 0
	BEGIN
		SET @sql = 'UPDATE nyc311Counts SET [' + @complaint + '] = ' + convert(varchar(10),@count) + ' WHERE CensusYear = ' + convert(varchar(10),@year) + ' AND CensusTract = ''' + @tract + ''''
	END
	ELSE
	BEGIN
		SET @sql = 'INSERT INTO nyc311Counts (CensusTract,CensusYear,' + @complaint + ') VALUES(''' + @tract + ''',' + convert(varchar(10),@year) + ',' + convert(varchar(10),@count) + ')'
	END
	exec(@sql)
	
	SET @sql = 'UPDATE nyc1 SET [' + @complaint + 'Previous] = nyc2.[' + @complaint + '] FROM nyc311Counts nyc1 INNER JOIN nyc311Counts nyc2
		ON nyc2.CensusTract = nyc1.CensusTract AND nyc2.CensusYear = nyc1.CensusYear -1'
	exec(@sql)
	
	SET @sql = 'UPDATE nyc1 SET [' + @complaint + 'PreviousThree] = nyc2.[' + @complaint + '] FROM nyc311Counts nyc1 INNER JOIN nyc311Counts nyc2
		ON nyc2.CensusTract = nyc1.CensusTract AND nyc2.CensusYear = nyc1.CensusYear -3'
	exec(@sql)

	SET @sql = 'UPDATE nyc311Counts SET [' + @complaint + 'Growth] = [' + @complaint + '] - [' + @complaint + 'Previous], 
		[' + @complaint + 'GrowthThree] = [' + @complaint + '] - [' + @complaint + 'PreviousThree]'
	exec(@sql)

	SET @sql = 'UPDATE nyc311Counts SET 
		 [' + @complaint + 'PercentGrowth] = (convert(numeric(9,6),[' + @complaint + '])-[' + @complaint + 'Previous])/[' + @complaint + 'Previous] WHERE [' + @complaint + 'Previous] > 0'
	exec(@sql)

	SET @sql = 'UPDATE nyc311Counts SET 
		 [' + @complaint + 'PercentGrowthThree] = (convert(numeric(9,6),[' + @complaint + '])-[' + @complaint + 'PreviousThree])/[' + @complaint + 'PreviousThree] WHERE [' + @complaint + 'PreviousThree] > 0'
	exec(@sql)

	FETCH NEXT FROM curs INTO @count, @complaint, @tract, @year
END
close curs
deallocate curs

select * from nycDistrict20

select '360470' + censusTract, * from nyc311Counts where censusTract LIKE '%1800%'
select * from nyc311Requests where tract = '1800' 
select longTract,* from nycDistrict20 d LEFT JOIN nyc311Counts t ON '36047' + right('0000' + t.CensusTract,6)=d.LongTract AND t.CensusYear = d.SchoolYear 
AND neighborCount IS NULL
order by t.censusTract, censusYear

select '36047' + right('0000' + CensusTract,6),* from nyc311Counts WHERE censusTract like '%421%'
select distinct zip,CensusTract from nycDistrict20 WHERE Zip NOT IN (
select [Incident Zip] from nyc311Requests)
order by zip

select distinct latitude, longitude from raw311Data WHERE [incident zip] IN 
(
11203,
11206,
11212,
11212,
11216,
11217,
11221,
11230,
11231,
11232,
11235,
11238
)



36047002000