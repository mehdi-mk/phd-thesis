\timing
WITH summary AS (
SELECT 
V6_NTOA(orig_h) AS IP, 
COUNT(*) AS Conns, 
SUM(orig_bytes2) AS Outbound, 
SUM(resp_bytes2) AS Inbound, 
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT resp_h) AS Distinct_Hosts 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND resp_p=123 
GROUP BY IP
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND resp_p=123
),

byte_tot AS (
SELECT 
SUM(orig_bytes2 + resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND resp_p=123
)

SELECT 
summary.IP, 
summary.Conns, 
CAST(ROUND(100*summary.Conns/conn_tot.Total, 2.00) AS numeric(38,2)) AS Conn_Percent, 
summary.Total_Bytes, 
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.00) AS numeric(38,2)) AS Tot_Bytes_Percent, 
summary.Outbound, 
summary.Inbound, 
CAST(ROUND(summary.Inbound/summary.Conns, 2.00)AS numeric(38,2)) AS Ave_Response_Size, 
CASE WHEN summary.Outbound = 0 THEN 0 ELSE CAST(ROUND(summary.Inbound/summary.Outbound, 2.00) AS numeric(38,2)) END AS Amplification, 
summary.Distinct_Hosts
FROM conn_tot, byte_tot, summary 
GROUP BY summary.IP, summary.Conns, Conn_Percent, summary.Total_Bytes, Tot_Bytes_Percent, summary.Outbound, summary.Inbound, Ave_Response_Size, Amplification, summary.Distinct_Hosts
ORDER BY summary.Total_Bytes DESC
LIMIT :limits;
\timing
