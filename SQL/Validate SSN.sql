CREATE FUNCTION dbo.REGEX_REMOVE_ALL(@str NVARCHAR(MAX), @regex NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS
BEGIN
	WHILE PATINDEX(@regex, @str) > 0 BEGIN SET @str = STUFF(@str, PATINDEX(@regex, @str), 1, '') END
	RETURN @str
END;
GO

-- Disable all constraints for JIMI
USE JIMI_DUSTIN
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
GO

-- Add temporary column 
ALTER TABLE JIMI_DUSTIN.dbo.jimi_client ADD ssn_formated VARCHAR(255) NULL
GO

UPDATE JIMI_DUSTIN.dbo.jimi_client
SET ssn_formated = dbo.REGEX_REMOVE_ALL(ssn, '%[^0-9]%')
GO
/*
UPDATE JIMI_DUSTIN.dbo.jimi_client
SET ssn_formated = NULL
WHERE ssn_formated = ''
	OR LEN(jimi_client.ssn_formated) != 9
	OR jimi_client.ssn_formated NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	OR jimi_client.ssn_formated LIKE '000[0-9][0-9][0-9][0-9][0-9][0-9]' OR jimi_client.ssn_formated LIKE '[0-9][0-9][0-9]00[0-9][0-9][0-9][0-9]' OR jimi_client.ssn_formated LIKE '[0-9][0-9][0-9][0-9][0-9]0000'
	OR jimi_client.ssn_formated LIKE '999999999'
GO
*/

SELECT DISTINCT
	jimi_client.ssn_formated,
	jimi_client.ssn,
	client.id AS STELLA_ID,
	FLOOR(DATEDIFF(DAY, client.date_created, GETDATE()) / 365.25) AS STELLA_AGE,
	(SELECT COUNT(client_map.id) FROM STELLA_DUSTIN.dbo.client_map WHERE client_map.client_id = client.id) AS CLIENT_MAP_COUNT,
	(SELECT COUNT(encounter.id) FROM STELLA_DUSTIN.dbo.encounter INNER JOIN STELLA_DUSTIN.dbo.client_map ON encounter.client_map_id = client_map.id WHERE client_map.client_id = client.id) AS STELLA_ENC_COUNT,
	jimi_client.id AS JIMI_ID,
	FLOOR(DATEDIFF(DAY, jimi_client.client_added, GETDATE()) / 365.25) AS JIMI_AGE,
	(SELECT COUNT(jimi_client_que_entry.id) FROM JIMI_DUSTIN.dbo.jimi_client_que_entry WHERE jimi_client_que_entry.client_id = jimi_client.id) AS QUE_COUNT,
	(SELECT COUNT(jimi_client_encounter.id) FROM JIMI_DUSTIN.dbo.jimi_client_encounter WHERE jimi_client_encounter.client_id = jimi_client.id) AS JIMI_ENC_COUNT,
	(SELECT COUNT(jimi_client_med.id) FROM JIMI_DUSTIN.dbo.jimi_client_med WHERE jimi_client_med.client_id = jimi_client.id) AS MED_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match.id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match WHERE jimi_bookin_potential_match.client_id_match = jimi_client.id) AS CONFIRMED_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match_jimi_client.jimi_bookin_potential_match_clients_id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match_jimi_client WHERE jimi_bookin_potential_match_jimi_client.jimi_client_id = jimi_client.id) AS POTENTIAL_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match_jimi_client.jimi_bookin_potential_match_no_match_clients_id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match_jimi_client WHERE jimi_bookin_potential_match_jimi_client.jimi_client_id = jimi_client.id) AS NOMATCH_COUNT
FROM JIMI_DUSTIN.dbo.jimi_client
LEFT OUTER JOIN STELLA_DUSTIN.dbo.client
	ON jimi_client.lcn = client.lcn AND jimi_client.clientid = client.id_client
WHERE NOT EXISTS (SELECT TOP 1 jimi_client_que_entry.id FROM JIMI_DUSTIN.dbo.jimi_client_que_entry WHERE jimi_client_que_entry.client_id = jimi_client.id)
	--AND FLOOR(DATEDIFF(DAY, jimi_client.client_added, GETDATE()) / 365.25) > 2
	AND (jimi_client.ssn_formated IS NULL
		OR LEN(jimi_client.ssn_formated) != 9
		--OR jimi_client.ssn_formated NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		OR jimi_client.ssn_formated LIKE '000[0-9][0-9][0-9][0-9][0-9][0-9]' OR jimi_client.ssn_formated LIKE '[0-9][0-9][0-9]00[0-9][0-9][0-9][0-9]' OR jimi_client.ssn_formated LIKE '[0-9][0-9][0-9][0-9][0-9]0000'
		OR jimi_client.ssn_formated LIKE '999999999')
ORDER BY ssn_formated, ssn--, STELLA_AGE, JIMI_AGE
GO

-- Remove temporary column 
ALTER TABLE JIMI_DUSTIN.dbo.jimi_client DROP COLUMN ssn_formated
GO

-- Enable all constraints for JIMI
USE JIMI_DUSTIN
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
GO

/* STELLA */
-- Disable all constraints for STELLA
USE STELLA_DUSTIN
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
GO

-- Add temporary column 
ALTER TABLE STELLA_DUSTIN.dbo.client ADD ssn_formated VARCHAR(255) NULL
GO

UPDATE STELLA_DUSTIN.dbo.client
SET ssn_formated = dbo.REGEX_REMOVE_ALL(idssn, '%[^0-9]%')
GO

UPDATE STELLA_DUSTIN.dbo.client
SET ssn_formated = NULL
WHERE ssn_formated = ''
GO

SELECT DISTINCT
	client.ssn_formated,
	client.idssn,
	client.id AS STELLA_ID,
	FLOOR(DATEDIFF(DAY, client.date_created, GETDATE()) / 365.25) AS STELLA_AGE,
	(SELECT COUNT(client_map.id) FROM STELLA_DUSTIN.dbo.client_map WHERE client_map.client_id = client.id) AS CLIENT_MAP_COUNT,
	(SELECT COUNT(encounter.id) FROM STELLA_DUSTIN.dbo.encounter INNER JOIN STELLA_DUSTIN.dbo.client_map ON encounter.client_map_id = client_map.id WHERE client_map.client_id = client.id) AS STELLA_ENC_COUNT,
	jimi_client.id AS JIMI_ID,
	FLOOR(DATEDIFF(DAY, jimi_client.client_added, GETDATE()) / 365.25) AS JIMI_AGE,
	(SELECT COUNT(jimi_client_que_entry.id) FROM JIMI_DUSTIN.dbo.jimi_client_que_entry WHERE jimi_client_que_entry.client_id = jimi_client.id) AS QUE_COUNT,
	(SELECT COUNT(jimi_client_encounter.id) FROM JIMI_DUSTIN.dbo.jimi_client_encounter WHERE jimi_client_encounter.client_id = jimi_client.id) AS ENC_COUNT,
	(SELECT COUNT(jimi_client_med.id) FROM JIMI_DUSTIN.dbo.jimi_client_med WHERE jimi_client_med.client_id = jimi_client.id) AS MED_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match.id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match WHERE jimi_bookin_potential_match.client_id_match = jimi_client.id) AS CONFIRMED_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match_jimi_client.jimi_bookin_potential_match_clients_id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match_jimi_client WHERE jimi_bookin_potential_match_jimi_client.jimi_client_id = jimi_client.id) AS POTENTIAL_COUNT,
	(SELECT COUNT(jimi_bookin_potential_match_jimi_client.jimi_bookin_potential_match_no_match_clients_id) FROM JIMI_DUSTIN.dbo.jimi_bookin_potential_match_jimi_client WHERE jimi_bookin_potential_match_jimi_client.jimi_client_id = jimi_client.id) AS NOMATCH_COUNT
FROM STELLA_DUSTIN.dbo.client
LEFT OUTER JOIN JIMI_DUSTIN.dbo.jimi_client
	ON jimi_client.lcn = client.lcn AND jimi_client.clientid = client.id_client
WHERE NOT EXISTS (SELECT TOP 1 jimi_client_que_entry.id FROM JIMI_DUSTIN.dbo.jimi_client_que_entry WHERE jimi_client_que_entry.client_id = jimi_client.id)
	AND FLOOR(DATEDIFF(DAY, client.date_created, GETDATE()) / 365.25) > 2
	AND (client.ssn_formated IS NULL
		OR LEN(client.ssn_formated) != 9
		OR client.ssn_formated NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		OR client.ssn_formated LIKE '000[0-9][0-9][0-9][0-9][0-9][0-9]' OR client.ssn_formated LIKE '[0-9][0-9][0-9]00[0-9][0-9][0-9][0-9]' OR client.ssn_formated LIKE '[0-9][0-9][0-9][0-9][0-9]0000'
		OR client.ssn_formated LIKE '999999999')
ORDER BY ssn_formated, idssn, STELLA_AGE, JIMI_AGE
GO

-- Remove temporary column 
ALTER TABLE STELLA_DUSTIN.dbo.client DROP COLUMN ssn_formated
GO

-- Enable all constraints for STELLA
USE STELLA_DUSTIN
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
GO

DROP FUNCTION dbo.REGEX_REMOVE_ALL
GO