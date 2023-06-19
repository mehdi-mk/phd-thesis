create table hb (
"ts" TIMESTAMP NOT NULL,
"orig_h" integer NOT NULL,
"resp_h" integer NOT NULL,
"resp_p" integer NOT NULL,
"proto" varchar(10) NOT NULL,
"state" varchar (10),
"history" varchar (30),
"orig_bytes2" integer,
"resp_bytes2" integer
)
PARTITION BY EXTRACT(doy FROM ts);
