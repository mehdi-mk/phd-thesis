\timing
WITH summary AS (
SELECT 
resp_p AS Dest_Port,
COUNT(*) AS Flows, 
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT orig_h) AS Distinct_Scanners,
COUNT(DISTINCT resp_h) AS Distinct_Responders
FROM daily_report_conn 
WHERE (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND proto = 'udp' AND isUofCAddress2021(resp_h) AND NOT isUofCAddress2021(orig_h)
GROUP BY Dest_Port
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND proto = 'udp' AND isUofCAddress2021(resp_h) AND NOT isUofCAddress2021(orig_h)
),

byte_tot AS (
SELECT 
SUM(orig_bytes2 + resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND proto = 'udp' AND isUofCAddress2021(resp_h) AND NOT isUofCAddress2021(orig_h)
)

SELECT 
summary.Dest_Port, 
summary.Flows, 
CAST(ROUND(100*summary.Flows/conn_tot.Total, 2.00) AS numeric(38,2)) AS Conn_Percent, 
summary.Total_Bytes, 
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.00) AS numeric(38,2)) AS Tot_Bytes_Percent, 
summary.Distinct_Scanners,
summary.Distinct_Responders
FROM conn_tot, byte_tot, summary
ORDER BY summary.Flows DESC
LIMIT :limits;
\timing
