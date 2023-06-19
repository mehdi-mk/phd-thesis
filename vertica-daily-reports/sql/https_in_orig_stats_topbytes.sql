\timing
WITH summary AS (
SELECT 
CASE WHEN orgName ISNULL THEN INET_NTOA((INET_ATON(V6_NTOA(orig_h)) >> 8) <<8) else orgName end AS Orig_Org, 
COUNT(*) AS Conns, 
SUM(resp_bytes2) AS Outbound, 
SUM(orig_bytes2) AS Inbound, 
SUM(orig_bytes2+resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT orig_h) AS Distinct_Hosts 
FROM daily_report_conn LEFT JOIN extOrgsAGG ON INET_ATON(V6_NTOA(orig_h)) BETWEEN startIP and endIP 
WHERE isUofCAddress2021(resp_h) AND proto = 'tcp' AND resp_p=443 
GROUP BY Orig_Org 
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND proto = 'tcp' AND resp_p=443
),

byte_tot AS (
SELECT 
SUM(orig_bytes2+resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND proto = 'tcp' AND resp_p=443
)

SELECT 
summary.Orig_Org, 
summary.Conns, 
CAST(ROUND(100*(summary.Conns/conn_tot.Total), 2.0) AS numeric(38,2)) AS Conn_Percent, 
summary.Total_Bytes, 
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent, 
summary.Outbound, 
summary.Inbound, 
summary.Distinct_Hosts
FROM conn_tot, byte_tot, summary
GROUP BY summary.Orig_Org, summary.Conns, Conn_Percent, summary.Total_Bytes, Tot_Bytes_Percent, summary.Outbound, summary.Inbound, summary.Distinct_Hosts
ORDER BY summary.Total_Bytes DESC, summary.Distinct_Hosts DESC
LIMIT :limits;
\timing
