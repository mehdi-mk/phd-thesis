#!/bin/bash

INPUT_FILE=$1
TOPS=$2
START_DATE=$3
END_DATE=$4

ROOT_NAME=$(echo "$INPUT_FILE" | awk -F "." '{print $1}')
PART_FILE="$ROOT_NAME"_parted.txt
OUTPUT_METRICS="$ROOT_NAME"_metrics_parted.txt
OUTPUT_RANKING="$ROOT_NAME"_ranking_parted.txt
OUTPUT_METRICS_TRANSPOSED="$ROOT_NAME"_metrics_transposed_parted.txt
OUTPUT_RANKING_TRANSPOSED="$ROOT_NAME"_ranking_transposed_parted.txt
METRICS_TABLE="$ROOT_NAME"_metrics_parted
RANKING_TABLE="$ROOT_NAME"_ranking_parted

CS_SSH=MY_USER@CPSC
CS_PATH=/home/research/MY_USER/vertica_daily_reports

echo "#################################### "
echo "######## BEGINNING ANALYSIS ######## "
echo "#################################### " 
echo ""

cat $INPUT_FILE | tr -s '  ' | awk '{gsub(" \t", "\t"); gsub("\t ", "\t"); print}' | sed 's/ *$//' | sed 's/^ *//' > "$INPUT_FILE"_tr
mv "$INPUT_FILE"_tr $INPUT_FILE

head -"$((TOPS+1))" $INPUT_FILE | awk -v startdate="$START_DATE" -v enddate="$END_DATE" -F "\t" 'NR=1{for (i=1; i<=NF; i++) {if ($i == startdate) st=i}; for (j=1; j<=NF; j++) {if ($j == enddate) en=j}}{for (c=1; c<=NF; c++) if (c>=st && c<=en) {if (c==st) rows=$c; else rows=rows"\t"$c}; print rows; rows=""}' > "$PART_FILE"

scp "$PART_FILE" "$CS_SSH":"$CS_PATH"/

echo ""
echo "#==================== Running Python Code ================================ "
echo ""

ssh $CS_SSH "cd $CS_PATH && python similarity_metrics.py $PART_FILE $TOPS $OUTPUT_METRICS $OUTPUT_RANKING"

echo ""

scp "$CS_SSH":"$CS_PATH"/"$OUTPUT_METRICS" .
scp "$CS_SSH":"$CS_PATH"/"$OUTPUT_RANKING" .

echo ""
echo "#==================== Transposing the Outputs ============================ "
echo ""

./transpose_matrix.sh $OUTPUT_METRICS > $OUTPUT_METRICS_TRANSPOSED
./transpose_matrix.sh $OUTPUT_RANKING > $OUTPUT_RANKING_TRANSPOSED

echo ""

echo "create table "$METRICS_TABLE" (
\"day\" TIMESTAMP NOT NULL,
\"Identical_ness_day0\" float,
\"Identical_ness_pre\" float,
\"Set_similarity_day0\" float,
\"Set_similarity_pre\" float,
\"Absolute_rank_diff_day0\" float,
\"Absolute_rank_diff_pre\" float,
\"Relative_rank_diff_day0\" float,
\"Relative_rank_diff_pre\" float
);" > create_similarity_metrics_table_parted.sql

echo "COPY "$METRICS_TABLE" (
day,
Identical_ness_day0,
Identical_ness_pre,
Set_similarity_day0,
Set_similarity_pre,
Absolute_rank_diff_day0,
Absolute_rank_diff_pre,
Relative_rank_diff_day0,
Relative_rank_diff_pre )
from LOCAL '"$OUTPUT_METRICS_TRANSPOSED"'
DELIMITER E'\t'
NULL '-'
SKIP 1
REJECTED DATA 'rejected_metrics.out'
EXCEPTIONS 'warnings_metrics.out'
DIRECT;" > load_similarity_metrics_table_parted.sql

echo ""
echo "#==================== Creating/Updating Metrics Table ==================== "
echo ""

echo "TRUNCATE TABLE "$METRICS_TABLE"" > truncate_similarity_metrics_table_parted.sql

/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f truncate_similarity_metrics_table_parted.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f create_similarity_metrics_table_parted.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f load_similarity_metrics_table_parted.sql

echo ""

echo "create table "$RANKING_TABLE" (" > create_ranking_table_parted.sql
echo "\"time\" TIMESTAMP NOT NULL," >> create_ranking_table_parted.sql
tail -n+2 $OUTPUT_RANKING | head -n-1 | awk -F "\t" '{print "\42"$1"\42" " integer,"}' >> create_ranking_table_parted.sql
tail -1 $OUTPUT_RANKING | awk -F "\t" '{print "\42"$1"\42" " integer )"}' >> create_ranking_table_parted.sql

echo "COPY "$RANKING_TABLE" (" > load_ranking_table_parted.sql
echo "time," >> load_ranking_table_parted.sql
tail -n+2 $OUTPUT_RANKING | head -n-1 | awk -F "\t" '{print $1 ","}' >> load_ranking_table_parted.sql
tail -1 $OUTPUT_RANKING | awk -F "\t" '{print $1 " )"}' >> load_ranking_table_parted.sql
echo "FROM LOCAL '"$OUTPUT_RANKING_TRANSPOSED"'" >> load_ranking_table_parted.sql
echo "DELIMITER E'\t'" >> load_ranking_table_parted.sql
echo "NULL'-'" >> load_ranking_table_parted.sql
echo "SKIP 1" >> load_ranking_table_parted.sql
echo "REJECTED DATA 'rejected_ranking.out'" >> load_ranking_table_parted.sql 
echo "EXCEPTIONS 'warnings_ranking.out'" >> load_ranking_table_parted.sql
echo "DIRECT;" >> load_ranking_table_parted.sql 

echo "TRUNCATE TABLE "$RANKING_TABLE"" > truncate_ranking_table_parted.sql

echo "DROP TABLE "$RANKING_TABLE"" > drop_ranking_table_parted.sql

echo ""
echo "#==================== Creating/Updating Ranking Table ==================== "
echo ""

/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f truncate_ranking_table_parted.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f drop_ranking_table_parted.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f create_ranking_table_parted.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -f load_ranking_table_parted.sql

/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -c "GRANT ALL ON "$METRICS_TABLE" TO grafana;"
/opt/vertica/bin/vsql -h 192.168.0.35 -U mehdi -w CareyMartin -c "GRANT ALL ON "$RANKING_TABLE" TO grafana;"

echo ""
echo "#==================== Moving the Output Files ============================= "
echo ""

mv "$ROOT_NAME"_*.txt processed/

echo "#******************** Day Done! ******************************************* "
echo ""
echo "#=== Tables < "$METRICS_TABLE" > and < "$RANKING_TABLE" > are ready! ===# "
echo ""

