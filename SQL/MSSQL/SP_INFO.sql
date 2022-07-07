USE <DATABASE>
GO;

SELECT
  CONCAT('[', schema_name(obj.schema_id), '].[', obj.name, ']') AS [object_name],
  schema_name(obj.schema_id) AS schema_name,
  obj.name AS procedure_name,
  CASE type
        WHEN 'P' THEN 'SQL Stored Procedure'
        WHEN 'X' THEN 'Extended stored procedure'
    END AS type,
  SUBSTRING(par.parameters, 0, LEN(par.parameters)) AS parameters,
  mod.definition,
  obj.create_date,
  obj.modify_date
FROM sys.objects AS obj
  JOIN sys.sql_modules AS mod
  ON mod.object_id = obj.object_id
CROSS APPLY (SELECT p.name + ' ' + TYPE_NAME(p.user_type_id) + ', '
  FROM sys.parameters p
  WHERE p.object_id = obj.object_id AND p.parameter_id != 0
  FOR XML PATH('')) par (parameters)
WHERE obj.type IN ('P', 'X')
ORDER BY schema_name, procedure_name;
