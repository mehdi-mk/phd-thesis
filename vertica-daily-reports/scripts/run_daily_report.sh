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

ROOT_PATH=/data5/mehdi/vertica_daily_reports
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

echo "" >> $REPORT_FILE

echo " < DAILY REPORT FOR $DATE >" >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[MONITOR DISK USAGE]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_filesystem_summary.sh $DATE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HOURLY STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_hourly_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HTTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_http_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HTTPS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_https_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[QUIC STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_quic_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[DNS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_dns_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SSH STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_ssh_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[VPN STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_vpn_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[RDP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_rdp_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[TELNET STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_telnet_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[FTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_ftp_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[IMAP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_imap_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SMTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_smtp_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[POP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_pop_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[NTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_ntp_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SIP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_sip_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[H.323 STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_h323_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[MGCP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_mgcp_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[STUN/MS-TEAMS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_stun_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[RIP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_rip_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[NETBIOS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_netbios_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[LDAP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_ldap_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[UAAC STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

#$SCRIPTS_PATH/run_uaac_stats.sh $DATE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[MS-DS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_msds_stats.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "********************************** SUMMARIES **********************************" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[INBOUND PROTO/PORT SUMMARY]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_protoport_inbound_nonscan_summary.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[OUTBOUND PROTO/PORT SUMMARY]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_protoport_outbound_nonscan_summary.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[TCP/UDP PORTS SUMMARY]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_tcp_udp_ports_nonscan_summary.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[EXTERNAL ORGANIZATIONS SUMMARY]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_organizations_nonscan_summary.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SCANNING SUMMARY]">> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE

echo "" >> $REPORT_FILE

$SCRIPTS_PATH/run_scanning_summary.sh $DATE $LIMIT

echo "" >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "********************************* DNS REPORT **********************************" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "" >> $REPORT_FILE

#$SCRIPTS_PATH/run_dns_logs_summary.sh $DATE

echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "[THE END]" >> $REPORT_FILE

##############################################################################
# CLEAN UP                                                                   #
##############################################################################

$SCRIPTS_PATH/run_cleanup.sh $DATE

##############################################################################
# RUN SIMILARITY METRICS AND RANKING ANALYSIS                                #
##############################################################################

$ROOT_PATH/run_automation_similarity_metrics_ranking.sh >> $ROOT_PATH/_logging.out

##############################################################################
# EMAIL THE REPORT                                                           #
##############################################################################

echo "The daily report from Vertica is attached." | mail -s "Daily report" -a $REPORT_FILE mehdi.karamollahi@ucalgary.ca


