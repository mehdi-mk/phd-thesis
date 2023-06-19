\timing
WITH summary AS (
SELECT 
CASE WHEN orgName ISNULL THEN INET_NTOA((INET_ATON(V6_NTOA(resp_h)) >> 8) <<8) else orgName end AS Resp_Org, 
COUNT(*) AS Conns, 
SUM(orig_bytes2) AS Outbound, 
SUM(resp_bytes2) AS Inbound, 
SUM(orig_bytes2+resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT orig_h) AS Distinct_Hosts 
FROM daily_report_conn LEFT JOIN extOrgsAGG ON INET_ATON(V6_NTOA(resp_h)) BETWEEN startIP and endIP 
WHERE isUofCAddress2021(orig_h) AND resp_p=53 
GROUP BY Resp_Org 
),
 
conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND resp_p=53
),

byte_tot AS (
SELECT 
SUM(orig_bytes2+resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND resp_p=53
)

SELECT 
summary.Resp_Org, 
summary.Conns, 
CAST(ROUND(100*(summary.Conns/conn_tot.Total), 2.0) AS numeric(38,2)) AS Conn_Percent, 
summary.Total_Bytes, 
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent, 
summary.Outbound, 
summary.Inbound, 
summary.Distinct_Hosts
FROM conn_tot, byte_tot, summary
GROUP BY summary.Resp_Org, summary.Conns, Conn_Percent, summary.Total_Bytes, Tot_Bytes_Percent, summary.Outbound, summary.Inbound, summary.Distinct_Hosts
ORDER BY summary.Conns DESC, summary.Distinct_Hosts DESC
LIMIT :limits;
\timing
