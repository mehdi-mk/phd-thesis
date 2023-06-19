#!/bin/bash

##############################################################################
# VARIABLES TO SET                                                           #
##############################################################################

#DATE=$(date --date="yesterday" +"%Y-%m-%d")
DATE=2019-12-01

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
# RUN SQL COMMAND                                                            #
##############################################################################

echo "Running report for $DATE ..."
echo "" >> $REPORT_FILE

scp mehdi.karamollahi@arc-dtn.ucalgary.ca:/bulk/williamson_lab/data/data5/$DATE/conn.*gz $LOGS_PATH/

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v logpath=$LOGS_PATH -v rejpath=$REJ_PATH -f $SQL_PATH/load_conn_table_v6.sql

echo "Daily Report - $DATE:" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

#FETCH FILESYSTEM ANALYSIS
echo "===============================================================================" >> $REPORT_FILE
echo "[MONITOR DISK USAGE]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

tail -n 18 /data5/orwelllogs/dailydiskusage.log | head -n 9 >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HOURLY STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Hourly Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_conns_bytes_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Hourly Outbound TCP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_tcp_out_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Hourly Inbound TCP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_tcp_in_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Hourly Outbound UDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_udp_out_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Hourly Inbound UDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/hourly_udp_in_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HTTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound HTTP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_in_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Originators of Inbound HTTP Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_in_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound HTTP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_in_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound HTTP Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_in_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound HTTP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_out_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound HTTP Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_out_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound HTTP Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_out_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound HTTP Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/http_out_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[HTTPS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound HTTPS Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_in_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Originators of Inbound HTTPS Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_in_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound HTTPS Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_in_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound HTTPS Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_in_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound HTTPS Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_out_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound HTTPS Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_out_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound HTTPS Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_out_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound HTTPS Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/https_out_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[QUIC STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound QUIC Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_in_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Originators of Inbound QUIC Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_in_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound QUIC Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_in_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound QUIC Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_in_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound QUIC Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_out_orig_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound QUIC Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_out_orig_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound QUIC Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_out_resp_stats_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound QUIC Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/quic_out_resp_stats_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[DNS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound DNS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound DNS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound DNS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound DNS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SSH STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound SSH Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ssh_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound SSH Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ssh_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound SSH Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ssh_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound SSH Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ssh_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[VPN STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound VPN Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/vpn_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound VPN Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/vpn_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound VPN Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/vpn_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound VPN Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/vpn_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[RDP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound RDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/rdp_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound RDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/rdp_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound RDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/rdp_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound RDP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/rdp_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[TELNET STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound TELNET Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/telnet_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound TELNET Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/telnet_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound TELNET Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/telnet_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound TELNET Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/telnet_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[FTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound FTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ftp_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound FTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ftp_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound FTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ftp_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound FTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ftp_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[IMAP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound IMAP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/imap_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound IMAP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/imap_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound IMAP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/imap_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound IMAP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/imap_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SMTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound SMTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/smtp_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound SMTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/smtp_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound SMTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/smtp_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound SMTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/smtp_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[POP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "External Originators of Inbound POP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/pop_in_orig_stats_mehdi.sql >> $REPORT_FILE
 
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound POP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/pop_in_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound POP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/pop_out_orig_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Responders of Outbound POP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/pop_out_resp_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[NTP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound NTP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ntp_in_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[RIP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Internal Responders of Inbound RIP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/rip_in_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[NETBIOS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Internal Originators of Outbound NETBIOS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/netbios_out_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[LDAP STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Responders of LDAP Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ldap_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[UAAC STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Responders of UAAC Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/uaac_stats_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[MS-DS STATS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Responders MS-DS Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/ms-ds_stats_mehdi.sql >> $REPORT_FILE

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
echo "[INBOUND SUMMARY]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Protocol/Port Summary of Inbound Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/summary_inbound_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Protocol/Port Summary of Inbound Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/summary_inbound_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Protocol/Port Summary of Outbound Connections (Top Bytes):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/summary_outbound_topbytes_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Protocol/Port Summary of Outbound Connections (Top Conns):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/summary_outbound_topconns_mehdi.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[PORTS]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Top (Bytes) TCP Ports on All Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/top_tcp_ports.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top (Bytes) UDP Ports on All Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/top_udp_ports.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[External Organizations]" >> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Top Organizations of Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/top_origin_orgs_in.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top Organizations of Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/top_target_orgs_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "===============================================================================" >> $REPORT_FILE
echo "[SCANNERS AND TARGETS]">> $REPORT_FILE
echo "===============================================================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Internal Scanners (Protocol/Scanner/Port/State):" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/scanners_internal.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "External Scanners:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/scanners_external.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Internal Targets of Inbound Scanning:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/scanning_internal_targets.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "********************************* DNS REPORT **********************************" >> $REPORT_FILE
echo "*******************************************************************************" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

scp mehdi.karamollahi@arc-dtn.ucalgary.ca:/bulk/williamson_lab/data/data5/$DATE/dns*gz $LOGS_PATH/

$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -v logpath=$LOGS_PATH -v rejpath=$REJ_PATH -f $SQL_PATH/load_dns_table_v6.sql

echo "Top Queries on Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_queries_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top Answers on Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_answers_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top Queries on Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_queries_in.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Top Answers on Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_top_answers_in.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Percentage of Rejected Inbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_rejected_true-false_in.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Percentage of Rejected Outbound Connections:" >> $REPORT_FILE
$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/dns_rejected_true-false_out.sql >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "[THE END]" >> $REPORT_FILE

#$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/truncate_conn_table.sql
#$VSQL -h $DB_HOST -U $DB_USER -w $DB_PASSWORD -f $SQL_PATH/truncate_dns_table.sql

echo "The daily report from Vertica is attached." | mail -s "Daily report" -a /data5/mehdi/vertica_daily_reports/reports/"$DATE"_report.txt mehdi.karamollahi@ucalgary.ca


