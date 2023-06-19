COPY hb ( originalTS FILLER float, ts as TO_TIMESTAMP(originalTS), uid FILLER varchar, originalOrigH FILLER varchar, orig_h as ConvertAddress(originalOrigH), orig_p FILLER integer, originalRespH FILLER varchar, resp_h as ConvertAddress(originalRespH), resp_p, proto, service FILLER varchar, duration FILLER float, orig_bytes1 FILLER integer, resp_bytes1 FILLER integer, state, local_orig FILLER varchar, local_resp FILLER varchar, missed_bytes FILLER integer, history, orig_pkts FILLER integer, orig_bytes2, resp_pkts FILLER integer, resp_bytes2, tunnel_parents FILLER varchar ) from LOCAL '/data3/2016-12-31/conn.*.log.gz' GZIP DELIMITER E'\t' NULL '-' SKIP 8 REJECTED DATA '/home/mhaffey/vertica/output/warnings/2017-01-29_rejected.txt' EXCEPTIONS '/home/mhaffey/vertica/output/warnings/2017-01-26_exceptions.txt' DIRECT;
