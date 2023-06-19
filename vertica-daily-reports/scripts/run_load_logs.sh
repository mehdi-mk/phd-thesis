#!/bin/bash
# Change MY_USER and ARC accordingly.
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
# LOAD LOGS INTO VERTICA                                                     #
##############################################################################


scp MY_USER@ARC/$DATE/conn.*gz $LOGS_PATH/
#scp MY_USER@ARC/$DATE/dns.*gz $LOGS_PATH/

#mv $LOGS_PATH/$DATE/*gz $LOGS_PATH/

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v logpath=$LOGS_PATH -v rejpath=$REJ_PATH -f $SQL_PATH/load_conn_table_v6.sql
#$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v logpath=$LOGS_PATH -v rejpath=$REJ_PATH -f $SQL_PATH/load_dns_table_v6.sql

