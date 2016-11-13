

DECLARE @count int
DECLARE @complaint varchar(255)
DECLARE @tract varchar(25)
DECLARE @year int
DECLARE @sql varchar(max)

DECLARE curs CURSOR FOR select count(*),Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&',''),Tract,year(convert(datetime,[created date])) from nyc311Requests
GROUP BY [complaint type],Tract,year(convert(datetime,[created date]))
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
	FETCH NEXT FROM curs INTO @count, @complaint, @tract, @year
END
close curs
deallocate curs

select * from nyc311Counts