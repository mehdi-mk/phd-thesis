\set logs '''':logpath'/http.*gz'''
\set rej '''':rejpath'/http_rejected.txt'''
\set warn '''':rejpath'/http_warnings.txt'''
COPY daily_report_http ( originalTS FILLER float,
ts as TO_TIMESTAMP(originalTS),
uid,
originalOrigH FILLER varchar,
orig_h as V6_ATON(originalOrigH),
orig_p,
originalRespH FILLER varchar,
resp_h as V6_ATON(originalRespH),
resp_p,
trans_depth,
method,
host,
uri,
referrer,
version,
user_agent,
req_body_len,
resp_body_len,
status_code,
status_msg,
info_code,
info_msg,
tags,
username,
password,
proxied,
orig_fuids,
orig_filenames,
orig_mime_types,
resp_fuids,
resp_filenames,
resp_mime_types
)
FROM LOCAL :logs
GZIP
DELIMITER E'\t'
NULL '-'
SKIP 8 REJECTED DATA :rej
EXCEPTIONS :warn
DIRECT;