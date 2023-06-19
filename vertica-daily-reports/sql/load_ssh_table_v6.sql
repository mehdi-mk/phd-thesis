\set logs '''':logpath'/ssh.*gz'''
\set rej '''':rejpath'/ssh_rejected.txt'''
\set warn '''':rejpath'/ssh_warnings.txt'''
COPY daily_report_ssh (
originalTS FILLER float,
ts as TO_TIMESTAMP(originalTS),
uid,
originalOrigH FILLER varchar,
orig_h as V6_ATON(originalOrigH),
orig_p,
originalRespH FILLER varchar,
resp_h as V6_ATON(originalRespH),
resp_p,
version,
auth_success,
auth_attempts,
direction,
client,
server,
cipher_alg,
mac_alg,
compression_alg,
kex_alg,
host_key_alg,
host_key,
country,
state,
city,
latitude,
longitude )
from LOCAL :logs
GZIP DELIMITER E'\t'
NULL '-'
SKIP 8 REJECTED DATA :rej
EXCEPTIONS :warn
DIRECT;