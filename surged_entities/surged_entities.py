"""
INPUT FILE -> first row: dates; rows: entity|value; delimiter: '\t'
columns show the top K entities (could be orgs, IPs, etc.) in a tuple form with their frequency (could be connections,
percentage, etc.) separated by '|'. Tuples are separated by '\t'.

OPERATION: For every entity among the top 'TOPS_INTEREST' ones of each day, if the value has been at least doubled
with respect to the value of the entity in the previous day, then that entity on that day is considered to be a
surged one and its value is going to be stored. If on the previous day, the entity was not among the top
'TOPS_AVAILABLE' entities, then it is also going to be considered a surged one and its value is stored in the output.
Note that we are only interested in the top 'TOPS_INTEREST' entities on each day. This value could be less than or equal
to the 'TOPS_AVAILABLE' entities.

OUTPUT FILE -> name: '_surges.txt' added to the input file's name; first row: name of all surged entities;
first column: dates in which there is a surged entity; cells: for every surged entity on a given day if it was
among the surged entities on that day, the value in the corresponding cell (under that entity and in line with the
date) shows the entity's value on that day. If the entity did not appear to be among the surged ones on that day,
the 'DEFAULT_VALUE' is stored instead.

OTHER OUTPUTS -> SQL files to create, load, truncate, and drop table in Vertica, as well as the query file to use
in Grafana to visualize the table. The name of the table is derived from the parameter passed to the Bash file that
calls this Python code (probably 'find_prominent_surged_entities.sh')
"""

import sys


def main():
    # Checking the parameters
    if len(sys.argv) != 3:
        print("Usage: python surged_entities.py <input-file> <table-name>")
        return 0

    # The constants. Should and can only be changed here:
    TOPS_AVAILABLE = 20
    TOPS_INTEREST = 10
    DEFAULT_VALUE = -100000000

    # The name of the input file
    FILE = sys.argv[1]
    # The name of the table to be created in the Vertica
    TABLE = sys.argv[2]
    # Stores the content of the input file based on the expected format described in the docstring.
    inputData = []
    # The list stores surged entities with their values; contains a dictionary of {entity: value, ...} for each day.
    surges = []
    # The list stores only the name of all the surged entities.
    names = []
    # The list stores only the name of all the surged entities, swept from bad characters (replaced by '_').
    sweptNames = []

    try:
        # Opening up the input, output, create table, load table, truncate table, and drop table files.
        inputFILE = open(FILE, 'r')
        outputFILE = open('surged_entities_final.txt', 'w')
        createFILE = open('create_surged_entities_table.sql', 'w')
        loadFILE = open('load_surged_entities_table.sql', 'w')
        truncateFILE = open('truncate_surged_entities_table.sql', 'w')
        dropFILE = open('drop_surged_entities_table.sql', 'w')
        queryFILE = open('surged_entities_query.sql', 'a')

        # Reading the first line. It should contain the dates.
        dates = inputFILE.readline().split('\t')
        for day in dates:
            dates[dates.index(day)] = day.replace("\n", "")
        print("Dates: ", "\n", dates)
        daysCount = len(dates)
        print("Days = ", daysCount)
        # Populating the lists below of a void dictionary for each day.
        for d in range(daysCount):
            inputData.append({})
            surges.append({})

        # Reading off the input file and populating the 'inputData' list.
        for line in range(TOPS_AVAILABLE):
            singleLine = next(inputFILE).rstrip().split('\t')

            for d in range(len(dates)):
                entity = singleLine[d].split('|')[0]
                count = singleLine[d].split('|')[1]
                inputData[d][entity] = int(count)

        # Finding the surged entities on each day and storing them in the 'surges' list with their values
        # Outer loop iterates the date. So we're finding the surges on each day.
        for d in range(1, daysCount):
            # We are only interested in the top 'TOPS_INTEREST' entities on each day.
            for rank_i in range(TOPS_INTEREST):
                # If the entity was not on the previous day this boolean value will remain False and we will consider
                # this entity as surged.
                CHECK_MARK = False
                # We check each entity with all the available top 'TOPS_AVAILABLE' entities of the previous day.
                for rank_a in range(TOPS_AVAILABLE):
                    # Checking to find this entity in the previous day's entities.
                    if list(inputData[d].keys())[rank_i] == list(inputData[d - 1].keys())[rank_a]:
                        # The value's change examination
                        if list(inputData[d].values())[rank_i] >= 2 * list(inputData[d - 1].values())[rank_a]:
                            surges[d][list(inputData[d].keys())[rank_i]] = int(list(inputData[d].values())[rank_i])
                        CHECK_MARK = True
                        break
                # If this entity was not among the 'TOPS_AVAILABLE' entities of the previous day, still consider it as
                # a surged one on this day.
                if not CHECK_MARK:
                    surges[d][list(inputData[d].keys())[rank_i]] = int(list(inputData[d].values())[rank_i])

        # Storing the name of all the surged entities in the 'names' list.
        for d in range(daysCount):
            for pr in range(len(surges[d])):
                if list(surges[d].keys())[pr] not in names:
                    names.append(list(surges[d].keys())[pr])

        badChars = "./&%$@!#`*^+|{}';[]',:-\" "
        for na in range(len(names)):
            tmp = str(names[na])
            for bc in badChars:
                tmp = tmp.replace(bc, "_")
                if tmp[0].isdigit():
                    tmp = '_' + tmp
            sweptNames.append(tmp)

        print(sweptNames)
        # Writing the name of the surged entities as the first line in the output file.
        outputFILE.write("time")
        for ent in range(len(names)):
            outputFILE.write("\t" + str(sweptNames[ent]))
        outputFILE.write("\n")

        # For each day, writing the value for each surged entity. The value could be either the stored value or
        # the default value depending on whether the entity surged on that day or not.
        for d in range(len(dates)):
            outputFILE.write(str(dates[d]))
            for na in range(len(names)):
                if names[na] not in surges[d].keys():
                    outputFILE.write("\t" + str(DEFAULT_VALUE))
                else:
                    outputFILE.write("\t" + str(surges[d][names[na]]))
            outputFILE.write("\n")

        # Writing to the SQL files
        createFILE.write('CREATE TABLE ' + str(TABLE) + ' (\n')
        createFILE.write('\"time\" TIMESTAMP NOT NULL,\n')

        loadFILE.write('COPY ' + str(TABLE) + ' (\n')
        loadFILE.write('time,\n')

        for na in range(len(sweptNames) - 1):
            createFILE.write('\"' + sweptNames[na] + '\" INTEGER,\n')
            loadFILE.write(sweptNames[na] + ',\n')
            queryFILE.write('  CASE WHEN ' + str(TABLE) + '.' + sweptNames[na] + ' IS NULL THEN -100000000 ELSE '
                            + str(TABLE) + '.' + sweptNames[na] + ' END AS ' + sweptNames[na] + ',\n')

        createFILE.write('\"' + sweptNames[-1] + '\" INTEGER )')

        loadFILE.write(sweptNames[-1] + ' )\n')
        loadFILE.write('FROM LOCAL \'surged_entities_final.txt\'\n')
        loadFILE.write('DELIMITER E' + repr('\t') + '\nNULL \'-\'\n')
        loadFILE.write('SKIP 1\nREJECTED DATA \'rejected_surged.out\'\nEXCEPTIONS \'warnings_surged.out\' \nDIRECT;')

        queryFILE.write('  CASE WHEN ' + str(TABLE) + '.' + sweptNames[-1] + ' IS NULL THEN -100000000 ELSE ' + str(TABLE)
                        + '.' + sweptNames[-1] + ' END AS ' + sweptNames[-1] + '\n')
        queryFILE.write('FROM timeline LEFT JOIN ' + str(TABLE) + ' ON timeline.ts = ' + str(TABLE) + '.time\n')
        queryFILE.write('ORDER BY timeline.ts ;\n')

        truncateFILE.write('TRUNCATE TABLE ' + str(TABLE) + ' ;')

        dropFILE.write('DROP TABLE ' + str(TABLE) + ' ;')

    except IOError:
        print("Error: File does not appear to exist.")
        return 0


if __name__ == '__main__':
    main()
