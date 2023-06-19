create table daily_report_conn (
"ts" TIMESTAMP NOT NULL,
"uid" varchar(20),
"orig_h" varbinary(50),
"orig_p" integer NOT NULL,
"resp_h" varbinary(50),
"resp_p" integer NOT NULL,
"proto" varchar(10) NOT NULL,
"service" varchar(20),
"duration" float,
"orig_bytes1" integer,
"resp_bytes1" integer,
"state" varchar(10),
"local_orig" varchar(10),
"local_resp" varchar(10),
"missed_bytes" integer,
"history" varchar(30),
"orig_pkts" integer,
"orig_bytes2" integer,
"resp_pkts" integer,
"resp_bytes2" integer,
"tunnel_parents" varchar(30)
)
PARTITION BY EXTRACT(hour FROM ts);
