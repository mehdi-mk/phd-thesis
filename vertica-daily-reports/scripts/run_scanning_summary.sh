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
# SCANNING SUMMARY                                                           #
##############################################################################

echo "Internal Scanners (Protocol/Scanner/Port/State):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanners_internal.sql > $OUTPUTS_PATH/"$DATE"_scanners_internal.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanners_internal.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanners_internal.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanners_internal.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanners_internal.txt ]]; then paste $OUTPUTS_PATH/scanners_internal.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanners_internal_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanners_internal_.txt; fi;
mv $OUTPUTS_PATH/scanners_internal_.txt $OUTPUTS_PATH/scanners_internal.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Internal Targets of Inbound Scanning:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanning_internal_targets.sql > $OUTPUTS_PATH/"$DATE"_scanning_internal_targets.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanning_internal_targets.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanning_internal_targets.txt >> $REPORT_FILE 

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanning_internal_targets.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanning_internal_targets.txt ]]; then paste $OUTPUTS_PATH/scanning_internal_targets.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanning_internal_targets_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanning_internal_targets_.txt; fi;
mv $OUTPUTS_PATH/scanning_internal_targets_.txt $OUTPUTS_PATH/scanning_internal_targets.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "External Scanners:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanners_external.sql > $OUTPUTS_PATH/"$DATE"_scanners_external.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanners_external.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanners_external.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanners_external.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanners_external.txt ]]; then paste $OUTPUTS_PATH/scanners_external.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanners_external_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanners_external_.txt; fi;
mv $OUTPUTS_PATH/scanners_external_.txt $OUTPUTS_PATH/scanners_external.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Top Scanned Ports on Inbound Scanning Activity:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanning_top_ports_inbound.sql > $OUTPUTS_PATH/"$DATE"_scanning_top_ports_inbound.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanning_top_ports_inbound.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanning_top_ports_inbound.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanning_top_ports_inbound.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1 "/" $3}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanning_top_ports_inbound.txt ]]; then paste $OUTPUTS_PATH/scanning_top_ports_inbound.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanning_top_ports_inbound_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanning_top_ports_inbound_.txt; fi;
mv $OUTPUTS_PATH/scanning_top_ports_inbound_.txt $OUTPUTS_PATH/scanning_top_ports_inbound.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Top Scanned TCP Ports on Inbound Scanning Activity:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanning_top_tcp_ports_inbound.sql > $OUTPUTS_PATH/"$DATE"_scanning_top_tcp_ports_inbound.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanning_top_tcp_ports_inbound.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanning_top_tcp_ports_inbound.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanning_top_tcp_ports_inbound.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanning_top_tcp_ports_inbound.txt ]]; then paste $OUTPUTS_PATH/scanning_top_tcp_ports_inbound.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanning_top_tcp_ports_inbound_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanning_top_tcp_ports_inbound_.txt; fi;
mv $OUTPUTS_PATH/scanning_top_tcp_ports_inbound_.txt $OUTPUTS_PATH/scanning_top_tcp_ports_inbound.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Top Scanned UDP Ports on Inbound Scanning Activity:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/scanning_top_udp_ports_inbound.sql > $OUTPUTS_PATH/"$DATE"_scanning_top_udp_ports_inbound.txt

head -23 $OUTPUTS_PATH/"$DATE"_scanning_top_udp_ports_inbound.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_scanning_top_udp_ports_inbound.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_scanning_top_udp_ports_inbound.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/scanning_top_udp_ports_inbound.txt ]]; then paste $OUTPUTS_PATH/scanning_top_udp_ports_inbound.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/scanning_top_udp_ports_inbound_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/scanning_top_udp_ports_inbound_.txt; fi;
mv $OUTPUTS_PATH/scanning_top_udp_ports_inbound_.txt $OUTPUTS_PATH/scanning_top_udp_ports_inbound.txt

