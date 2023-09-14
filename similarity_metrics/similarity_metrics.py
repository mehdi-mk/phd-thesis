""" this is a script to get (1) Similarity Metrics and (2) Port Rankings. """
import sys


def main():
    if len(sys.argv) < 3:
        print("Usage: python similarity_metrics.py <input-file> <number-of-tops> (optional: <metrics-output-file>)"
              " (optional: <rankings-output-file>)")
        return 0
    if len(sys.argv) > 5:
        print("Too many arguments!")
        print("Usage: python similarity_metrics.py <input-file> <number-of-tops> (optional: <metrics-output-file>)"
              " (optional: <rankings-output-file>)")
        return 0
    FILE = sys.argv[1]
    TOPS = int(sys.argv[2])
    if len(sys.argv) > 3:
        METRICS_FILE = sys.argv[3]
    if len(sys.argv) == 5:
        RANKING_FILE = sys.argv[4]

    try:
        f = open(FILE, 'r')
        dates = f.readline().split('\t')
        for d in dates:
            dates[dates.index(d)] = d.replace("\n", "")
        print("Dates: ", "\n", dates)
        daysCount = len(dates)
        print("Days = ", daysCount)
        print("Tops = ", TOPS)
        inputData = []
        score = [[0 for i in range(daysCount+1)] for j in range(8)]
        portRankings = dict()

        for line in range(TOPS):
            inputData.append(next(f).rstrip().split('\t'))

        # ==================== ( 1 ) ==================== #
        # compute identicalness metric for each day vs day 0
        score[0][0] = 'Identical_ness_day0'
        for t in range(TOPS):
            for d in range(daysCount):
                if inputData[t][d] == inputData[t][0]:
                    score[0][d+1] += 1

        # ==================== ( 2 ) ==================== #
        # compute identicalness metric for each day vs the preceding day
        score[1][0] = 'Identical_ness_pre'
        for t in range(TOPS):
            for d in range(daysCount):
                if d == 0:
                    continue
                if inputData[t][d] == inputData[t][d-1]:
                    score[1][d+1] += 1

        # ==================== ( 3 ) ==================== #
        # compute set-similarity metric for each day vs day 0
        score[2][0] = 'Set_similarity_day0'
        for t in range(TOPS):
            for d in range(daysCount):
                for k in range(TOPS):
                    if inputData[t][d] == inputData[k][0]:
                        score[2][d+1] += 1

        # ==================== ( 4 ) ==================== #
        # compute set-similarity metric for each day vs the preceding day
        score[3][0] = 'Set_similarity_pre'
        for t in range(TOPS):
            for d in range(daysCount):
                if d == 0:
                    continue
                for k in range(TOPS):
                    if inputData[t][d] == inputData[k][d-1]:
                        score[3][d+1] += 1

        # ==================== ( 5 ) ==================== #
        # compute absolute rank displacement metric for each day vs day 0
        score[4][0] = 'Absolute_rank_diff_day0'
        for t in range(TOPS):
            for d in range(daysCount):
                for k in range(TOPS):
                    if inputData[t][d] == inputData[k][0]:
                        score[4][d+1] += abs(t-k)

        # ==================== ( 6 ) ==================== #
        # compute absolute rank displacement metric for each day vs the preceding day
        score[5][0] = 'Absolute_rank_diff_pre'
        for t in range(TOPS):
            for d in range(daysCount):
                if d == 0:
                    continue
                for k in range(TOPS):
                    if inputData[t][d] == inputData[k][d-1]:
                        score[5][d+1] += abs(t-k)

        # ==================== ( 7 ) ==================== #
        # compute weighted rank displacement metric for each day vs day 0
        score[6][0] = 'Relative_rank_diff_day0'
        for t in range(TOPS):
            for d in range(daysCount):
                for k in range(TOPS):
                    if inputData[t][d] == inputData[k][0]:
                        score[6][d+1] += abs((t-k)/(k+1))

        # ==================== ( 8 ) ==================== #
        # compute weighted rank displacement metric for each day vs the preceding day
        score[7][0] = 'Relative_rank_diff_pre'
        for t in range(TOPS):
            for d in range(daysCount):
                for k in range(TOPS):
                    if d > 0:
                        if inputData[t][d] == inputData[k][d-1]:
                            score[7][d+1] += abs((t-k)/(k+1))

        # ||||||||||||||||||||||||||||||||||||||||||||||| #
        # compute port appearances and averaged port rankings
        for row in inputData:
            for protoPort in row:
                if protoPort not in portRankings.keys():
                    prKeys = {k.lower(): v for k, v in portRankings.items()}
                    if protoPort.lower() in prKeys.keys():
                        protoPort = protoPort + "_2ND"
                    portRankings[protoPort] = []
                    for i in range(daysCount):
                        for j in range(TOPS):
                            if inputData[j][i] == protoPort:
                                portRankings[protoPort].append(-1 * (j+1))
                                break
                            if j == TOPS - 1:
                                portRankings[protoPort].append(-200)

        # ||||||||||||||||||||||||||||||||||||||||||||||| #
        # normalizing the similarity metrics based on the value TOPS
        for s in score:
            for e in s:
                if isinstance(e, int) or isinstance(e, float):
                    score[score.index(s)][s.index(e)] = "{:.2f}".format(e / TOPS)

        # printing out the similarity metrics
        if len(sys.argv) < 4:
            for s in score:
                print(s)
        else:
            try:
                badChars = "[]',:\""
                for bc in badChars:
                    dates = str(dates).replace(bc, "")
                dates = str(dates).replace(" ", "\t")
                metricsFile = open(METRICS_FILE, "w")
                metricsFile.write("Days" + "\t" + dates)
                metricsFile.write("\n")
                string_of_score = ""
                for s in score:
                    tmp = str(s)
                    for bc in badChars:
                        tmp = str(tmp).replace(bc, "")

                    tmp = str(tmp).replace(" ", "\t")
                    string_of_score = string_of_score + tmp + "\n"
                metricsFile.write(string_of_score)
                print("Similarity metrics result is successfully written to the specified output file.")
            except IOError:
                print("Couldn't write to the output file in this directory. Check permissions.")
                return 0

        # printing out port rankings
        if len(sys.argv) < 5:
            for pp in portRankings:
                print(pp + ":", portRankings[pp])
        else:
            try:
                rankingFile = open(RANKING_FILE, "w")
                rankingFile.write("Days" + "\t" + dates)
                rankingFile.write("\n")

                badChars = badChars + "()"
                worseChars = "./&%$@!#`*^+|{}'; "
                string_of_ranking = ""
                for pp in portRankings:
                    tmp = str(pp).lstrip().rstrip().replace("-", "_") + ":\t" + str(portRankings[pp]).replace(" ", "\t")
                    for bc in badChars:
                        tmp = str(tmp).replace(bc, "")
                    for wc in worseChars:
                        tmp = str(tmp).replace(wc, "_")
                    if len(str(pp).lstrip()) == 0:
                        tmp = "_" + tmp
                    elif str(pp).lstrip()[0].isdigit():
                        tmp = "_" + tmp
                    string_of_ranking = string_of_ranking + tmp + "\n"
                rankingFile.write(string_of_ranking)

                print("Port-ranking result is successfully written to the specified output file.")
            except IOError:
                print("Couldn't write to the output file in this directory. Check permissions.")
                return 0

    except IOError:
        print("Error: File does not appear to exist.")
        return 0


if __name__ == '__main__':
    main()
