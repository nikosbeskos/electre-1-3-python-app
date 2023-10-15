import numpy as np


def analysis(alt, iter_num, results):
    rank_acceptability = np.zeros(shape=(alt, alt), dtype=np.float32)
    for alternative in range(alt):
        for maker in range(iter_num):
            for rank in range(alt):
                if results[maker, alternative] == rank+1:
                    rank_acceptability[rank, alternative] += 1  # rows are ranks, columns are alternatives

    rank_acceptability /= iter_num

    # mean value of each alternative for the two ranking methods
    expected_rank = np.mean(a=results, axis=0)  # row represents alternative, value represents ranking
    return expected_rank, rank_acceptability


def run(results_fin):
    results = np.array(results_fin)
    alt = int(np.shape(a=results)[1])
    iter_num = int(np.shape(a=results)[0])
    expexted_rank, rank_acceptability = analysis(alt=alt, iter_num=iter_num, results=results)
    return expexted_rank, rank_acceptability
