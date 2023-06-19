#!/bin/bash
#Change MY_USER and CPSC accordingly.

INPUT_FILE=$1
TOPS=$2

ROOT_NAME=$(echo "$INPUT_FILE" | awk -F "." '{print $1}')
PART_FILE="$ROOT_NAME"_parted.txt
OUTPUT_METRICS="$ROOT_NAME"_metrics.txt
OUTPUT_RANKING="$ROOT_NAME"_ranking.txt
OUTPUT_METRICS_TRANSPOSED="$ROOT_NAME"_metrics_transposed.txt
OUTPUT_RANKING_TRANSPOSED="$ROOT_NAME"_ranking_transposed.txt
METRICS_TABLE="$ROOT_NAME"_metrics
RANKING_TABLE="$ROOT_NAME"_ranking

CS_SSH=MY_USER@CPSC
CS_PATH=/home/research/MY_USER/vertica_daily_reports

echo "#################################### "
echo "########## NEW INPUT FILE ########## "
echo "#################################### " 
echo ""

cat $INPUT_FILE | tr -s '  ' | awk '{gsub(" \t", "\t"); gsub("\t ", "\t"); print}' | sed 's/ *$//' | sed 's/^ *//' > "$INPUT_FILE"_tr
mv "$INPUT_FILE"_tr $INPUT_FILE

head -"$((TOPS+1))" $INPUT_FILE > "$PART_FILE"

scp "$PART_FILE" "$CS_SSH":"$CS_PATH"/

echo ""
echo "#==================== Running Python Code ================================ "
echo ""

ssh -n $CS_SSH "cd $CS_PATH && python similarity_metrics.py $PART_FILE $TOPS $OUTPUT_METRICS $OUTPUT_RANKING"

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
);" > create_similarity_metrics_table.sql

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
DIRECT;" > load_similarity_metrics_table.sql

echo ""
echo "#==================== Creating/Updating Metrics Table ==================== "
echo ""

echo "TRUNCATE TABLE "$METRICS_TABLE"" > truncate_similarity_metrics_table.sql

/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f truncate_similarity_metrics_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f create_similarity_metrics_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f load_similarity_metrics_table.sql

echo ""

echo "create table "$RANKING_TABLE" (" > create_ranking_table.sql
echo "\"time\" TIMESTAMP NOT NULL," >> create_ranking_table.sql
tail -n+2 $OUTPUT_RANKING | head -n-1 | awk -F "\t" '{print "\42"$1"\42" " integer,"}' >> create_ranking_table.sql
tail -1 $OUTPUT_RANKING | awk -F "\t" '{print "\42"$1"\42" " integer )"}' >> create_ranking_table.sql

echo "COPY "$RANKING_TABLE" (" > load_ranking_table.sql
echo "time," >> load_ranking_table.sql
tail -n+2 $OUTPUT_RANKING | head -n-1 | awk -F "\t" '{print $1 ","}' >> load_ranking_table.sql
tail -1 $OUTPUT_RANKING | awk -F "\t" '{print $1 " )"}' >> load_ranking_table.sql
echo "FROM LOCAL '"$OUTPUT_RANKING_TRANSPOSED"'" >> load_ranking_table.sql
echo "DELIMITER E'\t'" >> load_ranking_table.sql
echo "NULL'-'" >> load_ranking_table.sql
echo "SKIP 1" >> load_ranking_table.sql
echo "REJECTED DATA 'rejected_ranking.out'" >> load_ranking_table.sql 
echo "EXCEPTIONS 'warnings_ranking.out'" >> load_ranking_table.sql
echo "DIRECT;" >> load_ranking_table.sql 

echo "TRUNCATE TABLE "$RANKING_TABLE"" > truncate_ranking_table.sql

echo "DROP TABLE "$RANKING_TABLE"" > drop_ranking_table.sql

echo ""
echo "#==================== Creating/Updating Ranking Table ==================== "
echo ""

/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f truncate_ranking_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f drop_ranking_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f create_ranking_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f load_ranking_table.sql

/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -c "GRANT ALL ON "$METRICS_TABLE" TO grafana;"
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -c "GRANT ALL ON "$RANKING_TABLE" TO grafana;"

echo ""
echo "#==================== Moving the Output Files ============================= "
echo ""

mv "$ROOT_NAME"_*.txt processed/

echo "#******************** Day Done! ******************************************* "
echo ""

