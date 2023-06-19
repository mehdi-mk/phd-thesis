\set logs '''':logpath'/conn.*gz'''
\set rej '''':rejpath'/conn_rejected.txt'''
\set warn '''':rejpath'/conn_warnings.txt'''
COPY daily_report_conn (
originalTS FILLER float,
ts as TO_TIMESTAMP(originalTS),
uid,
originalOrigH FILLER varchar,
orig_h as V6_ATON(originalOrigH),
orig_p,
originalRespH FILLER varchar,
resp_h as V6_ATON(originalRespH),
resp_p,
proto,
service,
duration,
orig_bytes1,
resp_bytes1,
state,
local_orig,
local_resp,
missed_bytes,
history,
orig_pkts,
orig_bytes2,
resp_pkts,
resp_bytes2,
tunnel_parents )
from LOCAL :logs
GZIP DELIMITER E'\t'
NULL '-'
SKIP 8 REJECTED DATA :rej
EXCEPTIONS :warn
DIRECT;
