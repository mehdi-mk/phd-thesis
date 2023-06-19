\timing
WITH summary AS (
SELECT CASE WHEN orgName isnull THEN INET_NTOA((INET_ATON(V6_NTOA(resp_h)) >> 8)<<8) ELSE orgName END AS Dest_Org, 
COUNT(*) AS Flows, 
SUM(orig_bytes2) AS Outbound, 
SUM(resp_bytes2) AS Inbound, 
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes 
FROM daily_report_conn LEFT JOIN extOrgsAGG ON INET_ATON(V6_NTOA(resp_h)) BETWEEN startIP AND endIP 
WHERE isUofCAddress2021(orig_h) AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) 
GROUP BY 1
),

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
),

byte_tot AS (
SELECT 
SUM(orig_bytes2 + resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(orig_h) AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
)

SELECT 
summary.Dest_Org, 
summary.Flows, 
CAST(ROUND(100*(summary.Flows/conn_tot.Total), 2.0) AS numeric(38,2)) AS Conn_Percent, 
summary.Total_Bytes,
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent, 
summary.Outbound, 
summary.Inbound
FROM conn_tot, byte_tot, summary
ORDER BY summary.Total_Bytes DESC
LIMIT :limits;
\timing
