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
# EXTERNAL ORGANIZATIONS SUMMARY                                             #
##############################################################################

echo "Top Organizations of Non-Scanning Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/top_organizations_inbound_nonscan.sql > $OUTPUTS_PATH/"$DATE"_top_organizations_inbound_nonscan.txt

head -23 $OUTPUTS_PATH/"$DATE"_top_organizations_inbound_nonscan.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_top_organizations_inbound_nonscan.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_top_organizations_inbound_nonscan.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/top_organizations_inbound_nonscan.txt ]]; then paste $OUTPUTS_PATH/top_organizations_inbound_nonscan.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/top_organizations_inbound_nonscan_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/top_organizations_inbound_nonscan_.txt; fi;
mv $OUTPUTS_PATH/top_organizations_inbound_nonscan_.txt $OUTPUTS_PATH/top_organizations_inbound_nonscan.txt

echo "" >> $REPORT_FILE

echo "Top Organizations of Non-Scanning Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/top_organizations_outbound_nonscan.sql > $OUTPUTS_PATH/"$DATE"_top_organizations_outbound_nonscan.txt

head -23 $OUTPUTS_PATH/"$DATE"_top_organizations_outbound_nonscan.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_top_organizations_outbound_nonscan.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_top_organizations_outbound_nonscan.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/top_organizations_outbound_nonscan.txt ]]; then paste $OUTPUTS_PATH/top_organizations_outbound_nonscan.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/top_organizations_outbound_nonscan_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/top_organizations_outbound_nonscan_.txt; fi;
mv $OUTPUTS_PATH/top_organizations_outbound_nonscan_.txt $OUTPUTS_PATH/top_organizations_outbound_nonscan.txt

