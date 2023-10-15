# ELECTRE I algo

from scipy.stats import rankdata
import numpy as np
from . import helpers as hlp
# import helpers as hlp

np.set_printoptions(precision=3, suppress=True)


def electre_1(class_: hlp.El1_init, weights, s, veto):

    # Get data from args
    x = class_
    alt = x.alt                 # alternatives num
    crit = x.crit               # critieria num
    decMatrix = x.decMatrix     # Decision Matrix
    optType = x.optType         # Min or Max
    s = x.s                     # Concordance level
    w = weights                     # weights
    v = veto                        # Veto Threshold

    # Step 1: Data normalization

    normFactor = np.zeros((1, crit))
    normDM = np.zeros(((alt+1), crit))

    normFactor = np.sqrt(np.sum(np.power(decMatrix, 2), axis=0))

    normDM = np.true_divide(decMatrix, normFactor)
    v_norm = np.true_divide(v, normFactor)

    # Step 2: Normalized Subtraction Matrix

    diffMatr = np.zeros((alt*crit, alt))
    x = 0
    y = 0
    step = 0
    counter = alt

    while step < (crit*alt):
        for k in range(crit):
            if optType[0, k] == 1:
                for i in range(step, counter):
                    for j in range(alt):
                        diffMatr[i, j] = -(normDM[x, y] - normDM[j, y])
                    x += 1
            else:
                for i in range(step, counter):
                    for j in range(alt):
                        diffMatr[i, j] = normDM[x, y] - normDM[j, y]
                    x += 1
            y += 1
            x = 0
            step += alt
            counter += alt

    # Step 3: Concordance group

    concordGroup = np.zeros((alt*crit, alt))

    for row in range(len(concordGroup[:, 0])):
        for column in range(alt):
            if diffMatr[row, column] >= 0:
                concordGroup[row, column] = 1
            else:
                concordGroup[row, column] = 0

    # Step 4: Disconcordance group

    discGroup = np.full((alt*crit, alt), -1)
    step = 0
    counter = alt

    while step < (crit*alt):
        for k in range(crit):
            for i in range(step, counter):
                for j in range(alt):
                    # oi enalaktikes  exoun ligo mikroteri timi apo to veto me akriveia 10^-16
                    # kai to -0.000001 xrisimopoieitai gia na ginei i strogkilopiisi pros ta kato
                    if -diffMatr[i, j] >= ((np.around((v_norm[0, k]), decimals=6))-0.000001) and v_norm[0, k] != 0:
                        discGroup[i, j] = 1
                    else:
                        discGroup[i, j] = 0
            step += alt
            counter += alt

    # Step 5: Concordance Index matrix

    concordIndex = np.zeros_like(concordGroup)
    step = 0
    counter = alt

    while step < (crit*alt):
        for k in range(crit):
            for i in range(step, counter):
                for j in range(alt):
                    concordIndex[i, j] = concordGroup[i, j] * w[0, k]
            step += alt
            counter += alt

    # Step 6: Concordance Check matrix

    concordCheck = np.zeros((alt, alt))
    a = 0
    b = np.sum(w)

    for row in range(len(concordCheck[:, 0])):
        for column in range(len(concordCheck[0, :])):
            for z in range(0, len(concordIndex[:, 0]), alt):
                a = a+concordIndex[(z+row), column]
            concordCheck[row, column] = a/b
            a = 0

    # Step 7: Disconcordance Check matrix

    disconcordCheck = np.full_like(concordCheck, -1)

    for row in range(alt):
        for column in range(alt):
            for z in range(0, len(discGroup[:, 0]), alt):
                if disconcordCheck[row, column] < discGroup[row+z, column]:
                    disconcordCheck[row, column] = discGroup[row+z, column]
                else:
                    pass

    # Step 8: Superioriry matrix

    superior = np.full((alt, alt), -1)

    for row in range(alt):
        for column in range(alt):
            if concordCheck[row, column] >= s and disconcordCheck[row, column] == 0:
                superior[row, column] = 1
            else:
                superior[row, column] = 0

    # Φnet
    phiPlus = np.sum(superior, 1)
    phiMinus = np.sum(superior, 0)
    phiNet = np.subtract(phiPlus, phiMinus)

    rank = rankdata([-1*i for i in phiNet], method='dense')

    # Return ranks
    return np.int32(rank), np.float64(phiNet), superior


def get_ranking_names(rank, names):
    rank = rank.tolist()
    names = names.tolist()

    # Create a list of (rank, name) tuples
    ranked_items = list(zip(rank, names))

    # Sort the items first by rank (in ascending order)
    ranked_items.sort(key=lambda x: x[0])

    # Initialize the preorder list as a list of lists
    preorder = []
    current_rank = None
    group = []

    # Iterate through the sorted items
    for rank, name in ranked_items:
        if rank == current_rank:
            group.append(name)
        else:
            if group:
                # If there's a group of items with the same rank, add them as a list
                preorder.append(group)
            group = [name]
            current_rank = rank

    # Add the last group of items as a list
    if group:
        preorder.append(group)

    return preorder


def run(class_: hlp.El1_init, shared_list):  # Runs the algorithm and returns the resulted ranks
    x = class_
    shared_list[0] = 0
    rank, phiNet, superior = electre_1(class_=x, weights=x.w, s=x.s, veto=x.v)
    namerank = get_ranking_names(rank, x.altNames)
    for i in range(100):    # pseudo progress for visual purpose
        shared_list[0] = i+1
        # TODO: na mpei to rank me ta onomata k na paei sto return apo katw
    return np.int32(rank), np.float64(phiNet), superior, namerank


def run_r(class_: hlp.El1_init, tolerance, dist):  # Runs the algorithm and returns the resulted ranks with random values generated # noqa
    x = class_
    y = hlp.run_r(class_=x, tolerance=tolerance, dist=dist)
    rank, phiNet, superior = electre_1(class_=x, weights=y.w, s=y.s, veto=y.v)
    return np.int32(rank), np.float64(phiNet)

# debug


# if __name__ == '__main__':
#     excelfilepath = "el_py\\Book_electre1.xlsx"
#     x = hlp.ld.run_auto(excelfilepath)
#     s_thresh = 0.79
#     import json
#     with open("output\\data.json", "r") as file:
#         json_data = file.readlines()
#     alldata = json.loads(json_data[0])
#     from main import initialize
#     data = [excelfilepath, x, s_thresh, alldata]
#     x = initialize(data)
#     shared_list = [0, "end"]
#     results = run(x, shared_list)
#     print("debug")
#     print("debug")
