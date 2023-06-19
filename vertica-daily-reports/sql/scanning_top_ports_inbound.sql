\timing
WITH summary AS (
SELECT 
proto AS Protocol,
resp_p AS Dest_Port,
COUNT(*) AS Flows,
COUNT(DISTINCT orig_h) AS Scanners,
COUNT(DISTINCT resp_h) AS Target_Hosts,
SUM(orig_bytes2) AS Inbound, 
SUM(resp_bytes2) AS Outbound,
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND NOT isUofCAddress2021(orig_h)
GROUP BY 1,2
),
conn_tot AS (
SELECT COUNT(*) AS Total 
FROM daily_report_conn
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND NOT isUofCAddress2021(orig_h)
),
byte_tot AS (
SELECT SUM(orig_bytes2+resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND NOT isUofCAddress2021(orig_h)
)

SELECT 
Protocol,
Dest_Port,
Flows,
CAST(ROUND(100*summary.Flows/conn_tot.Total, 2.00) AS numeric(38,2)) AS Flows_Percent,
Scanners,
Target_Hosts,
Inbound,
Outbound,
Total_Bytes,
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent
FROM conn_tot, byte_tot, summary
ORDER BY Flows DESC
LIMIT :limits;
\timing
