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
