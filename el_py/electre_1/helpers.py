# This is a helper file to help and support the ELECTRE I file(electre1.py)
# by inputing data and defining variables

import numpy as np
import copy
from . import load_data as ld


class El1_init:
    def __init__(self, class_: ld.Store_data, s=None, tolerance=None, dist=None) -> None:
        self.crit = class_.crit     # num of criteria
        self.alt = class_.alt       # num of alternatives
        self.altNames = class_.altNames     # alternatives names
        self.critNames = class_.critNames   # criteria names
        self.decMatrix = class_.decMatrix   # Decision Matrix
        self.optType = np.full((1, self.crit), -1)                  # Min or Max
        self.w = np.full_like(self.optType, -1, dtype=np.float64)   # Weights
        self.v = np.full_like(self.optType, -1, dtype=np.float64)   # Veto Threshold
        self.s = s          # Concordance level
        self.tolerance = tolerance
        self.dist = dist        # Distribution index


def input_data():   # Used with get_input() method
    try:
        x = input()
        return float(x)
    except ValueError:
        print('Has to have some kind of value.')
        x = -1
        return float(x)


def get_input(class_: El1_init):    # User ipnput data from console [not used with GUI]
    x = class_
    for criterion in range(x.crit):
        while True:
            print('Enter the optimization type(min or max), |min=1, max=0| for criterion',
                  x.critNames[criterion]+':')
            x.optType[0, criterion] = int(input_data())
            if x.optType[0, criterion] == 1 or x.optType[0, criterion] == 0:
                break
            else:
                print('Wrong input.')
        while True:
            print('Enter the weight (w) for criterion', x.critNames[criterion]+':')
            x.w[0, criterion] = input_data()
            if x.w[0, criterion] >= 0 and x.w[0, criterion] <= 1:
                break
            else:
                print('The value has to be between 0 and 1.')
        while True:
            print('Enter the Veto threshold (v) for criterion', x.critNames[criterion]+':')
            x.v[0, criterion] = input_data()
            if x.v[0, criterion] >= 0:
                break
            else:
                print('The value has to be >= 0. If there is no value just enter 0.')
    while True:
        print('Enter the Concordance level parameter (s) | 0.5 <= s < 1 :')
        x.s = input_data()
        if x.s >= 0.5 and x.s < 1:
            break
        else:
            print('The value has to be >= 0.5 and < 1.')


def generate_r_thresh_values(class1: El1_init, class2: El1_init):     # random generated data

    x = class1
    y = class2
    rng = np.random.default_rng()

    tolerance = y.tolerance
    dist = y.dist

    while True:
        w = rng.random(size=np.shape(x.w), dtype=np.float64)    # uniform
        w /= w.sum(axis=1)
        if np.sum(w[0, :-1]) < 1:
            w[0, -1] = 1 - np.sum(w[0, :-1])
            y.w = w
            break

    for crit in range(x.crit):
        if dist == '1':
            while True:
                if x.v[0, crit] != 0:
                    v = float(rng.uniform(low=(x.v[0, crit] - (tolerance * x.v[0, crit])),
                                          high=(x.v[0, crit] + (tolerance * x.v[0, crit])), size=1))
                    y.v[0, crit] = v
                    break
                else:
                    v = float(rng.uniform(low=0, high=tolerance, size=1))
                    y.v[0, crit] = v
                    break

        elif dist == '2':
            val = np.array([(x.v[0, crit] - (tolerance * x.v[0, crit])), (x.v[0, crit] + (tolerance * x.v[0, crit]))])
            m = np.mean(a=val)
            s = np.std(a=val)

            while True:
                if x.v[0, crit] != 0:
                    val[0] = (x.v[0, crit] - (tolerance * x.v[0, crit]))
                    val[1] = (x.v[0, crit] + (tolerance * x.v[0, crit]))
                    m = np.mean(a=val)
                    s = np.std(a=val)
                    v = rng.normal(loc=float(m), scale=s/3.05)
                    y.v[0, crit] = v
                    break
                else:
                    val[0] = 0
                    val[1] = tolerance
                    m = np.mean(a=val)
                    s = np.std(a=val)
                    v = rng.normal(loc=float(m), scale=s/3.05)
                    y.v[0, crit] = v
                    break

        elif dist == '3':
            left = (x.v[0, crit] - (tolerance * x.v[0, crit]))
            right = (x.v[0, crit] + (tolerance * x.v[0, crit]))

            while True:
                if x.v[0, crit] != 0:
                    left = (x.v[0, crit] - (tolerance * x.v[0, crit]))
                    right = (x.v[0, crit] + (tolerance * x.v[0, crit]))
                    v = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    y.v[0, crit] = v
                    break
                else:
                    left = 0
                    right = tolerance
                    v = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    y.v[0, crit] = v
                    break

        elif dist == '4':  # beta outputs to [0,1] thus it needs to be relocated to our desired range [vmin,vmax]
            thresh = np.array([(x.v[0, crit] - (tolerance * x.v[0, crit])),
                              (x.v[0, crit] + (tolerance * x.v[0, crit]))])

            while True:
                if x.v[0, crit] != 0:
                    thresh[0] = (x.v[0, crit] - (tolerance * x.v[0, crit]))
                    thresh[1] = (x.v[0, crit] + (tolerance * x.v[0, crit]))
                    exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
                    coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                                     ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
                    Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
                    Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
                    c = rng.beta(a=float(Alpha), b=float(Beta), size=1)

                    # relocation of beta values output from [0,1] to [v-tolerance,v+tolerance]
                    interval = thresh[1] - thresh[0]           # get the interval(range) of our +- tolerance and then
                    relocated_v = thresh[0] + (interval * c)   # aply the beta distribution on that range. We have an
                    y.v[0, crit] = relocated_v                 # interval that follows beta dist. Then add this intelval
                    break                                      # to the vmin value to get the right output range
                else:
                    thresh[0] = 0
                    thresh[1] = tolerance
                    exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
                    coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                                     ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
                    Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
                    Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
                    c = rng.beta(a=float(Alpha), b=float(Beta), size=1)

                    # relocation of beta values output from [0,1] to [0,tolerance]
                    interval = thresh[1] - thresh[0]
                    relocated_v = thresh[0] + (interval * c)
                    y.v[0, crit] = relocated_v
                    break
    return y


def run(class_: ld.Store_data):  # run with user input from console [not used with GUI]
    x = class_
    x = El1_init(class_=x)
    get_input(class_=x)
    return x


def run_r(class_: El1_init, tolerance, dist):    # run with generator attributes
    x = class_
    x.tolerance = tolerance
    x.dist = dist
    y = copy.deepcopy(x)
    y = generate_r_thresh_values(class1=x, class2=y)
    return y
