CREATE FUNCTION YEARS_BETWEEN(IN FROM_DATE DATE, IN TO_DATE DATE) RETURNS YEARS_BETWEEN INTEGER
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN
	-- two step approach:
	-- first see the difference in the YEAR component
	-- second see if MMDD of TO_DATE is larger than MMDD of FROM_DATE
	-- this is to see if the day of the year has already passed or is still to come
	-- if the day has passed already, the last year counts, else it doesn't
	DECLARE FROM_TEMP, TO_TEMP DATE;
DECLARE Y1, Y2 , YEAR_DIFF, MMDD_FROM, MMDD_TO INTEGER;
-- check IF either of the entries is NULL
IF coalesce(:FROM_DATE, :TO_DATE) IS NULL
		THEN YEARS_BETWEEN := NULL;
END
IF;

-- get dates in order. FROM_DATE should be smaller than TO_DATE
	IF (:FROM_DATE > :TO_DATE) -- get dates in order
		THEN
			FROM_TEMP := :TO_DATE;
			TO_TEMP := :FROM_DATE;
	ELSE
		FROM_TEMP := :FROM_DATE;
		TO_TEMP := :TO_DATE;
END
IF;

-- year value extraction
	Y1 := YEAR
(FROM_TEMP);
	Y2 := YEAR
(TO_TEMP);

-- assign the MMDD values, multiply MM by 100 to perform shift to the left
	MMDD_FROM := MONTH
(:FROM_TEMP) * 100 + DAYOFMONTH
(:FROM_TEMP);
	MMDD_TO := MONTH
(:TO_TEMP) * 100 + DAYOFMONTH
(:TO_TEMP);
	YEAR_DIFF := :Y2 - :Y1;

IF (:MMDD_TO < :MMDD_FROM) AND
(:YEAR_DIFF > 0)
		THEN -- last year is not completed yet
			YEAR_DIFF = :YEAR_DIFF -1;
END
IF;
	YEARS_BETWEEN := :YEAR_DIFF;
END;

