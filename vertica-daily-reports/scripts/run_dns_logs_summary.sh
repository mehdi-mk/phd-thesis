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
# DNS LOGS SUMMARY                                                           #
##############################################################################

echo "Top Queries on Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_queries_out.sql > $OUTPUTS_PATH/"$DATE"_dns_top_queries_out.txt
cat $OUTPUTS_PATH/"$DATE"_dns_top_queries_out.txt >> $REPORT_FILE
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_top_queries_out.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/dns_top_queries_out.txt ]]; then paste $OUTPUTS_PATH/dns_top_queries_out.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/dns_top_queries_out_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_top_queries_out_.txt; fi;
mv $OUTPUTS_PATH/dns_top_queries_out_.txt $OUTPUTS_PATH/dns_top_queries_out.txt

echo "" >> $REPORT_FILE

echo "Top Answers on Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_answers_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top Queries on Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_queries_in.sql > $OUTPUTS_PATH/"$DATE"_dns_top_queries_in.txt
cat $OUTPUTS_PATH/"$DATE"_dns_top_queries_in.txt >> $REPORT_FILE
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_top_queries_in.txt | head -n-4 | awk -v today=$DATE 'BEGIN{print today}{print $1}' > $OUTPUTS_PATH/temporary
if [[ -f $OUTPUTS_PATH/dns_top_queries_in.txt ]]; then paste $OUTPUTS_PATH/dns_top_queries_in.txt $OUTPUTS_PATH/temporary > $OUTPUTS_PATH/dns_top_queries_in_.txt; else cp $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_top_queries_in_.txt; fi;
mv $OUTPUTS_PATH/dns_top_queries_in_.txt $OUTPUTS_PATH/dns_top_queries_in.txt

echo "" >> $REPORT_FILE

echo "Percentage of Rejected Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_rejected_true-false_in.sql > $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_in.txt
cat $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_in.txt >> $REPORT_FILE
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_in.txt | head -n-4 | awk -v today=$DATE '{print today, $2, $3}' >> $OUTPUTS_PATH/dns_rejected_true_in.txt
rows=$(wc "$OUTPUTS_PATH"/dns_rejected_true_in.txt | awk '{print $1}'); if [[ $rows -gt 7 ]]; then tail -n+2 $OUTPUTS_PATH/dns_rejected_true_in.txt > $OUTPUTS_PATH/temporary; mv $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_rejected_true_in.txt; fi;
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_in.txt | head -n-4 | awk -v today=$DATE '{print today, $2, $7}' >> $OUTPUTS_PATH/dns_rejected_false_in.txt
rows=$(wc "$OUTPUTS_PATH"/dns_rejected_false_in.txt | awk '{print $1}'); if [[ $rows -gt 7 ]]; then tail -n+2 $OUTPUTS_PATH/dns_rejected_false_in.txt > $OUTPUTS_PATH/temporary; mv $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_rejected_false_in.txt; fi;
echo "" >> $REPORT_FILE

echo "Percentage of Rejected Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_rejected_true-false_out.sql > $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_out.txt
cat $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_out.txt >> $REPORT_FILE
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_out.txt | head -n-4 | awk -v today=$DATE '{print today, $2, $3}' >> $OUTPUTS_PATH/dns_rejected_true_out.txt
rows=$(wc "$OUTPUTS_PATH"/dns_rejected_true_out.txt | awk '{print $1}'); if [[ $rows -gt 7 ]]; then tail -n+2 $OUTPUTS_PATH/dns_rejected_true_out.txt > $OUTPUTS_PATH/temporary; mv $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_rejected_true_out.txt; fi;
tail -n+4 $OUTPUTS_PATH/"$DATE"_dns_rejected_true-false_out.txt | head -n-4 | awk -v today=$DATE '{print today, $2, $7}' >> $OUTPUTS_PATH/dns_rejected_false_out.txt
rows=$(wc "$OUTPUTS_PATH"/dns_rejected_false_out.txt | awk '{print $1}'); if [[ $rows -gt 7 ]]; then tail -n+2 $OUTPUTS_PATH/dns_rejected_false_out.txt > $OUTPUTS_PATH/temporary; mv $OUTPUTS_PATH/temporary $OUTPUTS_PATH/dns_rejected_false_out.txt; fi;

