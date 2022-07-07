#!/bin/bash
database=Example
wait_time=15s

# wait for SQL Server to come up
echo importing data will start in $wait_time...
sleep $wait_time
echo importing data...

# run the init script to create the DB and the tables in /table
/opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i ./init.sql

#create tables
for entry in ./table/*.sql; do
  echo executing table $entry
  /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i $entry
done

#import the data into tables
for entry in ./data/*.csv; do
  # i.e: transform /data/MyTable.csv to MyTable
  shortname=$(echo $(basename "$entry") | cut -f 1 -d '.')
  tableName="$database.dbo.$shortname"
  echo importing $tableName from $entry
  /opt/mssql-tools/bin/bcp $tableName in $entry -c -t',' -F 2 -S 0.0.0.0 -U sa -P $SA_PASSWORD
done

#import keys and constrants on tables
for entry in ./index/*.sql; do
  echo executing table $entry
  /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i $entry
done

#importing stored procedures
for entry in ./procedure/*.sql; do
  echo executing procedure $entry
  /opt/mssql-tools/bin/sqlcmd -S 0.0.0.0 -U sa -P $SA_PASSWORD -i $entry
done
