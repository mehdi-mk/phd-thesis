\timing
SELECT 
hour(ts) AS Hour,
COUNT(*) AS Conns,
CAST(ROUND((SUM(resp_bytes2) / (1024^3)), 2.00) AS numeric(38,2)) AS Outbound_GB,
CAST(ROUND((SUM(orig_bytes2) / (1024^3)), 2.00) AS numeric(38,2)) AS Inbound_GB
FROM daily_report_conn
WHERE proto='tcp' AND isUofCAddress2021(resp_h) AND NOT isUofCAddress2021(orig_h)
GROUP BY Hour 
ORDER BY Hour ASC;
\timing
