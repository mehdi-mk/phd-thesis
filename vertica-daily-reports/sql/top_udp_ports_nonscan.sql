\timing
WITH summary AS (
SELECT 
CASE
WHEN orig_p >= resp_p THEN resp_p
WHEN resp_p > orig_p THEN orig_p
END AS Dest_Port,
COUNT(*) AS Conns, 
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT CASE WHEN orig_p >= resp_p THEN orig_h ELSE resp_h END) AS Distinct_Originators,
COUNT(DISTINCT CASE WHEN orig_p >= resp_p THEN resp_h ELSE orig_h END) AS Distinct_Responders
FROM daily_report_conn 
WHERE proto = 'udp' AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) 
GROUP BY Dest_Port
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total 
FROM daily_report_conn 
WHERE proto = 'udp' AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
),

byte_tot AS (
SELECT 
SUM(orig_bytes2 + resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE proto = 'udp' AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
)

SELECT 
summary.Dest_Port, 
summary.Conns, 
CAST(ROUND(100*summary.Conns/conn_tot.Total, 2.00) AS numeric(38,2)) AS Conn_Percent, summary.Total_Bytes, 
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.00) AS numeric(38,2)) AS Tot_Bytes_Percent, summary.Distinct_Originators,
summary.Distinct_Responders
FROM conn_tot, byte_tot, summary
ORDER BY summary.Total_Bytes DESC
LIMIT :limits;
\timing
