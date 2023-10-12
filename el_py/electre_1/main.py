import numpy as np
import pickle
from . import electre1
# import electre1


def initialize(data):
    x = data[1]
    s = data[2]
    fullinitialdata = data[3]

    if x is None:
        x = electre1.hlp.ld.Store_data()
        raise ValueError('Cant retrieve data.')

    critnames = fullinitialdata[0]
    critnames = critnames[1:]
    print(f'CRITNAMES: \n\n{critnames}\n\n')
    x.critNames = np.array(critnames, dtype=object)

    altnames = []
    for item in fullinitialdata:
        altnames.append(item[0])

    altnames = altnames[1:-3]
    print(f'ALTNAMES: \n\n{altnames}\n\n')
    x.altNames = np.array(altnames, dtype=object)

    optType = fullinitialdata[-3][1:]
    for i, item in enumerate(optType):
        if item == 'Maximize':
            optType[i] = 0
        elif item == 'Minimize':
            optType[i] = 1

    weights = fullinitialdata[-2][1:]
    weights = [0 if w == '' else w for w in weights]
    weights = [float(w) for w in weights]
    v = fullinitialdata[-1][1:]
    v = [0 if i == '' else i for i in v]
    v = [float(i) for i in v]
    decMatrix = np.array(fullinitialdata[1:-3])
    decMatrix = decMatrix[:, 1:]
    decMatrix = np.where(decMatrix == '', 0, decMatrix)
    decMatrix = decMatrix.astype(float)
    x.decMatrix = decMatrix

    x.alt = x.altNames.size
    x.crit = x.critNames.size

    x = electre1.hlp.El1_init(class_=x, s=s)
    x.optType = np.array(optType).reshape((1, x.crit))
    x.w = np.array(weights).reshape((1, x.crit))
    x.v = np.array(v).reshape((1, x.crit))

    if x.w.all() == 0 or decMatrix.all() == 0:
        raise ValueError(
            'There were no values entered. Please enter the correct values in the Data Entry table. ' +
            'Do not leave the cells empty.')

    return x
    # desision_makers = int(input('How many desision makers are running the ELECTRE I algorithm?\n'))
    # results_rank = np.full((desision_makers, alt), 0)
    # phi_net = np.full_like(a=results_rank, fill_value=0, dtype=np.float64)

    # for desisionMaker in range(desision_makers):
    #     print(f'Process starts for desision maker {desisionMaker + 1}.')
    #     results_rank[desisionMaker, :], phi_net[desisionMaker, :] = electre1.run()

    # for maker in range(desision_makers):
    #     print(
    #         f'Desision maker {maker + 1} results: |Φ rank|: {results_rank[maker]} |Φnet|: {phi_net[maker]}')


def run_auto(shared_list, data):
    data = pickle.loads(data)

    try:
        x = initialize(data)
    except ValueError as ve:
        shared_list.append(['ve', ve])
        raise ValueError(ve)
    try:
        results = electre1.run(x, shared_list)
        shared_list.append(x.decMatrix)
        shared_list.append(results)
    except KeyboardInterrupt as ki:
        raise KeyboardInterrupt(ki)
