WITH summary AS (
SELECT CASE WHEN orgName isnull THEN INET_NTOA((INET_ATON(V6_NTOA(orig_h)) >> 8)<<8) ELSE orgName END AS Dest_Org,
COUNT(*) AS Flows
FROM investigation_conn LEFT JOIN extOrgsAGG ON INET_ATON(V6_NTOA(orig_h)) BETWEEN startIP AND endIP
WHERE date_trunc('day', ts) = '2023-01-21 00:00:00' AND proto = 'udp' AND isUofCAddress2022(resp_h)
GROUP BY 1
),

conn_tot AS (
SELECT
COUNT(*) AS Total
FROM investigation_conn
WHERE date_trunc('day', ts) = '2023-01-21 00:00:00' AND proto = 'udp' AND isUofCAddress2022(resp_h)
)

SELECT
summary.Dest_Org,
summary.Flows,
CAST(ROUND(100*(summary.Flows/conn_tot.Total), 2.0) AS numeric(38,2)) AS Conn_Percent
FROM summary, conn_tot
ORDER BY summary.Flows DESC
LIMIT 10;
