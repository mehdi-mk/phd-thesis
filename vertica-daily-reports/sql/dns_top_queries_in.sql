\timing
WITH summary AS (
SELECT 
DISTINCT query AS Queries,
COUNT(*) AS Counts,
COUNT(DISTINCT orig_h) AS Querants,
COUNT(DISTINCT resp_h) AS Servers
FROM daily_report_dns
WHERE isUofCAddress2021(resp_h)
GROUP BY 1
), 

conn_tot AS (
SELECT 
COUNT(*) AS Total
FROM daily_report_dns
WHERE isUofCAddress2021(resp_h)
)

SELECT
summary.Queries,
summary.Counts,
CAST(ROUND(100*(summary.Counts/conn_tot.Total), 2.0) AS numeric(38,2))  AS Counts_Percent,
summary.Querants,
summary.Servers
FROM conn_tot, summary
ORDER BY summary.Counts DESC
LIMIT 20;
\timing