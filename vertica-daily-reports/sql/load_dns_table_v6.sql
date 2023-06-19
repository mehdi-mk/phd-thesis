\set logs '''':logpath'/dns.*gz'''
\set rej '''':rejpath'/dns_rejected.txt'''
\set warn '''':rejpath'/dns_warnings.txt'''
COPY daily_report_dns (
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
trans_id,
rtt,
query,
qclass,
qclass_name,
qtype,
qtype_name,
rcode,
rcode_name,
aa,
tc,
rd,
ra,
z,
answers,
ttls,
rejected )
from LOCAL :logs
GZIP
DELIMITER E'\t'
NULL '-'
SKIP 8 REJECTED DATA :rej
EXCEPTIONS :warn
DIRECT;