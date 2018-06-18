CREATE function dbo.UDF_LEVENSHTEIN_WEIGHT(@SourceString nvarchar(100), @TargetString nvarchar(100)) RETURNS DECIMAL(16,4) AS BEGIN
DECLARE @LevenshteinDistance int, @Weight DECIMAL(16,4)
SET @LevenshteinDistance = dbo.UDF_DAMERAU_LEVENSCHTEIN(@SourceString, @TargetString)
SET @Weight = CONVERT(DECIMAL(16,4), CASE
		WHEN LEN(@SourceString) > LEN(@TargetString) THEN (LEN(@SourceString)*1.0 - @LevenshteinDistance) / LEN(@SourceString)
		ELSE (LEN(@TargetString)*1.0 - @LevenshteinDistance) / LEN(@TargetString) END)
RETURN @Weight
END
GO