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
DAILY_SINGLES_OUTPUTS=/data5/mehdi/vertica_daily_reports/daily_singles_outputs

##############################################################################
# CLEAN UP                                                                   #
##############################################################################

mkdir $LOGS_PATH/$DATE
mv $LOGS_PATH/conn*log.gz $LOGS_PATH/$DATE/
#mv $LOGS_PATH/dns*log.gz $LOGS_PATH/$DATE/
mv $OUTPUTS_PATH/"$DATE"_* $DAILY_SINGLES_OUTPUTS/

rm $OUTPUTS_PATH/temporary

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/truncate_conn_table.sql
#$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/truncate_dns_table.sql

