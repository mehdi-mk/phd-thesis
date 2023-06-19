\timing
WITH summary AS (
SELECT CASE WHEN orgName isnull THEN INET_NTOA((INET_ATON(V6_NTOA(orig_h)) >> 8)<<8) ELSE orgName END AS Dest_Org, 
COUNT(*) AS Flows,
COUNT(DISTINCT resp_h) AS Target_Hosts,
COUNT(DISTINCT resp_p) AS Target_Ports,
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes 
FROM daily_report_conn LEFT JOIN extOrgsAGG ON INET_ATON(V6_NTOA(orig_h)) BETWEEN startIP AND endIP 
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND NOT isUofCAddress2021(orig_h)
GROUP BY 1
),

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND NOT isUofCAddress2021(orig_h)
)

SELECT 
summary.Dest_Org, 
summary.Flows, 
CAST(ROUND(100*(summary.Flows/conn_tot.Total), 2.0) AS numeric(38,2)) AS Flows_Percent, 
summary.Target_Hosts,
summary.Target_Ports,
summary.Total_Bytes
FROM conn_tot, summary
ORDER BY summary.Flows DESC
LIMIT :limits;
\timing
