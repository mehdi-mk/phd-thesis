\timing
WITH summary AS (
SELECT V6_NTOA(resp_h) AS IP, COUNT(*) AS Conns, SUM(resp_bytes2) AS Outbound, SUM(orig_bytes2) AS Inbound, SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, COUNT(DISTINCT orig_h) AS Distinct_Hosts FROM daily_report_conn WHERE isUofCAddress2021(resp_h) AND resp_p=53 GROUP BY IP
), 
conn_tot AS (
SELECT count(*) AS Total FROM daily_report_conn WHERE isUofCAddress2021(resp_h) AND resp_p=53
),
byte_tot AS (
SELECT sum(orig_bytes2 + resp_bytes2) AS Total FROM daily_report_conn WHERE isUofCAddress2021(resp_h) AND resp_p=53
)

SELECT hostname as Hostname, summary.IP, summary.Conns, CAST(ROUND(100*summary.Conns/conn_tot.Total, 2.00) AS numeric(38,2)) AS Conn_Percent, summary.Total_Bytes, CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.00) AS numeric(38,2)) AS Tot_Bytes_Percent, summary.Outbound, summary.Inbound, CAST(ROUND(summary.Outbound/summary.Conns, 2.00)AS numeric(38,2)) AS Ave_Response_Size, CASE WHEN summary.Inbound = 0 THEN 0 ELSE CAST(ROUND(summary.Outbound/summary.Inbound, 2.00) AS numeric(38,2)) END AS Amplification, summary.Distinct_Hosts
FROM conn_tot, byte_tot, summary LEFT JOIN UofC_IPs_Names ON summary.IP = UofC_IPs_Names.ip_address 
GROUP BY hostname, summary.IP, summary.Conns, Conn_Percent, summary.Total_Bytes, Tot_Bytes_Percent, summary.Outbound, summary.Inbound, Ave_Response_Size, Amplification, summary.Distinct_Hosts
ORDER BY Tot_Bytes_Percent DESC
LIMIT 10;
\timing