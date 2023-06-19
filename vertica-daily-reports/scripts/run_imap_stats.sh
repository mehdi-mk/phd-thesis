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
# RUN IMAP STATS                                                              #
##############################################################################

echo "External Originators of Inbound IMAP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/imap_in_orig_stats_topbytes.sql  > $OUTPUTS_PATH/"$DATE"_imap_in_orig_stats_topbytes.txt

head -23 $OUTPUTS_PATH/"$DATE"_imap_in_orig_stats_topbytes.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_imap_in_orig_stats_topbytes.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_imap_in_orig_stats_topbytes.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/imap_in_orig_stats_topbytes.txt ]]; then paste $OUTPUTS_PATH/imap_in_orig_stats_topbytes.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/imap_in_orig_stats_topbytes_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/imap_in_orig_stats_topbytes_.txt; fi;
mv $OUTPUTS_PATH/imap_in_orig_stats_topbytes_.txt $OUTPUTS_PATH/imap_in_orig_stats_topbytes.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Internal Responders of Inbound IMAP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/imap_in_resp_stats_topbytes.sql  > $OUTPUTS_PATH/"$DATE"_imap_in_resp_stats_topbytes.txt

head -23 $OUTPUTS_PATH/"$DATE"_imap_in_resp_stats_topbytes.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_imap_in_resp_stats_topbytes.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_imap_in_resp_stats_topbytes.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/imap_in_resp_stats_topbytes.txt ]]; then paste $OUTPUTS_PATH/imap_in_resp_stats_topbytes.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/imap_in_resp_stats_topbytes_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/imap_in_resp_stats_topbytes_.txt; fi;
mv $OUTPUTS_PATH/imap_in_resp_stats_topbytes_.txt $OUTPUTS_PATH/imap_in_resp_stats_topbytes.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "Internal Originators of Outbound IMAP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/imap_out_orig_stats_topbytes.sql  > $OUTPUTS_PATH/"$DATE"_imap_out_orig_stats_topbytes.txt

head -23 $OUTPUTS_PATH/"$DATE"_imap_out_orig_stats_topbytes.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_imap_out_orig_stats_topbytes.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_imap_out_orig_stats_topbytes.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/imap_out_orig_stats_topbytes.txt ]]; then paste $OUTPUTS_PATH/imap_out_orig_stats_topbytes.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/imap_out_orig_stats_topbytes_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/imap_out_orig_stats_topbytes_.txt; fi;
mv $OUTPUTS_PATH/imap_out_orig_stats_topbytes_.txt $OUTPUTS_PATH/imap_out_orig_stats_topbytes.txt

echo "" >> $REPORT_FILE

##############################################################################

echo "External Responders of Outbound IMAP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v limits=$LIMIT -f $SQL_PATH/imap_out_resp_stats_topbytes.sql  > $OUTPUTS_PATH/"$DATE"_imap_out_resp_stats_topbytes.txt

head -23 $OUTPUTS_PATH/"$DATE"_imap_out_resp_stats_topbytes.txt >> $REPORT_FILE
echo "(20 rows)" >> $REPORT_FILE
tail -3 $OUTPUTS_PATH/"$DATE"_imap_out_resp_stats_topbytes.txt >> $REPORT_FILE

tail -n+4 $OUTPUTS_PATH/"$DATE"_imap_out_resp_stats_topbytes.txt | head -n-4 | awk -F "|" -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/imap_out_resp_stats_topbytes.txt ]]; then paste $OUTPUTS_PATH/imap_out_resp_stats_topbytes.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/imap_out_resp_stats_topbytes_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/imap_out_resp_stats_topbytes_.txt; fi;
mv $OUTPUTS_PATH/imap_out_resp_stats_topbytes_.txt $OUTPUTS_PATH/imap_out_resp_stats_topbytes.txt

