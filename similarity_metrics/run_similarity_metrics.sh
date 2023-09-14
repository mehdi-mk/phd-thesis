#!/bin/bash

INPUT_FILE=$1
TOPS=$2
TABLE_NAME=$(awk -F "." '{print $1}' "$INPUT_FILE")
OUTPUT_METRICS="$TABLE_NAME"_metrics.txt
OUTPUT_RANKING="$TABLE_NAME"_ranking.txt
OUTPUT_METRICS_TRANSPOSED="$TABLE_NAME"_metrics_transposed.txt
OUTPUT_RANKING_TRANSPOSED="$TABLE_NAME"_ranking_transposed.txt

python similarity_metrics.py $INPUT_FILE $TOPS $OUTPUT_METRICS $OUTPUT_RANKING

./transpose_matrix.sh $OUTPUT_METRICS > $OUTPUT_METRICS_TRANSPOSED
./transpose_matrix.sh $OUTPUT_RANKING > $OUTPUT_RANKING_TRANSPOSED

echo "create table "$TABLE_NAME" (
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

echo "COPY "$TABLE_NAME" (
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
REJECTED DATA 'rejected.out'
EXCEPTIONS 'warnings.out'
DIRECT;" > load_similarity_metrics_table.sql


