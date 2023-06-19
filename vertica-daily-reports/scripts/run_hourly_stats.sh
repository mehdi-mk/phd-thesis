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
# RUN HOURLY STATS                                                           #
##############################################################################

echo "Hourly Connections:" >> $REPORT_FILE

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_conns_bytes.sql > $OUTPUTS_PATH/"$DATE"_hourly_conns_bytes.txt
cat $OUTPUTS_PATH/"$DATE"_hourly_conns_bytes.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_hourly_conns_bytes.txt | head -n-4 | awk -v today=$DATE '{print today, $1 ":00:00", $2, $3}' >> $OUTPUTS_PATH/hourly_conns.txt

tail -n+4 $OUTPUTS_PATH/"$DATE"_hourly_conns_bytes.txt | head -n-4 | awk -v today=$DATE '{print today, $1 ":00:00", $2, $5}' >> $OUTPUTS_PATH/hourly_bytes.txt

echo "" >> $REPORT_FILE

echo "Hourly Outbound TCP Connections:" >> $REPORT_FILE

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_tcp_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Hourly Inbound TCP Connections:" >> $REPORT_FILE

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_tcp_in.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Hourly Outbound UDP Connections:" >> $REPORT_FILE

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_udp_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Hourly Inbound UDP Connections:" >> $REPORT_FILE

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_udp_in.sql >> $REPORT_FILE

