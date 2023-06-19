#!/bin/bash

TOPS=20
RUNNING_PATH=/data5/mehdi/vertica_daily_reports

cd $RUNNING_PATH

ls outputs/*.txt | grep -v -P 'hourly' | while read PATHNAME; do FILENAME=$(echo $PATHNAME | awk -F "/" '{print $NF}') && cp $PATHNAME . && ./run_similarity_metrics_ranking_autorun.sh $FILENAME $TOPS ; done;

echo "##################### Finishing Up with Hourly Conns & Bytes ##################### "
echo ""

cp outputs/hourly_*.txt .

/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f truncate_hourly_conns_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f truncate_hourly_bytes_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f create_hourly_conns_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f create_hourly_bytes_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f load_hourly_conns_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -f load_hourly_bytes_table.sql
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -c "GRANT ALL ON hourly_conns TO grafana;"
/opt/vertica/bin/vsql -h 192.168.0.35 -U report -w R3port -c "GRANT ALL ON hourly_bytes TO grafana;"

