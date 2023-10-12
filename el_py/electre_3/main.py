# This is the handling file of the project

import numpy as np
import pickle
from . import electre3


def initialize(data):
    x = data[1]
    fullinitialdata = data[2]

    if x is None:
        x = electre3.hlp.ld.Store_data()
        raise ValueError('Cant retrieve data.')

    critnames = fullinitialdata[0]
    critnames = critnames[1:]
    x.critNames = np.array(critnames, dtype=object)

    altnames = []
    for item in fullinitialdata:
        altnames.append(item[0])

    altnames = altnames[1:-5]
    x.altNames = np.array(altnames, dtype=object)

    optType = fullinitialdata[-5][1:]
    for i, item in enumerate(optType):
        if item == 'Maximize':
            optType[i] = 0
        elif item == 'Minimize':
            optType[i] = 1

    weights = fullinitialdata[-4][1:]
    weights = [0 if w == '' else w for w in weights]
    weights = [float(w) for w in weights]
    q = fullinitialdata[-3][1:]
    q = [0 if i == '' else i for i in q]
    q = [float(i) for i in q]
    p = fullinitialdata[-2][1:]
    p = [0 if i == '' else i for i in p]
    p = [float(i) for i in p]
    v = fullinitialdata[-1][1:]
    v = [0 if i == '' else i for i in v]
    v = [float(i) for i in v]
    decMatrix = np.array(fullinitialdata[1:-5])
    decMatrix = decMatrix[:, 1:]
    decMatrix = np.where(decMatrix == '', 0, decMatrix)
    decMatrix = decMatrix.astype(float)
    x.decMatrix = decMatrix

    x.alt = x.altNames.size
    x.crit = x.critNames.size

    x = electre3.hlp.El3_init(class_=x)
    x.optType = np.array(optType).reshape((1, x.crit))
    x.w = np.array(weights).reshape((1, x.crit))
    x.q = np.array(q).reshape((1, x.crit))
    x.p = np.array(p).reshape((1, x.crit))
    x.v = np.array(v).reshape((1, x.crit))

    if x.w.all() == 0 or x.p.all() == 0 or decMatrix.all() == 0:
        raise ValueError(
            'There were no values entered. Please enter the correct values in the Data Entry table. ' +
            'Do not leave the cells empty.')

    return x

    '''
    # desision_makers = 1  # int(input('How many desision makers are running the ELECTRE III algorithm?\n'))
    # results_final = np.full((desision_makers, alt), 0)
    # results_desc = np.full((desision_makers, alt), 0)
    # results_asc = np.full_like(a=results_final, fill_value=0, dtype=np.int32)
    # descending_distil = []
    # ascending_distil = []
    # final_preorder = []

    # for desisionMaker in range(desision_makers):
    #     print(f'Process starts for desision maker {desisionMaker + 1}.')
    #     (results_final[desisionMaker, :], results_desc[desisionMaker, :], results_asc[desisionMaker, :],
    #      desc_distil, asc_distil, f_preorder) = electre3.run()
    #     descending_distil.append(desc_distil)
    #     ascending_distil.append(asc_distil)
    #     final_preorder.append(f_preorder)

    # for maker in range(desision_makers):
    #     print(
    #         f'Desision maker {maker + 1} results: |descending preorder|: {descending_distil[maker]} '
    #         + f'|ascendng preorder|: {ascending_distil[maker]}'
    #         + f'   results: |final rank|: {final_preorder[maker]}, |ranking|: {electre3.hlp.x.altNames} => {results_final}')  # noqa

    # temp = exploitation.run(credibility_mtrx=electre3.hlp.ld.x.decMatrix)
    # df_phi = pd.DataFrame(results_phi)
    # df_desc = pd.DataFrame(results_desc)
    # df = pd.merge(df_phi, df_desc, how='outer', left_index=True, right_index=True, suffixes=("_Φ", "_desc"))
    # print(df)
    '''


def run_auto(shared_list, data):
    data = pickle.loads(data)

    try:
        x = initialize(data)
    except ValueError as ve:
        shared_list.append(['ve', ve])
        raise ValueError(ve)
    try:
        results = electre3.run(x, shared_list)
        shared_list.append(x.decMatrix)
        shared_list.append(results)
    except KeyboardInterrupt as ki:
        raise KeyboardInterrupt(ki)
