\timing
WITH summary AS (
SELECT 
proto AS Protocol,
CASE
WHEN orig_p >= resp_p THEN resp_p
WHEN resp_p > orig_p THEN orig_p
END AS Dest_Port,
COUNT(*) AS Flows,
SUM(orig_bytes2) AS Inbound, 
SUM(resp_bytes2) AS Outbound,
SUM(orig_bytes2 + resp_bytes2) AS Total_Bytes, 
COUNT(DISTINCT CASE WHEN orig_p >= resp_p THEN orig_h ELSE resp_h END) AS Distinct_Originators,
COUNT(DISTINCT CASE WHEN orig_p >= resp_p THEN resp_h ELSE orig_h END) AS Distinct_Responders
FROM daily_report_conn 
WHERE ((isUofCAddress2021(orig_h) AND orig_p >= resp_p AND NOT isUofCAddress2021(resp_h)) OR (isUofCAddress2021(resp_h) AND resp_p > orig_p AND NOT isUofCAddress2021(orig_h))) AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
GROUP BY 1,2
),
conn_tot AS (
SELECT COUNT(*) AS Total 
FROM daily_report_conn
WHERE ((isUofCAddress2021(orig_h) AND orig_p >= resp_p AND NOT isUofCAddress2021(resp_h)) OR (isUofCAddress2021(resp_h) AND resp_p > orig_p AND NOT isUofCAddress2021(orig_h))) AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
),
byte_tot AS (
SELECT SUM(orig_bytes2+resp_bytes2) AS Total 
FROM daily_report_conn 
WHERE ((isUofCAddress2021(orig_h) AND orig_p >= resp_p AND NOT isUofCAddress2021(resp_h)) OR (isUofCAddress2021(resp_h) AND resp_p > orig_p AND NOT isUofCAddress2021(orig_h))) AND orig_bytes2 > 0 AND resp_bytes2 > 0 AND NOT (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
)

SELECT 
Protocol,
Dest_Port,
Flows,
CAST(ROUND(100*summary.Flows/conn_tot.Total, 2.00) AS numeric(38,2)) AS Flows_Percent,
Inbound,
Outbound,
Total_Bytes,
CAST(ROUND(100*summary.Total_Bytes/byte_tot.Total, 2.0) AS numeric(38,2)) AS Tot_Bytes_Percent,
Distinct_Originators,
Distinct_Responders
FROM conn_tot, byte_tot, summary
ORDER BY Total_Bytes DESC
LIMIT :limits;
\timing
