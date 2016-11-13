SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests

DECLARE @sql varchar(max)
DECLARE @type varchar(50) 
DECLARE @first tinyint
SET @first = 0

DECLARE curs CURSOR FOR SELECT distinct Replace(Replace(Replace(Replace(Replace(Replace([Complaint Type],' ',''),'/',''),'-',''),'(',''),')',''),'&','')  from nyc311requests
OPEN curs

SET @sql = 'CREATE TABLE nyc311counts ('
FETCH NEXT FROM curs INTO @type
WHILE @@FETCH_STATUS=0
BEGIN
	IF @first = 0
	BEGIN
		SET @sql = @sql + ' ' + @type + ' int DEFAULT 0'
		SET @first = 1
	END
	ELSE
	BEGIN
		SET @sql = @sql + ',' + @type + ' int DEFAULT 0'
	END
	
	FETCH NEXT FROM curs INTO @type
END
CLOSE curs
DEALLOCATE curs

set @sql = @sql + ')'
print @sql
exec(@sql)