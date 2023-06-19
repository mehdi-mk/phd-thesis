WITH
conns AS (
SELECT INET_NTOA(orig_h) || '/' || INET_NTOA(resp_h) as name, INET_NTOA(orig_h) || '/' || INET_NTOA(resp_h) || '/' || proto || '/' || resp_p AS key, EXTRACT (epoch from ts) as unix_ts, resp_p AS port, proto AS proto FROM mehdi_single_days WHERE isOrganizationAddress(orig_h) AND NOT isOrganizationAddress(resp_h) AND orig_h != 2292178676
),

counts AS (
SELECT key AS ID, COUNT(key) AS count FROM conns GROUP BY ID
),

pruned AS (
SELECT conns.name, conns.key, counts.ID, conns.unix_ts AS ts, conns.port, conns.proto FROM conns, counts WHERE conns.key = counts.ID AND counts.count BETWEEN 24 AND 8641
),

diffs AS (
SELECT name, key, ts-prev_ts AS diff, port, proto FROM (
SELECT key, ts, LAG(ts,1) OVER (PARTITION BY key ORDER BY key ASC, ts ASC) AS prev_ts, port, proto, name FROM pruned
)
AS sub0 GROUP BY name, key, ts, prev_ts, port, proto ORDER BY key
),

summary AS (
SELECT name, key, round(AVG(diff),2.0) AS Average, round(VAR_SAMP(diff),2.0) AS Variance, port, proto, count(*) as Num FROM diffs GROUP BY name, key, port, proto ORDER BY Average desc)

SELECT name as Key, Average, Variance, port, proto, (CASE WHEN (Num BETWEEN (86400/Average)-1 AND (86400/Average)+1) THEN 'T' ELSE 'F' END) as Burst FROM summary WHERE Variance < 0.5 AND Average > 10 ORDER BY Average desc;
