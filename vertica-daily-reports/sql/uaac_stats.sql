\timing
WITH summary AS (
SELECT V6_NTOA(resp_h) AS Resp_IP, COUNT(*) AS Conns, SUM(resp_bytes2) AS Outbound, SUM(orig_bytes2) AS Inbound, SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, COUNT(DISTINCT orig_h) AS Distinct_Hosts FROM daily_report_conn WHERE proto='tcp' AND resp_p=145 GROUP BY Resp_IP
), 
conn_tot AS (
SELECT count(*) AS Total FROM daily_report_conn WHERE proto='tcp' AND resp_p=145
),
byte_tot AS (
SELECT sum(orig_bytes2 + resp_bytes2) AS Total FROM daily_report_conn WHERE proto='tcp' AND resp_p=145
)

SELECT hostname AS Hostname, summary.Resp_IP, summary.Conns, CAST(ROUND(100*(summary.Conns/conn_tot.Total), 2.0) AS numeric(38,2)) AS Conn_Percent, summary.Total_Bytes, CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent, summary.Outbound, summary.Inbound, summary.Distinct_Hosts
FROM conn_tot, byte_tot, summary LEFT JOIN UofC_IPs_Names ON summary.Resp_IP = UofC_IPs_Names.ip_address  
GROUP BY Hostname, summary.Resp_IP, summary.Conns, Conn_Percent, summary.Total_Bytes, Tot_Bytes_Percent, summary.Outbound, summary.Inbound, summary.Distinct_Hosts
ORDER BY summary.Total_Bytes DESC, summary.Distinct_Hosts DESC
LIMIT 10;
\timing