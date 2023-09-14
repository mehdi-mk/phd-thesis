COPY scanning_top_udp_ports_inbound (
day,
Identical_ness_day0,
Identical_ness_pre,
Set_similarity_day0,
Set_similarity_pre,
Absolute_rank_diff_day0,
Absolute_rank_diff_pre,
Relative_rank_diff_day0,
Relative_rank_diff_pre )
from LOCAL 'scanning_top_udp_ports_inbound_metrics_transposed.txt'
DELIMITER E'\t'
NULL '-'
SKIP 1
REJECTED DATA 'rejected.out'
EXCEPTIONS 'warnings.out'
DIRECT;
