\timing
WITH summary AS (
SELECT 
V6_NTOA(orig_h) AS IP,
proto || '/'  || V6_NTOA(orig_h) || '/' || resp_p || '/' || state AS Scanner,
COUNT(*) AS Flows,
COUNT(DISTINCT resp_h) as Distinct_Hosts 
FROM daily_report_conn 
WHERE (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND isUofCAddress2021(orig_h) 
GROUP BY orig_h, proto, resp_p, state
),

conn_tot AS (
SELECT COUNT(*) AS Total 
FROM daily_report_conn
WHERE (state='S0' OR state='REJ' OR (state = 'RSTOS0' AND history NOT LIKE '%d%')) AND isUofCAddress2021(orig_h)
)

SELECT 
Scanner,
Flows,
CAST(ROUND(100*summary.Flows/conn_tot.Total, 2.00) AS numeric(38,2)) AS Flows_Percent,
Distinct_Hosts 
FROM conn_tot, summary 
--WHERE Distinct_hosts >= 8640 
ORDER BY Flows DESC
LIMIT :limits;
\timing
