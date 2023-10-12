# ELECTRE III algorithm

import numpy as np
import pandas as pd
from scipy.stats import rankdata
from . import helpers as hlp
np.set_printoptions(precision=3, suppress=True)
pd.options.display.float_format = '{:.3f}'.format


# electre_3() method is the main code of this project and runs the ELECTRE III algorithm.
def electre_3(class_: hlp.El3_init, weights, q_indiff, preference, veto):

    # Get data from parameters
    x = class_
    alt = x.alt                 # alternatives num
    crit = x.crit               # critieria num
    decMatrix = x.decMatrix     # Decision Matrix
    optType = x.optType         # Min or Max
    w = weights                     # weights
    q = q_indiff                    # Indifference Threshold
    p = preference                  # Preference Threshold
    v = veto                        # Veto Threshold

    # Step 1: Data normalization

    normFactor = np.zeros((1, crit))
    normDM = np.zeros(((alt+3), crit))

    normFactor = np.sqrt(np.sum(np.power(decMatrix, 2), axis=0))

    normDM = np.true_divide(decMatrix, normFactor)
    q_norm = np.true_divide(q, normFactor)
    p_norm = np.true_divide(p, normFactor)
    v_norm = np.true_divide(v, normFactor)

    # normDM = decMatrix
    # q_norm = q
    # p_norm = p
    # v_norm = v

    # Step 2: Normalized Subtraction Matrix

    diffMatr = np.zeros((alt*crit, alt))
    x = 0
    y = 0
    step = 0
    counter = alt

    while step < (crit*alt):
        for k in range(0, crit):
            if optType[0, k] == 1:
                for i in range(step, counter):
                    for j in range(alt):
                        diffMatr[i, j] = -(normDM[j, y] - normDM[x, y])
                    x += 1
            else:
                for i in range(step, counter):
                    for j in range(alt):
                        diffMatr[i, j] = normDM[j, y] - normDM[x, y]
                    x += 1
            y += 1
            x = 0
            step += alt
            counter += alt

    # Step 3: Concordance group

    concordGroup = np.zeros((alt*crit, alt))
    step = 0
    counter = alt

    while step < (crit*alt):
        for criteria in range(crit):
            for row in range(step, counter):
                for column in range(alt):
                    if diffMatr[row, column] > p_norm[0, criteria]:
                        concordGroup[row, column] = 0
                    elif diffMatr[row, column] <= q_norm[0, criteria]:
                        concordGroup[row, column] = 1
                    else:
                        concordGroup[row, column] = ((p_norm[0, criteria] - diffMatr[row, column])
                                                     / (p_norm[0, criteria] - q_norm[0, criteria]))
            step += alt
            counter += alt

    # Step 4: Disconcordance group

    discGroup = np.zeros((alt*crit, alt))
    step = 0
    counter = alt

    while step < (crit*alt):
        for criteria in range(crit):
            for row in range(step, counter):
                for column in range(alt):
                    if diffMatr[row, column] > v_norm[0, criteria] and v_norm[0, criteria] != 0:
                        discGroup[row, column] = 1
                    elif diffMatr[row, column] > p_norm[0, criteria] and v_norm[0, criteria] != 0:
                        discGroup[row, column] = ((diffMatr[row, column] - p_norm[0, criteria])
                                                  / (v_norm[0, criteria] - p_norm[0, criteria]))
                    else:
                        discGroup[row, column] = 0
            step += alt
            counter += alt

    # Step 5: Partial concordance index matrix - CxW

    cxw = np.zeros_like(a=concordGroup)
    step = 0
    counter = alt

    while step < (crit*alt):
        for criteria in range(crit):
            for row in range(step, counter):
                for column in range(alt):
                    cxw[row, column] = concordGroup[row, column] * w[0, criteria]
            step += alt
            counter += alt

    # Step 6: Concordance Index matrix - C ALL

    concordIndex = np.zeros((alt, alt))

    for row in range(len(concordIndex[:, 0])):
        for column in range(len(concordIndex[0, :])):
            for z in range(0, crit*alt, alt):
                concordIndex[row, column] = concordIndex[row, column] + cxw[row+z, column]

    # Step: Dk

    dk = np.zeros_like(a=discGroup)

    for row in range(alt):
        for column in range(alt):
            for z in range(0, len(dk[:, 0]), alt):
                if discGroup[row+z, column] <= concordIndex[row, column]:
                    dk[row+z, column] = 1
                else:
                    dk[row+z, column] = ((1 - discGroup[row+z, column]) / (1 - concordIndex[row, column]))

    # Step 7: Credibility Degree matrix

    credDeg = np.zeros(shape=(alt, alt))
    temp = 1

    for row in range(alt):
        for column in range(alt):
            for z in range(0, len(dk[:, 0]), alt):
                temp *= dk[row+z, column]
            credDeg[row, column] = concordIndex[row, column] * temp
            temp = 1

    # # Φnet
    # phiPlus = np.sum(credDeg, 1)
    # phiMinus = np.sum(credDeg, 0)
    # phiNet = np.subtract(phiPlus, phiMinus, dtype=np.float64)

    # rank_phi = rankdata([-1*i for i in phiNet], method='dense')

    # # Step 7: asafis sxesi kiriarxias

    # dDij = np.zeros_like(credDeg)
    # checkMatrix = np.full_like(dDij, -1)

    # for row in range(alt):
    #     for column in range(alt):
    #         dDij[row, column] = credDeg[row, column]-credDeg[column, row]

    # for row in range(alt):
    #     for column in range(alt):
    #         if dDij[row, column] >= 0:
    #             checkMatrix[row, column] = dDij[row, column]
    #         else:
    #             checkMatrix[row, column] = 0

    # # Step 8: asafis sxesi mi kiriarxias

    # dNDij = 1-checkMatrix
    # mND = np.min(dNDij, 0)
    # rank_desc = rankdata([-1*i for i in mND], method="dense")

    # # Return ranks
    # return np.int32(rank_phi), np.int32(rank_desc), np.float64(phiNet)
    return credDeg


# exploitation procedure of electre iii method
def exploitation(credibility_degree_matrix: np.ndarray, alternative_names: list):
    altnames = alternative_names
    credibility_matrix = credibility_degree_matrix

    credibility_matrix_df = pd.DataFrame(credibility_matrix, columns=altnames, index=altnames)

    # procedure functions
    def get_lambda0(matrix: pd.DataFrame):
        return float(matrix.values.max())

    def get_s_lambda0(lambda_zero):
        alpha = 0.3
        beta = -0.15
        return float(alpha + beta * lambda_zero)

    def get_lambda1(matrix: pd.DataFrame, lambda_zero, s_lambda_zero):
        temp = matrix[matrix < lambda_zero - s_lambda_zero].values.flatten()  # boolean masking/filtering
        if not np.isnan(temp).all():
            lambda_one = np.nanmax(temp)
        else:
            lambda_one = 0
        return lambda_one

    def get_qualification(matrix: pd.DataFrame, lambda_one, s_lambda_zero):
        ''' `matrix[matrix > lambda_one]` creates a new dataframe called
        "outranking_matrix" that is equal to the original matrix but only
        includes rows and columns where the values are greater than lambda_one.

        `outranking_matrix[(matrix - matrix.T) > s_lambda_zero]` further filters the
        outranking_matrix dataframe by subtracting the transpose of the matrix from
        the original matrix and only including the differences that are greater
        than s_lambda_zero -> `S(a,b) - S(b,a) > s_lambda_zero`.

        `outranking_matrix.applymap(lambda x: 1 if x else 0)` applies a lambda function
        to each element of the `outranking_matrix`, where if the element is non-zero, it
        will be replaced with 1, otherwise it will be replaced with 0.
        '''

        outranking_matrix = matrix[matrix > lambda_one]
        outranking_matrix = outranking_matrix[(matrix - matrix.T) > s_lambda_zero]
        outranking_matrix = outranking_matrix.applymap(lambda x: 1 if (not np.isnan(x)) else 0)
        rows_sum = outranking_matrix.sum(axis=1)
        cols_sum = outranking_matrix.sum(axis=0)
        return rows_sum - cols_sum

    def get_subset(qualification):
        max_value = qualification.max()
        max_indices = qualification[qualification == max_value].index  # Get the indices of the maximum value
        D1 = list(max_indices)  # Convert the indices to a list
        return D1

    def get_subset_min(qualification):
        min_value = qualification.min()
        min_indices = qualification[qualification == min_value].index
        D1 = list(min_indices)
        return D1

    def descending_distillation():
        # if the credibility matrix is empty or has only one alternative
        # then the final subset (C1) is the alternative in the matrix
        if len(credibility_matrix_df) > 1:
            l_0 = get_lambda0(matrix=credibility_matrix_df)  # λ0
            s_l_0 = get_s_lambda0(lambda_zero=l_0)  # s(λ0)
            l_1 = get_lambda1(matrix=credibility_matrix_df, lambda_zero=l_0, s_lambda_zero=s_l_0)  # λ1
            qual = get_qualification(matrix=credibility_matrix_df, lambda_one=l_1, s_lambda_zero=s_l_0)
            D1 = get_subset(qual)  # get the names of the required subset
            count = 0  # count for ensuring to not enter to an infinte loop

            # repeat until we reach the end of the alternatives
            while count < (len(altnames) + 1):
                # check if D1 has more than one elements and has non-zero elements
                if ((len(D1) > 1) and (not (qual == 0).all())):
                    # get D1_q, the subset of the credibility matrix with only the alternatives in D1
                    D1_q = credibility_matrix_df.loc[D1, D1]
                    l_0 = get_lambda0(matrix=D1_q)
                    s_l_0 = get_s_lambda0(lambda_zero=l_0)
                    l_1 = get_lambda1(matrix=D1_q, lambda_zero=l_0, s_lambda_zero=s_l_0)
                    qual_2 = get_qualification(matrix=D1_q, lambda_one=l_1, s_lambda_zero=s_l_0)
                    D2 = get_subset(qual_2)
                    if ((len(D2) > 1) and (not (qual_2 == 0).all())):
                        # if the length of the subset D2 is greater than 1 and all elements in
                        # the qualification scores of D2 are not equal to zero
                        # then continue the distillation process by setting D1 as D2
                        D1 = D2
                        count += 1  # prevention of infinite loop
                    else:
                        # if the length of the subset D2 is 1 or all elements in the
                        # qualification scores of D2 are equal to zero
                        # then the distillation process ends and the C1 is set as D2
                        C1 = D2
                        break
                else:
                    # if the length of the subset D1 is 1 or all elements in the
                    # qualification scores of D1 are equal to zero
                    # then the distillation process ends and the C1 is set as D1
                    C1 = D1
                    break
            return C1  # return the final subset (C1) after the distillation process ends
        else:
            # if the credibility matrix is empty or has only one alternative
            # then the final subset (C1) is the alternative in the matrix
            C1 = list(credibility_matrix_df.index)
            return C1

    def ascending_distillation():
        if len(credibility_matrix_df) > 1:
            l_0 = get_lambda0(matrix=credibility_matrix_df)
            s_l_0 = get_s_lambda0(lambda_zero=l_0)
            l_1 = get_lambda1(matrix=credibility_matrix_df, lambda_zero=l_0, s_lambda_zero=s_l_0)
            qual = get_qualification(matrix=credibility_matrix_df, lambda_one=l_1, s_lambda_zero=s_l_0)
            # select the alternative with the min qualification score for the ascending distillation
            D1 = get_subset_min(qual)
            count = 0

            while count < (len(altnames) + 1):
                if ((len(D1) > 1) and (not (qual == 0).all())):
                    D1_q = credibility_matrix_df.loc[D1, D1]
                    l_0 = get_lambda0(matrix=D1_q)
                    s_l_0 = get_s_lambda0(lambda_zero=l_0)
                    l_1 = get_lambda1(matrix=D1_q, lambda_zero=l_0, s_lambda_zero=s_l_0)
                    qual_2 = get_qualification(matrix=D1_q, lambda_one=l_1, s_lambda_zero=s_l_0)
                    # select the alternative with the min qualification score for the ascending distillation
                    D2 = get_subset_min(qual_2)
                    if ((len(D2) > 1) and (not (qual_2 == 0).all())):
                        D1 = D2
                        count += 1
                    else:
                        C1 = D2
                        break
                else:
                    C1 = D1
                    break
            return C1
        else:
            C1 = list(credibility_matrix_df.index)
            return C1

    desc_distil = []
    asc_distil = []

    while not credibility_matrix_df.empty:
        C1 = descending_distillation()
        desc_distil.append(C1)
        credibility_matrix_df.drop(index=C1, columns=C1, inplace=True)

    credibility_matrix_df = pd.DataFrame(credibility_matrix, columns=altnames, index=altnames)

    while not credibility_matrix_df.empty:
        C1 = ascending_distillation()
        asc_distil.append(C1)
        credibility_matrix_df.drop(index=C1, columns=C1, inplace=True)

    asc_distil.reverse()

    return desc_distil, asc_distil


def list_to_dict(input_list):
    output_dict = {}
    for i, inner_list in enumerate(input_list):
        output_dict[i+1] = inner_list
    return output_dict


def get_final_rnk(descending_distillation: dict, ascending_distillation: dict, alternative_names: list):

    # Get the set of alternatives
    alternatives = list(zip(range(len(alternative_names)), alternative_names))

    # Create a dictionary to store the final ranking
    final_ranking = dict((alt, 0) for _, alt in alternatives)

    # Create a numpy array to store the ranking matrix, initialized with zeros
    ranking_matrix = np.zeros((len(alternatives), len(alternatives)), dtype=object)

    # Iterate over all pairs of alternatives
    for i, (callback_, alt1) in enumerate(alternatives):
        for j, (callback_, alt2) in enumerate(alternatives):
            # Get the class of each alternative in the distillations
            idx1_ascending = next((-idx for idx, val in ascending_distillation.items() if alt1 in val), None)
            idx2_ascending = next((-idx for idx, val in ascending_distillation.items() if alt2 in val), None)
            idx1_descending = next((-idx for idx, val in descending_distillation.items() if alt1 in val), None)
            idx2_descending = next((-idx for idx, val in descending_distillation.items() if alt2 in val), None)

            # Check for the four possible cases

            # case 1, A is better than B in both distillations or A is better than B
            # in one distillation and has the same rank in the other distillation
            if ((idx1_ascending > idx2_ascending and idx1_descending > idx2_descending) or
                    (idx1_ascending == idx2_ascending and idx1_descending > idx2_descending) or
                    (idx1_ascending > idx2_ascending and idx1_descending == idx2_descending)):
                final_ranking[alt1] += 1
                ranking_matrix[i][j] = 'P+'

            # case 2, A is incomparable to B
            elif ((idx1_ascending > idx2_ascending and idx1_descending < idx2_descending) or
                  (idx1_ascending < idx2_ascending and idx1_descending > idx2_descending)):
                ranking_matrix[i][j] = 'R'

            # case 3, A is indifferent to B or A=B
            elif ((idx1_ascending == idx2_descending) and (idx2_ascending == idx1_descending) or (alt1 == alt2)):
                ranking_matrix[i][j] = 'I'

            # case 4, A is worse than B
            elif ((idx1_ascending < idx2_ascending and idx1_descending < idx2_descending) or
                  (idx1_ascending == idx2_ascending and idx1_descending < idx2_descending) or
                    (idx1_ascending < idx2_ascending and idx1_descending == idx2_descending)):
                ranking_matrix[i][j] = 'P-'

    # Sort the final ranking based on the count values
    sorted_final_ranking = dict(sorted(final_ranking.items(), key=lambda x: x[1], reverse=True))

    # Create the final ranking preorder by grouping alternatives with the same rank together
    final_preorder = {}
    current_rank = None
    current_class = None

    for alternative, rank in sorted_final_ranking.items():
        if rank == current_rank:
            current_class.append(alternative)
        else:
            current_rank = rank
            current_class = [alternative]
            final_preorder[rank] = current_class

    # get the ranking nubers
    ranking_f = list(final_ranking.values())
    ranking_desc = dict((alt, 0) for _, alt in alternatives)
    ranking_asc = dict((alt, 0) for _, alt in alternatives)

    for val, items in descending_distillation.items():
        for name in items:
            ranking_desc[name] = val
    for val, items in ascending_distillation.items():
        for name in items:
            ranking_asc[name] = val

    ranking_desc = np.array(list(ranking_desc.values()))
    ranking_asc = np.array(list(ranking_asc.values()))
    ranking_f = np.array(ranking_f)

    ranking_desc = rankdata([i for i in ranking_desc], method='dense')
    ranking_asc = rankdata([i for i in ranking_asc], method='dense')
    ranking_f = rankdata([-i for i in ranking_f], method='dense')

    final_preorder_list = list(final_preorder.values())
    return final_preorder_list, ranking_desc, ranking_asc, ranking_f


def run(class_: hlp.El3_init, shared_list):  # Runs the algorithm and returns the resulted ranks
    x = class_
    cred_deg_mtx = electre_3(class_=x, weights=x.w, q_indiff=x.q, preference=x.p, veto=x.v)
    shared_list[0] = 100 * 1/3
    descesnding_distil, ascending_distil = exploitation(
        credibility_degree_matrix=cred_deg_mtx, alternative_names=x.altNames.tolist())
    shared_list[0] = 100 * 2/3
    multival = get_final_rnk(
        list_to_dict(descesnding_distil), list_to_dict(ascending_distil), x.altNames.tolist())
    shared_list[0] = 100 * 3/3

    # unpack values
    final_preorder = multival[0]
    ranking_descending = multival[1]
    ranking_ascending = multival[2]
    ranking_final = multival[3]

    return np.int32(ranking_final), np.int32(ranking_descending), np.int32(ranking_ascending), descesnding_distil, ascending_distil, final_preorder, cred_deg_mtx  # noqa


# Runs the algorithm and returns the resulted ranks with random values generated
def run_r(class_: hlp.El3_init, tolerance, dist):
    x = class_
    y = hlp.run_r(class_=x, tolerance=tolerance, dist=dist)
    cred_deg_mtx = electre_3(class_=x, weights=y.w, q_indiff=y.q, preference=y.p, veto=y.v)
    descesnding_distil, ascending_distil = exploitation(
        credibility_degree_matrix=cred_deg_mtx, alternative_names=y.altNames.tolist())
    multival = get_final_rnk(
        list_to_dict(descesnding_distil), list_to_dict(ascending_distil), y.altNames.tolist())

    # unpack values
    final_preorder = multival[0]
    ranking_descending = multival[1]
    ranking_ascending = multival[2]
    ranking_final = multival[3]
    return np.int32(ranking_final), np.int32(ranking_descending), np.int32(ranking_ascending), descesnding_distil, ascending_distil, final_preorder  # noqa
