SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests

DECLARE @sql varchar(max)
DECLARE @type varchar(50) 
DECLARE @first tinyint

DECLARE curs CURSOR FOR SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests
OPEN curs

SET @sql = 'CREATE TABLE nyc311counts (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CensusTract] [varchar](50) NULL,
	[CensusYear] [int] NULL CONSTRAINT [DF_nyc311counts_CensusYear]  DEFAULT ((2000))'
FETCH NEXT FROM curs INTO @type
WHILE @@FETCH_STATUS=0
BEGIN
	SET @sql = @sql + ',' + @type + ' int DEFAULT 0'
	
	FETCH NEXT FROM curs INTO @type
END
CLOSE curs
DEALLOCATE curs

set @sql = @sql + ')'
print @sql
exec(@sql)