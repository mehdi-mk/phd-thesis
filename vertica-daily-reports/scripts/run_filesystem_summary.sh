#!/bin/bash

##############################################################################
# VARIABLES TO SET                                                           #
##############################################################################

#DATE=$(date --date="yesterday" +"%Y-%m-%d")
DATE=$1

VSQL=/opt/vertica/bin/vsql
DB_HOST=192.168.0.35
DB_USER=report
DB_PASSWORD=R3port

SQL_PATH=/data5/mehdi/vertica_daily_reports/sql
REPORT_FILE=/data5/mehdi/vertica_daily_reports/reports/"$DATE"_report.txt
LOGS_PATH=/data5/mehdi/vertica_daily_reports/logs
REJ_PATH=/data5/mehdi/vertica_daily_reports/rejected-warnings
OUTPUTS_PATH=/data5/mehdi/vertica_daily_reports/outputs

##############################################################################
# FILESYSTEM SUMMARY                                                         #
##############################################################################

YEAR=$(date -d "$DATE" | awk '{print $6}')
MONTH=$(date -d "$DATE" | awk '{print $2}')
NUM=$(date -d "$DATE" | awk '{print $3}')
DAY=$(date -d "$DATE" | awk '{print $1}')

if [[ $NUM -gt 9 ]]; then PATTERN="$DAY $MONTH $NUM"; else PATTERN="$DAY $MONTH  $NUM"; fi

cat /data5/orwelllogs/dailydiskusage.log | grep -A 8 $YEAR | grep -A 8 "$PATTERN" >> $REPORT_FILE

