select * from census_tracts_list_36 


DECLARE @latCompare numeric(12,7)
DECLARE @lngCompare numeric(12,7)
SET @latCompare = 42.6637001	
SET @lngCompare = -73.7369472
DECLARE cursCompare CURSOR FOR SELECT INTPTLAT, INTPTLONG, GEOID FROM census_tracts_list_36
OPEN cursCompare

DECLARE @Neighbor1 varchar(25)
DECLARE @Neighbor2 varchar(25)
DECLARE @Neighbor3 varchar(25)
DECLARE @Neighbor4 varchar(25)
DECLARE @Neighbor5 varchar(25)
DECLARE @Neighbor6 varchar(25)
DECLARE @lat numeric(12,7)
DECLARE @lng numeric(12,7)
DECLARE @GEOID varchar(25)

DECLARE @neighbors TABLE(id int, lat numeric(12,7), lng numeric(12,7), distance numeric(12,7),geoid varchar(25))
DECLARE @cnt INT = 1;

	DECLARE @distance numeric(12,7)
WHILE @cnt <= 6
BEGIN
   INSERT INTO @neighbors(id,lat,lng,distance,geoid)
   VALUES(@cnt,0.000,0.000,0.000,'xx')
   SET @cnt = @cnt + 1;
END;
FETCH NEXT FROM cursCompare INTO @lat, @lng, @geoID

DECLARE @distance1 numeric(12,7)
DECLARE @distance2 numeric(12,7)
DECLARE @distance3 numeric(12,7)
DECLARE @distance4 numeric(12,7)
DECLARE @distance5 numeric(12,7)
DECLARE @distance6 numeric(12,7)
SET @distance1 = 1000.00
SET @distance2 = 1000.00
SET @distance3 = 1000.00
SET @distance4 = 1000.00
SET @distance5 = 1000.00
SET @distance6 = 1000.00

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @distance = SQUARE(@lat-@latCompare) + SQUARE(@lng-@lngCompare)

	if @distance < @distance1
	BEGIN
		UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
			FROM @neighbors one INNER JOIN @neighbors two ON one.geoid = two.geoid AND one.id = 6 and two.id=5
		UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
			FROM @neighbors one INNER JOIN @neighbors two ON one.geoid = two.geoid AND one.id = 5 and two.id=4
		UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
			FROM @neighbors one INNER JOIN @neighbors two ON one.geoid = two.geoid AND one.id = 4 and two.id=3
		UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
			FROM @neighbors one INNER JOIN @neighbors two ON one.geoid = two.geoid AND one.id = 3 and two.id=2
		UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
			FROM @neighbors one INNER JOIN @neighbors two ON one.geoid = two.geoid AND one.id = 2 and two.id=1
		UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, @GEOID = @GEOID WHERE id = 1
		SET @distance6 = @distance5
		SET @distance5 = @distance4
		SET @distance4 = @distance3
		SET @distance3 = @distance2
		SET @distance2 = @distance1
		SET @distance1 = @distance
	END
	

FETCH NEXT FROM cursCompare INTO @lat, @lng, @geoID

END
close cursCompare
deallocate cursCompare

SELECT @distance
SELECT * FROM @neighbors