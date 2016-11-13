


DECLARE @latCompare numeric(12,7)
DECLARE @lngCompare numeric(12,7)
DECLARE @GEOIDCompare varchar(25)


SET @latCompare = 42.6637001	
SET @lngCompare = -73.7369472

DECLARE curs CURSOR FOR SELECT INTPTLAT, INTPTLONG, GEOID FROM census_tracts_list_36
OPEN curs


FETCH NEXT FROM curs INTO @latCompare, @lngCompare, @GEOIDCompare
WHILE @@FETCH_STATUS=0
BEGIN

	DECLARE cursCompare CURSOR FOR SELECT INTPTLAT, INTPTLONG, GEOID FROM census_tracts_list_36 WHERE GEOID <> @GEOIDCompare
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
	DELETE FROM @neighbors

	DECLARE @distance numeric(12,7)
	WHILE @cnt <= 6
	BEGIN
	   INSERT INTO @neighbors(id,lat,lng,distance,geoid)
	   VALUES(@cnt,0.000,0.000,0.000,'xx')
	   SET @cnt = @cnt + 1;
	END;
	FETCH NEXT FROM cursCompare INTO @lat, @lng, @geoID

	SET @cnt = 1

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
				FROM @neighbors one, @neighbors two WHERE one.id = 6 and two.id=5
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 5 and two.id=4
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 4 and two.id=3
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 3 and two.id=2
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 2 and two.id=1
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 1
			SET @distance6 = @distance5
			SET @distance5 = @distance4
			SET @distance4 = @distance3
			SET @distance3 = @distance2
			SET @distance2 = @distance1
			SET @distance1 = @distance
		END
		ELSE IF @distance < @distance2
		BEGIN
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 6 and two.id=5
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 5 and two.id=4
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 4 and two.id=3
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 3 and two.id=2
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 2
			SET @distance6 = @distance5
			SET @distance5 = @distance4
			SET @distance4 = @distance3
			SET @distance3 = @distance2
			SET @distance2 = @distance
		END
		ELSE IF @distance < @distance3
		BEGIN
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 6 and two.id=5
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 5 and two.id=4
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 4 and two.id=3
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 3
			SET @distance6 = @distance5
			SET @distance5 = @distance4
			SET @distance4 = @distance3
			SET @distance3 = @distance
		END
		ELSE IF @distance < @distance4
		BEGIN
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 6 and two.id=5
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 5 and two.id=4
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 4
			SET @distance6 = @distance5
			SET @distance5 = @distance4
			SET @distance4 = @distance
		END
		ELSE IF @distance < @distance5
		BEGIN
			UPDATE one SET one.distance = two.distance, one.geoid = two.geoid, one.lat = two.lat, one.lng = two.lng 
				FROM @neighbors one, @neighbors two WHERE one.id = 6 and two.id=5
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 5
			SET @distance6 = @distance5
			SET @distance5 = @distance
		END
		ELSE IF @distance < @distance6
		BEGIN
			UPDATE @neighbors SET distance = @distance, lat = @lat, lng = @lng, GEOID = @GEOID WHERE id = 6
			SET @distance6 = @distance
		END
	

	FETCH NEXT FROM cursCompare INTO @lat, @lng, @geoID

	END
	close cursCompare
	deallocate cursCompare
	
	UPDATE census_tracts_list_36 SET Neighbor1 = (SELECT GEOID FROM @neighbors WHERE id=1) WHERE GEOID = @GEOIDCompare
	UPDATE census_tracts_list_36 SET Neighbor2 = (SELECT GEOID FROM @neighbors WHERE id=2) WHERE GEOID = @GEOIDCompare
	UPDATE census_tracts_list_36 SET Neighbor3 = (SELECT GEOID FROM @neighbors WHERE id=3) WHERE GEOID = @GEOIDCompare
	UPDATE census_tracts_list_36 SET Neighbor4 = (SELECT GEOID FROM @neighbors WHERE id=4) WHERE GEOID = @GEOIDCompare
	UPDATE census_tracts_list_36 SET Neighbor5 = (SELECT GEOID FROM @neighbors WHERE id=5) WHERE GEOID = @GEOIDCompare
	UPDATE census_tracts_list_36 SET Neighbor6 = (SELECT GEOID FROM @neighbors WHERE id=6) WHERE GEOID = @GEOIDCompare
	
FETCH NEXT FROM curs INTO @latCompare, @lngCompare, @GEOIDCompare

END
close curs
deallocate curs
SELECT * from census_tracts_list_36