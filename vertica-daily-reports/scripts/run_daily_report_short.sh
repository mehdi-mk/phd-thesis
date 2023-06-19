#!/bin/bash

##############################################################################
# VARIABLES TO SET                                                           #
##############################################################################

#DATE=$(date --date="yesterday" +"%Y-%m-%d")
DATE=$1
LIMIT=100

VSQL=/opt/vertica/bin/vsql
DB_HOST=192.168.0.35
DB_USER=report
DB_PASSWORD=R3port

SQL_PATH=/data5/mehdi/vertica_daily_reports/sql
REPORT_FILE=/data5/mehdi/vertica_daily_reports/reports/"$DATE"_report.txt
LOGS_PATH=/data5/mehdi/vertica_daily_reports/logs
REJ_PATH=/data5/mehdi/vertica_daily_reports/rejected-warnings
OUTPUTS_PATH=/data5/mehdi/vertica_daily_reports/outputs
SCRIPTS_PATH=/data5/mehdi/vertica_daily_reports/scripts

##############################################################################
# LOAD LOGS INTO VERTICA                                                     #
##############################################################################

$SCRIPTS_PATH/run_load_logs.sh $DATE

##############################################################################
# RUN ANALYSIS SCRIPTS                                                       #
##############################################################################

$SCRIPTS_PATH/run_organizations_nonscan_summary.sh $DATE $LIMIT

$SCRIPTS_PATH/run_scanning_summary.sh $DATE $LIMIT

$SCRIPTS_PATH/run_cleanup.sh $DATE

#echo "The daily report from Vertica is attached." | mail -s "Daily report" -a $REPORT_FILE mehdi.karamollahi@ucalgary.ca

