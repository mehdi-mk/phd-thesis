\timing
WITH summary AS (
SELECT
V6_NTOA(resp_h) AS IP, 
COUNT(*) AS Flows,
COUNT(DISTINCT orig_h) AS Distinct_Scanners,
COUNT(DISTINCT resp_p) AS Distinct_Ports,
SUM(orig_bytes2+resp_bytes2) AS Total_Bytes 
FROM daily_report_conn
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
GROUP BY 1 
),

conn_tot AS (
SELECT
COUNT(*) AS Total
FROM daily_report_conn 
WHERE isUofCAddress2021(resp_h) AND (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%'))
)

SELECT 
summary.IP,
summary.Flows,
CAST(ROUND(100*(summary.Flows/conn_tot.Total), 2.0) AS numeric(38,2)) AS Flows_Percent, 
summary.Distinct_Scanners,
summary.Distinct_Ports,
summary.Total_Bytes
FROM conn_tot, summary 
ORDER BY summary.Flows DESC
LIMIT :limits;
\timing
