CREATE FUNCTION dbo.UDF_PARSE_NAME(@NameString VARCHAR(100), @NameFormat VARCHAR(20)) RETURNS VARCHAR(100) AS
BEGIN
	--UDF_PARSE_NAME decodes a NameString into its component parts and returns it in a requested format.
	--@NameString is the raw value to be parsed.
	--@NameFormat is a string that defines the output format.  Each letter in the string represents
	--a component of the name IN the order that it is to be returned.
	--    [H] = Full honorific
	--    [h] = Abbreviated honorific
	--    [F] = First name
	--    [f] = First initial
	--    [M] = Middle name
	--    [m] = Middle initial
	--    [L] = Last name
	--    [l] = Last initial
	--    [S] = Full suffix
	--    [s] = Abbreviated suffix
	--    [.] = Period
	--    [,] = Comma
	--    [ ] = Space
	--Test variables
	-- DECLARE @NameString VARCHAR(50)
	-- DECLARE @NameFormat VARCHAR(20)
	-- SET @NameFormat = 'F M L S'
	-- SET @NameString = 'Melvin Carter, Jr'

	DECLARE @Honorific VARCHAR(20)
	DECLARE @FirstName VARCHAR(20)
	DECLARE @MiddleName VARCHAR(30)
	DECLARE @LastName VARCHAR(30)
	DECLARE @Suffix VARCHAR(20)
	DECLARE @TempString VARCHAR(100)
	DECLARE @TempString2 VARCHAR(100)
	DECLARE @IgnorePeriod CHAR(1)

	--Prepare the string

	--Make sure each period IS followed by a space character.
	SET @NameString = RTRIM(LTRIM(REPLACE(@NameString, '.', '. ')))

	--Remove disallowed characters
	DECLARE @PatternString VARCHAR(50)
	SET @PatternString = '%[^a-z ,-]%'
	WHILE patindex(@PatternString, @NameString) > 0 SET @NameString = stuff(@NameString, patindex(@PatternString, @NameString), 1, ' ')

	--Remove telephone ext
	SET @NameString = LTRIM(RTRIM(REPLACE(' ' + @NameString + ' ', ' EXT ', ' ')))

	--Eliminate double-spaces.
	WHILE CHARINDEX('  ', @NameString) > 0 SET @NameString = REPLACE(@NameString, '  ', ' ')

	--Eliminate periods
	WHILE CHARINDEX('.', @NameString) > 0 SET @NameString = REPLACE(@NameString, '.', '')

	--Remove spaces around hyphenated names
	SET @NameString = REPLACE(REPLACE(@NameString, '- ', '-'), ' -', '-')

	--Remove commas before suffixes
	SET @NameString = REPLACE(@NameString, ', Jr', ' Jr')
	SET @NameString = REPLACE(@NameString, ', Sr', ' Sr')
	SET @NameString = REPLACE(@NameString, ', II', ' II')
	SET @NameString = REPLACE(@NameString, ', III', ' III')

	--Temporarily join multi-word surnames
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' Del ', ' Del~'))
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' Van ', ' Van~'))
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' Von ', ' Von~'))
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' Mc ', ' Mc~'))
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' Mac ', ' Mac~'))
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' La ', ' La~'))
	--Must be checked before "De", to handle "De La [Surname]"s.
	SET @NameString = LTRIM(REPLACE(' ' + @NameString, ' De ', ' De~'))

	--IF the lastname IS listed first, strip it off.
	SET @TempString = RTRIM(LEFT(@NameString, CHARINDEX(' ', @NameString)))
	--Below logic now handled by joining multi-word surnames above.
	--IF @TempString IN ('VAN', 'VON', 'MC', 'Mac', 'DE') SET @TempString = RTRIM(LEFT(@NameString, CHARINDEX(' ', @NameString, LEN(@TempString)+2)))

	--Search for suffixes trailing the LastName
	SET @TempString2 = LTRIM(RIGHT(@NameString, LEN(@NameString) - LEN(@TempString)))
	SET @TempString2 = RTRIM(LEFT(@TempString2, CHARINDEX(' ', @TempString2)))

	IF RIGHT(@TempString2, 1) = ','
	BEGIN
		SET @Suffix = LEFT(@TempString2, LEN(@TempString2)-1)
		SET @LastName = LEFT(@TempString, LEN(@TempString))
	END
	IF RIGHT(@TempString, 1) = ',' SET @LastName = LEFT(@TempString, LEN(@TempString)-1)
	IF LEN(@LastName) > 0 SET @NameString = LTRIM(RIGHT(@NameString, LEN(@NameString) - LEN(@TempString)))
	IF LEN(@Suffix) > 0 SET @NameString = LTRIM(RIGHT(@NameString, LEN(@NameString) - LEN(@TempString2)))

	--Get rid of any remaining commas
	WHILE CHARINDEX(',', @NameString) > 0 SET @NameString = REPLACE(@NameString, ',', '')
	--Get Honorific and strip it out of the string
	SET @TempString = RTRIM(LEFT(@NameString, CHARINDEX(' ', @NameString + ' ')))
	IF @TempString IN (
		'Admiral', 'Adm',
		'Captain', 'Cpt', 'Capt',
		'Commander', 'Cmd',
		'Corporal', 'Cpl',
		'Doctor', 'Dr',
		'Father', 'Fr',
		'General', 'Gen',
		'Governor', 'Gov',
		'Honorable', 'Hon',
		'Lieutenant', 'Lt',
		'Madam', 'Mdm',
		'Madame', 'Mme',
		'Mademoiselle', 'Mlle',
		'Major', 'Maj',
		'Miss', 'Ms',
		'Mr',
		'Mrs',
		'President', 'Pres',
		'Private', 'Pvt',
		'Professor', 'Prof',
		'Rabbi',
		'Reverend', 'Rev',
		'Senior', 'Sr',
		'Seniora', 'Sra',
		'Seniorita', 'Srta',
		'Sergeant', 'Sgt',
		'Sir',
		'Sister') SET @Honorific = @TempString
	IF LEN(@Honorific) > 0 SET @NameString = LTRIM(RIGHT(@NameString, LEN(@NameString) - LEN(@TempString)))
	--Get Suffix and strip it out of the string
	IF @Suffix IS NULL
	BEGIN
		SET @TempString = LTRIM(RIGHT(@NameString, CHARINDEX(' ', REVERSE(@NameString) + ' ')))
		IF @TempString IN (
			'Attorney', 'Att', 'Atty',
			'BA',
			'BS',
			'CPA',
			'DDS',
			'DVM',
			'Esquire', 'Esq',
			'II',
			'III',
			'IV',
			'Junior', 'Jr',
			'MBA',
			'MD',
			'OD',
			'PHD',
			'Senior', 'Sr') SET @Suffix = @TempString
		IF LEN(@Suffix) > 0 SET @NameString = RTRIM(LEFT(@NameString, LEN(@NameString) - LEN(@TempString)))
	END

	IF @LastName IS NULL
	BEGIN
		--Get LastName and strip it out of the string
		SET @LastName = LTRIM(RIGHT(@NameString, CHARINDEX(' ', REVERSE(@NameString) + ' ')))
		SET @NameString = RTRIM(LEFT(@NameString, LEN(@NameString) - LEN(@LastName)))
		--Below logic now handled by joining multi-word surnames above.
		--Check to see IF the last name has two parts
		SET @TempString = LTRIM(RIGHT(@NameString, CHARINDEX(' ', REVERSE(@NameString) + ' ')))
		IF @TempString IN ('VAN', 'VON', 'MC', 'Mac', 'DE')
		BEGIN
			SET @LastName = @TempString + ' ' + @LastName
			SET @NameString = RTRIM(LEFT(@NameString, LEN(@NameString) - LEN(@TempString)))
		END
	END
	--Get FirstName and strip it out of the string
	SET @FirstName = RTRIM(LEFT(@NameString, CHARINDEX(' ', @NameString + ' ')))
	SET @NameString = LTRIM(RIGHT(@NameString, LEN(@NameString) - LEN(@FirstName)))
	--Anything remaining IS MiddleName
	SET @MiddleName = @NameString
	--CREATE the output string
	SET @TempString = ''
	WHILE LEN(@NameFormat) > 0
	BEGIN
		IF @IgnorePeriod = 'F' or LEFT(@NameFormat, 1) <> '.'
		BEGIN
			SET @IgnorePeriod = 'F'
			SET @TempString = @TempString +
			CASE ASCII(LEFT(@NameFormat, 1))
				WHEN '32' THEN
					CASE RIGHT(@TempString, 1)
						WHEN ' ' THEN ''
						ELSE ' '
					END
				WHEN '44' THEN
					CASE RIGHT(@TempString, 1)
						WHEN ' ' THEN ''
						ELSE ','
					END
				WHEN '46' THEN
					CASE RIGHT(@TempString, 1)
						WHEN ' ' THEN ''
						ELSE '.'
					END
				WHEN '70' THEN ISNULL(@FirstName, '')
				WHEN '72' THEN
					CASE @Honorific
						WHEN 'Adm' THEN 'Admiral'
						WHEN 'Capt' THEN 'Captain'
						WHEN 'Cmd' THEN 'Commander'
						WHEN 'Cpl' THEN 'Corporal'
						WHEN 'Cpt' THEN 'Captain'
						WHEN 'Dr' THEN 'Doctor'
						WHEN 'Fr' THEN 'Father'
						WHEN 'Gen' THEN 'General'
						WHEN 'Gov' THEN 'Governor'
						WHEN 'Hon' THEN 'Honorable'
						WHEN 'Lt' THEN 'Lieutenant'
						WHEN 'Maj' THEN 'Major'
						WHEN 'Mdm' THEN 'Madam'
						WHEN 'Mlle' THEN 'Mademoiselle'
						WHEN 'Mme' THEN 'Madame'
						WHEN 'Ms' THEN 'Miss'
						WHEN 'Pres' THEN 'President'
						WHEN 'Prof' THEN 'Professor'
						WHEN 'Pvt' THEN 'Private'
						WHEN 'Sr' THEN 'Senior'
						WHEN 'Sra' THEN 'Seniora'
						WHEN 'Srta' THEN 'Seniorita'
						WHEN 'Rev' THEN 'Reverend'
						WHEN 'Sgt' THEN 'Sergeant'
						ELSE ISNULL(@Honorific, '')
					END
				WHEN '76' THEN ISNULL(@LastName, '')
				WHEN '77' THEN ISNULL(@MiddleName, '')
				WHEN '83' THEN
					CASE @Suffix
						WHEN 'Att' THEN 'Attorney'
						WHEN 'Atty' THEN 'Attorney'
						WHEN 'Esq' THEN 'Esquire'
						WHEN 'Jr' THEN 'Junior'
						WHEN 'Sr' THEN 'Senior'
						ELSE ISNULL(@Suffix, '')
					END
				WHEN '102' THEN ISNULL(LEFT(@FirstName, 1), '')
				WHEN '104' THEN
					CASE @Honorific
						WHEN 'Admiral' THEN 'Adm'
						WHEN 'Captain' THEN 'Capt'
						WHEN 'Commander' THEN 'Cmd'
						WHEN 'Corporal' THEN 'Cpl'
						WHEN 'Doctor' THEN 'Dr'
						WHEN 'Father' THEN 'Fr'
						WHEN 'General' THEN 'Gen'
						WHEN 'Governor' THEN 'Gov'
						WHEN 'Honorable' THEN 'Hon'
						WHEN 'Lieutenant' THEN 'Lt'
						WHEN 'Madam' THEN 'Mdm'
						WHEN 'Madame' THEN 'Mme'
						WHEN 'Mademoiselle' THEN 'Mlle'
						WHEN 'Major' THEN 'Maj'
						WHEN 'Miss' THEN 'Ms'
						WHEN 'President' THEN 'Pres'
						WHEN 'Private' THEN 'Pvt'
						WHEN 'Professor' THEN 'Prof'
						WHEN 'Reverend' THEN 'Rev'
						WHEN 'Senior' THEN 'Sr'
						WHEN 'Seniora' THEN 'Sra'
						WHEN 'Seniorita' THEN 'Srta'
						WHEN 'Sergeant' THEN 'Sgt'
						ELSE ISNULL(@Honorific, '')
					END
				WHEN '108' THEN ISNULL(LEFT(@LastName, 1), '')
				WHEN '109' THEN ISNULL(LEFT(@MiddleName, 1), '')
				WHEN '115' THEN
					CASE @Suffix
						WHEN 'Attorney' THEN 'Atty'
						WHEN 'Esquire' THEN 'Esq'
						WHEN 'Junior' THEN 'Jr'
						WHEN 'Senior' THEN 'Sr'
						ELSE ISNULL(@Suffix, '')
					END
				ELSE ''
			END
			--The following honorifics and suffixes have no further abbreviations, and so should not be followed by a period:
			IF ((ASCII(LEFT(@NameFormat, 1)) = 72 AND @Honorific IN ('Rabbi', 'Sister'))
				OR (ASCII(LEFT(@NameFormat, 1)) = 115 AND @Suffix IN ('BA', 'BS', 'DDS', 'DVM', 'II', 'III', 'IV', 'V', 'MBA', 'MD', 'PHD')))
			SET @IgnorePeriod = 'T'
		END
		SET @NameFormat = RIGHT(@NameFormat, LEN(@NameFormat) - 1)
	END
	RETURN REPLACE(@TempString, '~', ' ')
END
GO
