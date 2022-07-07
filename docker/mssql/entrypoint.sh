#!/bin/bash
wait_time=15s

# wait for SQL Server to come up
echo importing data will start in $wait_time...
sleep $wait_time
echo importing data...

# run the init script to create the DB and the tables in /table
# /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i ./init.sql

for directory in ./database/* ; do
  database=$(echo `basename "$directory"`);
  # Database
  for file in $directory/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i $file
  done

  # Schema
  for file in $directory/*/Schema/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # Functions
  for file in $directory/*/Functions/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # UserDefinedTypes
  for file in $directory/*/UserDefinedTypes/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # Tables
  for file in $directory/*/Tables/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # Constraints
  for file in $directory/*/Constraints/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # Synonyms
  for file in $directory/*/Synonyms/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # Views
  for file in $directory/*/Views/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # StoredProcedures
  for file in $directory/*/StoredProcedures/*.sql; do
    echo "executing $file"
    /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -i $file
  done

  # # Disable constraints for all tables in the database:
  # /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -q "EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'"

  # TODO: Load data

  # # Re-enable constraints for all tables in the database:
  # /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -d "$database" -q "EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'"
done