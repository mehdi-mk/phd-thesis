\timing
WITH summary AS (
SELECT 
SUM(CASE WHEN rejected = 'T' THEN 1 ELSE 0 END) AS Rejected_TRUE,
SUM(CASE WHEN rejected = 'F' THEN 1 ELSE 0 END) AS Rejected_FALSE
FROM daily_report_dns
WHERE isUofCAddress2021(resp_h)
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total
FROM daily_report_dns
WHERE isUofCAddress2021(resp_h)
)

SELECT
summary.Rejected_TRUE,
CAST(ROUND(100*(summary.REJECTED_TRUE/conn_tot.Total), 2.0) AS numeric(38,2)) AS Rejected_TRUE_Perc,
summary.Rejected_FALSE,
CAST(ROUND(100*(summary.REJECTED_FALSE/conn_tot.Total), 2.0) AS numeric(38,2)) AS Rejected_FALSE_Perc
FROM conn_tot, summary;
\timing