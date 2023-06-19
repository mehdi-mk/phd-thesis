# Daily Reports from UCalgary's Campus Network Traffic

This repository includes an automated workflow written with a combination of Bash scripts, Python scripts, and SQL queries. The goal is to get statistical analyses of the University of Calgary's campus daily network traffic. Many parts and pieces are involved because many aspects of the traffic are analyzed. 

The input logs come from the Zeek logs stored daily in Advanced Research Computing (ARC) on campus. The first level of output is a "txt" report file. 

This report file is the initial result of this workflow. Other scripts will then process it, and further results are many tables to be loaded into a Vertica DB. Some SQL queries are further generated to be used for visualizations (e.g., in Grafana).

#### There are only a few comments in the codes, as the goal was not collaboration work. It was a solo work for study purposes.

Some variables, such as username, ARC server address, and CPSC server address, are changed for security purposes.

## The Workflow

There are two directories: (1) scripts and (2) sql. As the names suggest, the first one contains all the Bash scripts, and the second one has all the SQL queries that are called within the scripts. 

A cron job on a server on campus runs the 'run_daily_report.sh' script first. This file is the main script for the daily text file report. It calls all other scripts one by one, starting with 'run_load_logs.sh', which copies Zeek's Conn log files of the previous day from ARC to this server and loads them into Vertica. Each script is for a specific application/protocol analysis and calls a specific set of SQL queries. 

There is lots of data processing, transformation, and manipulation for various reasons. For example, there are specific limitations with each tool that needs to be addressed before it receives the data in the pipeline.

For security purposes, there is no report file available on GitHub since these files contain some information, such as the IPs of servers on campus. In addition, there is so much in a report file and revealing this information is unsafe. Most importantly, I'm not at liberty to do so!

The initial report file has more than 130 sections of summary tables, each reporting on a specific application/protocol of the traffic. A value in the scripts (TOPS) specifies the number of entries we want in each table. By default, it is set to 20. So, for example, when we get the list of external organizations as the target of HTTPS connections from campus based on traffic volume, we only see the top 20 organizations in the report. 

The second stage of this automated workflow is running specific Bash/Python scripts that calculate specific similarity metrics for each report section. These scripts are to be found in the root directory. The similarity metrics are as follows:

1. **Set-similarity versus day 0:** This metric compares the set of top 20 scanners on each day against day 0. For every entity that is on the day 0's set, no matter the ranking, it adds one point to the sum value, normalizing by 20 at the end to produce a fractional value between 0 and 1 (inclusive), showing the fraction of overlap (intersection) between the two sets. Therefore, zero means the set of top 20 scanners has completely changed since day 0, and one means that the set is similar to day 0.

2. **Set-similarity versus previous day:** This metric is the same as the previous metric but compares each day's set against its previous day instead of day 0.

3. **Rank-similarity versus day 0:** This metric compares the rankings within the top 20 scanners on each day against day 0. For every entity that is on the day 0's list with the same rank, it adds one point to the sum value, normalizing by 20 at the end to produce a fractional value between 0 and 1 (inclusive). Therefore, zero means the list of top 20 scanners has completely changed in terms of either entities' presence in the list or their ranking, and one means that the list is identical to day 0.

4. **Rank-similarity versus previous day:** This metric uses the same logic as the previous one but compares every day's list against its previous day.

5. ** bsolute Ranking Difference versus day 0:** This metric finds entities that appear in both day 0 and the current day's list and adds the absolute value of the difference in their rankings to a sum value, normalizing by 20 at the end. The bigger the value of this metric, the more displacements have happened to entities' rankings.

6. **Absolute Ranking Difference versus previous day:** It is the same as the previous metric but compared against the previous day instead of day 0.

7. **Relative Ranking Difference versus day 0:** This metric uses the same logic as the Absolute Ranking Difference metric, but instead of summing the absolute value of the differences in the rankings, it calculates a relative value based on the ranking of the entity in the current day's list. Therefore, it provides a metric for displacements relative to the ranking of entities.

8. **Relative Ranking Difference versus previous day:** It is similar to the previous metric but compared against the previous day instead of day 0.

The 'run_automation_similarity_metrics_ranking.sh' script is the last piece that is called within the 'run_daily_report.sh'. Following the trail, it then calls the 'run_similarity_metrics_ranking_autorun.sh' script, which calculates the similarity metrics for all the tables in the report file using the Python script "similarity_metrics.py". For each table in the report, 8 tables (for 8 similarity metrics) will be created in the Vertica. The new values for these metrics in the tables are added to the previous values (of earlier days). So we end up having time-series values for each metric. These are then visualized using the generated queries in analytics and visualization platforms (such as Grafana) connected to Vertica. These visualizations help spot the dramatic changes in the traffic. Please watch this short video demo to get an idea: https://pages.cpsc.ucalgary.ca/~mehdi.karamollahi/Presentation_Grafana2.mp4

The "run_similarity_metrics_ranking_singlerun.sh" is similar to "run_similarity_metrics_ranking_autorun.sh", for manual runs.

The "surged_entities.py" is another Python script that is explained below:

**INPUT FILE:** first row: dates; rows: entity|value; delimiter: '\t'
columns show the top K entities (could be orgs, IPs, etc.) in a tuple form with their frequency (could be connections, percentage, etc.) separated by '|'. Tuples are separated by '\t'.

**OPERATION:** For every entity among the top 'TOPS_INTEREST' ones of each day, if the value has been at least doubled with respect to the value of the entity in the previous day, then that entity on that day is considered to be a surged one and its value is going to be stored. If on the previous day, the entity was not among the top 'TOPS_AVAILABLE' entities, then it is also going to be considered a surged one and its value is stored in the output. Note that we are only interested in the top 'TOPS_INTEREST' entities on each day. This value could be less than or equal
to the 'TOPS_AVAILABLE' entities.

**OUTPUT FILE:** name: '_surges.txt' added to the input file's name; first row: name of all surged entities; first column: dates in which there is a surged entity; cells: for every surged entity on a given day if it was among the surged entities on that day, the value in the corresponding cell (under that entity and in line with the date) shows the entity's value on that day. If the entity did not appear to be among the surged ones on that day, the 'DEFAULT_VALUE' is stored instead.

**OTHER OUTPUTS:** SQL files to create, load, truncate, and drop table in Vertica, as well as the query file to use in Grafana to visualize the table. The name of the table is derived from the parameter passed to the Bash file that calls this Python code (probably  find_prominent_surged_entities.sh')
