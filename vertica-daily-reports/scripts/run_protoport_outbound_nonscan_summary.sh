#!/bin/bash

##############################################################################
# VARIABLES TO SET                                                           #
##############################################################################

#DATE=$(date --date="yesterday" +"%Y-%m-%d")
DATE=$1
LIMIT=$2

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
# OUTBOUND PROTO/PORT SUMMARY                                                #
##############################################################################

echo "Protocol/Port Summary of Non-Scanning Outbound Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/protoport_outbound_topbytes_nonscan.sql > $OUTPUTS_PATH/"$DATE"_protoport_outbound_topbytes_nonscan.txt

head -23 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topbytes_nonscan.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topbytes_nonscan.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topbytes_nonscan.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1 "/" $3}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan.txt ]]; then paste $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan_.txt; fi;
mv $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan_.txt $OUTPUTS_PATH/protoport_outbound_topbytes_nonscan.txt

echo "" >> $REPORT_FILE

echo "Protocol/Port Summary of Non-Scanning Outbound Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/protoport_outbound_topconns_nonscan.sql > $OUTPUTS_PATH/"$DATE"_protoport_outbound_topconns_nonscan.txt

head -23 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topconns_nonscan.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topconns_nonscan.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_protoport_outbound_topconns_nonscan.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1 "/" $3}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/protoport_outbound_topconns_nonscan.txt ]]; then paste $OUTPUTS_PATH/protoport_outbound_topconns_nonscan.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/protoport_outbound_topconns_nonscan_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/protoport_outbound_topconns_nonscan_.txt; fi;
mv $OUTPUTS_PATH/protoport_outbound_topconns_nonscan_.txt $OUTPUTS_PATH/protoport_outbound_topconns_nonscan.txt


