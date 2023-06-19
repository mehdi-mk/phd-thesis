\set logs '''':logpath'/smtp.*gz'''
\set rej '''':rejpath'/smtp_rejected.txt'''
\set warn '''':rejpath'/smtp_warnings.txt'''
COPY daily_report_smtp (
originalTS FILLER float,
ts as TO_TIMESTAMP(originalTS),
uid,
originalOrigH FILLER varchar,
orig_h as V6_ATON(originalOrigH),
orig_p,
originalRespH FILLER varchar,
resp_h as V6_ATON(originalRespH),
resp_p,
trans_depth,
helo,
mail_from,
rcpt_to,
date,
from_email,
to_email,
cc,
reply_to,
msg_id,
in_reply_to,
subject,
originalXOriginatingIp FILLER varchar,
x_originating_ip as V6_ATON(originalXOriginatingIp),
first_received,
second_received,
last_reply,
path,
user_agent,
tls,
process_recived_from,
has_client_activity )
FROM LOCAL :logs
GZIP
DELIMITER E'\t'
NULL '-'
SKIP 8
REJECTED DATA :rej
EXCEPTIONS :warn
DIRECT;