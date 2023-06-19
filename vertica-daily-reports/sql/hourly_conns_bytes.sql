\timing
WITH summary AS (
SELECT 
hour(ts) AS Hour,
count(*) AS Conns,
SUM(orig_bytes2 + resp_bytes2) AS Bytes,
COUNT(CASE WHEN isUofCAddress2021(orig_h) AND isUofCAddress2021(resp_h) THEN 1 END) AS Local_Conns,
SUM(CASE WHEN isUofCAddress2021(orig_h) AND isUofCAddress2021(resp_h) THEN orig_bytes2+resp_bytes2 END) AS Local_Bytes,
COUNT(CASE WHEN NOT isUofCAddress2021(orig_h) AND NOT isUofCAddress2021(resp_h) THEN 1 END) AS External_Conns,
SUM(CASE WHEN NOT isUofCAddress2021(orig_h) AND NOT isUofCAddress2021(resp_h) THEN orig_bytes2+resp_bytes2 END) AS External_Bytes
FROM daily_report_conn
GROUP BY Hour 
ORDER BY Hour ASC
)

SELECT 
summary.Hour AS Hour, 
summary.Conns AS Conns, 
CAST(ROUND(summary.Bytes/1024^3, 2.00) AS numeric(38,2)) AS Tot_GB,
CAST(ROUND((summary.Bytes / summary.Conns), 2.00) AS numeric(38,2)) AS Bytes_Per_Conn,
CAST(ROUND(100 * summary.Local_Conns / summary.Conns, 2.0) AS numeric(38,2)) AS Loc_Conns_Percent,
summary.Local_Conns,
CAST(ROUND(100 * summary.Local_Bytes / summary.Bytes, 2.0) AS numeric(38,2)) AS Loc_Bytes_Percent,
summary.Local_Bytes,
CAST(ROUND(100 * summary.External_Conns / summary.Conns, 2.0) AS numeric(38,2)) AS Ext_Conns_Percent,
summary.External_Conns,
CAST(ROUND(100 * summary.External_Bytes / summary.Bytes, 2.0) AS numeric(38,2)) AS Ext_Bytes_Percent,
summary.External_Bytes
FROM summary
ORDER BY summary.Hour ASC;
\timing
