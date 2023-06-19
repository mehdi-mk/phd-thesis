#!/bin/bash

if [ $# -lt 4 ] || [ $# -gt 4 ]
then
        echo "Incorrect arguments! Usage: ./find_prominent_surged_entities.sh <search pattern> <table name> <value's column number> <prominence metric>"
        echo "----------"
	echo "(Note 1: the <search pattern> should be something specific in a table's header in the daily report files. E.g.: 'External Scanners'.)"
	echo "(Note 2: for <table name>, give a root name for the tables in Vertica. There will be two tables derived from this name, one for prominents (YOUR-GIVEN-NAME_prominents) and one for surged (YOUR-GIVEN-NAME_surged) entities.)"
	echo "(Note 3: for <value's column number>, what is the column number for the value you are considering? E.g.: 2 for Flows in the External Scanners' table. Consider '|' as the delimeter in daily reports' tables.)"
	echo "(Note 4: for <prominence metric>, define the criteria that an entity is considered prominence considering its value.)"
	exit 0
fi

PATTERN=$1
PROMINENTS_TABLE="$2"_prominents
SURGED_TABLE="$2"_surged
COLUMN_NUM=$3
PROMINENCE_METRIC=$4
DEFAULT_VALUE=-100000000

cd /data5/mehdi/vertica_daily_reports

#=======================================================================================================================
# From all the report files, grabbing the prominent entities from the table with <search pattern> in its title in the report and based 
# on the <prominence metric> provided in the parameter of this shell (upon execution). Finally arranging them based on the
# day and storing the result.

rm prominent_entities.txt

ls reports/*.txt | while read filename ; do theday=$(echo $filename | awk -F "/" '{print $2}' | awk -F "_" '{print $1}') && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -v var="$COLUMN_NUM" -v val="$PROMINENCE_METRIC" -F "|" '{if ($var > val) print $1}' | sed 's/ *$//' | sed 's/^ *//' > tmp1 && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -v var="$COLUMN_NUM" -v val="$PROMINENCE_METRIC" -F "|" '{if ($var > val) print $2}' | sed 's/ *$//' | sed 's/^ *//' | awk '{print $0}' > tmp2 && paste -d "|" tmp1 tmp2 | awk -v var=$theday -F "|" '{print var "|" $1 "|" $2}' >> prominent_entities.txt ; done
#=======================================================================================================================

#=======================================================================================================================
# Now going to reshape the file so it can be processed and loaded up by Vertica in a timeseries format. For a prominent
# entity that doesn't appear on another day, the default value is given. The days with no prominent entity will
# later be handled in the query in Grafana. The final result is stored in 'prominent_entities_final.txt' and will be 
# loaded in Vertica.

awk -F "|" '{print $1}' prominent_entities.txt | sort -n | uniq > prominent_dates.txt

counter=0
awk -F "|" '{print $2}' prominent_entities.txt | sort -n | uniq | while read ENTITY 
do
        counter=$((counter + 1))
        echo "$ENTITY" > "$counter"_entity_conns.txt

        LINES=$(awk -F "|" '{print $1}' prominent_entities.txt | sort -n | uniq | wc | awk '{print $1}')

        cat prominent_dates.txt | while read DATE
        do
                awk -v var="$ENTITY" -v val="$DATE" -v defval="$DEFAULT_VALUE" -F "|" 'BEGIN {conn=defval} {if ($1==val && $2==var) conn=$3} END {print conn}' prominent_entities.txt >> "$counter"_entity_conns.txt
        done
done

counter=$(ls | grep _entity_conns.txt | wc | awk '{print $1}')

echo "time" > prominent_entities_final.txt
cat prominent_dates.txt >> prominent_entities_final.txt

for num in $( seq 1 $counter)
do
        paste prominent_entities_final.txt "$num"_entity_conns.txt > prominent_tmp
        mv prominent_tmp prominent_entities_final.txt
done
#=======================================================================================================================

#=======================================================================================================================
# Polishing and keeping the names of the entites. It will be useful when creating the queries.

awk -F "|" '{print $2}' prominent_entities.txt | sort -n | uniq | sed 's/ /_/g' | sed 's/-/_/g' | sed 's/\./_/g' | sed 's/\"/_/g' | while read thenames; do if [[ $thenames =~ ^[1-9] ]]; then echo "$thenames" | sed 's/^/_/g'; else echo "$thenames" ; fi ; done > prominent_entities_names.txt
#=======================================================================================================================

#=======================================================================================================================
# Creating the query to create the table (prominent_entities) in the Vertica to load the data into it.

echo "CREATE TABLE "$PROMINENTS_TABLE" (" > create_prominent_entities_table.sql
echo "\"time\" TIMESTAMP NOT NULL," >> create_prominent_entities_table.sql
head -n-1 prominent_entities_names.txt | awk '{print "\42"$0"\42" " INTEGER,"}' >> create_prominent_entities_table.sql
tail -1 prominent_entities_names.txt | awk '{print "\42"$0"\42" " INTEGER )"}' >> create_prominent_entities_table.sql
#=======================================================================================================================

#=======================================================================================================================
# Creating the query to copy the data into the associated table in Vertica.
	
echo "COPY "$PROMINENTS_TABLE" (" > load_prominent_entities_table.sql
echo "time," >> load_prominent_entities_table.sql
head -n-1 prominent_entities_names.txt | awk '{print $0 ","}' >> load_prominent_entities_table.sql
tail -1 prominent_entities_names.txt | awk '{print $0 " )"}' >> load_prominent_entities_table.sql
echo "FROM LOCAL 'prominent_entities_final.txt'" >> load_prominent_entities_table.sql
echo "DELIMITER E'\t'" >> load_prominent_entities_table.sql
echo "NULL'-'" >> load_prominent_entities_table.sql
echo "SKIP 1" >> load_prominent_entities_table.sql
echo "REJECTED DATA 'rejected_prominents.out'" >> load_prominent_entities_table.sql
echo "EXCEPTIONS 'warnings_prominents.out'" >> load_prominent_entities_table.sql
echo "DIRECT;" >> load_prominent_entities_table.sql
#=======================================================================================================================

#=======================================================================================================================
# Creating the queries to truncate and drop the associated table in Vertica.

echo "TRUNCATE TABLE "$PROMINENTS_TABLE"" > truncate_prominent_entities_table.sql

echo "DROP TABLE "$PROMINENTS_TABLE"" > drop_prominent_entities_table.sql
#=======================================================================================================================

#=======================================================================================================================
# Executing the queries to truncate, drop, and (re)create the table in Vertica and load the data into it.
 
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f truncate_prominent_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f drop_prominent_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f create_prominent_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f load_prominent_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -c "GRANT ALL ON "$PROMINENTS_TABLE" TO grafana;"
#=======================================================================================================================

#=======================================================================================================================
# Creating the query to be used in Grafana to visualize the prominent entities.

echo "WITH timeline AS ( " > prominent_entities_query.sql
echo "  SELECT ts " >> prominent_entities_query.sql
echo "  FROM ( " >> prominent_entities_query.sql
echo "    SELECT '2019-11-30 01:00:00'::TIMESTAMP AS tm " >> prominent_entities_query.sql
echo "    UNION ALL " >> prominent_entities_query.sql
echo "    SELECT '2020-10-01 01:00:00'::TIMESTAMP " >> prominent_entities_query.sql
echo "  ) AS t " >> prominent_entities_query.sql
echo "  TIMESERIES ts as '1 DAY' OVER (ORDER BY t.tm) " >> prominent_entities_query.sql
echo ") " >> prominent_entities_query.sql
echo "SELECT " >> prominent_entities_query.sql
echo "  timeline.ts AS time, " >> prominent_entities_query.sql

cat prominent_entities_names.txt | while read ENTITY
do
	echo "  CASE WHEN "$PROMINENTS_TABLE"."$ENTITY" IS NULL THEN "$DEFAULT_VALUE" ELSE "$PROMINENTS_TABLE"."$ENTITY" END AS "$ENTITY", " >> prominent_entities_query.sql
done

sed '$ s/.$//' prominent_entities_query.sql | sed '$ s/.$//' > prominent_tmp
mv prominent_tmp prominent_entities_query.sql

echo "FROM timeline LEFT JOIN "$PROMINENTS_TABLE" ON timeline.ts = "$PROMINENTS_TABLE".time " >> prominent_entities_query.sql
echo "ORDER BY timeline.ts ; " >> prominent_entities_query.sql
#=======================================================================================================================

rm *_entity_conns.txt
rm prominent_dates.txt
#rm prominent_entities_names.txt

#***********************************************************************************************************************
#***********************************************************************************************************************

# FINDING THE SURGED ENTITIES

#***********************************************************************************************************************
#***********************************************************************************************************************

ls reports/*.txt | grep -P '2019-11-30' | while read filename ; do theday=$(echo $filename | awk -F "/" '{print $2}' | awk -F "_" '{print $1}') && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -F "|" '{print $1}' | sed 's/ *$//' | sed 's/^ *//' > tmp1 && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -F "|" -v var="$COLUMN_NUM" '{print $var}' | sed 's/ *$//' | sed 's/^ *//' | awk '{print $0}' > tmp2 && echo $theday > surged_entities.txt && paste -d "|" tmp1 tmp2 >> surged_entities.txt ; done

ls reports/*.txt | grep -P '2019|2020' | while read filename ; do theday=$(echo $filename | awk -F "/" '{print $2}' | awk -F "_" '{print $1}') && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -F "|" '{print $1}' | sed 's/ *$//' | sed 's/^ *//' > tmp1 && grep -A 23 -P "$PATTERN" "$filename" | tail -20 | awk -F "|" -v var="$COLUMN_NUM" '{print $var}' | sed 's/ *$//' | sed 's/^ *//' | awk '{print $0}' > tmp2 && echo $theday > tmp3 && paste -d "|" tmp1 tmp2 >> tmp3 && paste surged_entities.txt tmp3 > tmp4 && mv tmp4 surged_entities.txt ; done

echo "WITH timeline AS ( " > surged_entities_query.sql
echo "  SELECT ts " >> surged_entities_query.sql
echo "  FROM ( " >> surged_entities_query.sql
echo "    SELECT '2019-11-30 01:00:00'::TIMESTAMP AS tm " >> surged_entities_query.sql
echo "    UNION ALL " >> surged_entities_query.sql
echo "    SELECT '2020-10-01 01:00:00'::TIMESTAMP " >> surged_entities_query.sql
echo "  ) AS t " >> surged_entities_query.sql
echo "  TIMESERIES ts as '1 DAY' OVER (ORDER BY t.tm) " >> surged_entities_query.sql
echo ") " >> surged_entities_query.sql
echo "SELECT " >> surged_entities_query.sql
echo "  timeline.ts AS time, " >> surged_entities_query.sql


scp surged_entities.txt mehdi.karamollahi@rsx1.cs.ucalgary.ca:/home/research/mehdi.karamollahi/vertica_daily_reports/
scp surged_entities_query.sql mehdi.karamollahi@rsx1.cs.ucalgary.ca:/home/research/mehdi.karamollahi/vertica_daily_reports/

ssh -n mehdi.karamollahi@rsx1.cs.ucalgary.ca "cd /home/research/mehdi.karamollahi/vertica_daily_reports/ && python surged_entities.py surged_entities.txt "$SURGED_TABLE""

scp mehdi.karamollahi@rsx1.cs.ucalgary.ca:/home/research/mehdi.karamollahi/vertica_daily_reports/surged_entities_final.txt .
scp mehdi.karamollahi@rsx1.cs.ucalgary.ca:/home/research/mehdi.karamollahi/vertica_daily_reports/*_surged_entities_table.sql .
scp mehdi.karamollahi@rsx1.cs.ucalgary.ca:/home/research/mehdi.karamollahi/vertica_daily_reports/surged_entities_query.sql .

/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f truncate_surged_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f drop_surged_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f create_surged_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f load_surged_entities_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -c "GRANT ALL ON "$SURGED_TABLE" TO grafana;"

echo "Please use the queries in 'prominent_entities_query.sql' and 'surged_entities_query.sql' to visualize the tables "$PROMINENTS_TABLE" and "$SURGED_TABLE" in Grafana."
echo "Please note that these queries handle the data up to 2020-10-01. If there are reports beyond that day, modify the queries first."

rm tmp1
rm tmp2
rm tmp3

