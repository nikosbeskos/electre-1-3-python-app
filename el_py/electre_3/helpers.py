# This is a helper file to help and support the ELECTRE III file(electre3.py)
# by inputing data and defining variables

import numpy as np
import copy
from . import load_data as ld

# Input Data and Definitions for ELECTRE III algorithm


class El3_init:
    def __init__(self, class_: ld.Store_data, tolerance=None, dist=None) -> None:
        self.crit = class_.crit  # num of criteria
        self.alt = class_.alt   # num of alternatives
        self.altNames = class_.altNames    # alternatives names
        self.critNames = class_.critNames   # criteria names
        self.decMatrix = class_.decMatrix   # Decision Matrix
        self.optType = np.full((1, self.crit), -1)     # Min or Max
        self.w = np.full_like(self.optType, -1, dtype=np.float64)  # Weights
        self.q = np.full_like(self.optType, -1, dtype=np.float64)  # Indifference Threshold
        self.p = np.full_like(self.optType, -1, dtype=np.float64)  # Preference Threshold
        self.v = np.full_like(self.optType, -1, dtype=np.float64)  # Veto Threshold
        self.tolerance = tolerance
        self.dist = dist

    # def get_attributes(self):
    #     self.crit = ld.x.crit   # num of criteria
    #     self.alt = ld.x.alt     # num of alternatives
    #     self.altNames = ld.x.altNames       # alternatives names
    #     self.critNames = ld.x.critNames     # criteria names
    #     self.decMatrix = ld.x.decMatrix     # Decision Matrix
    #     self.optType = np.full((1, self.crit), -1)    # Min or Max
    #     self.w = np.full_like(self.optType, -1, dtype=np.float64)   # Weights
    #     self.q = np.full_like(self.optType, -1, dtype=np.float64)   # Indifference Threshold
    #     self.p = np.full_like(self.optType, -1, dtype=np.float64)   # Preference Threshold
    #     self.v = np.full_like(self.optType, -1, dtype=np.float64)   # Veto Threshold


def input_data():
    try:
        x = input()
        return float(x)
    except ValueError:
        print('Has to have some kind of value.')
        x = -1
        return float(x)


def get_input(class_: El3_init):    # User ipnput data
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
            print('Enter the Indifference threshold (q) for criterion', x.critNames[criterion]+':')
            x.q[0, criterion] = input_data()
            if x.q[0, criterion] >= 0:
                break
            else:
                print('The value has to be >= 0.')
        while True:
            print('Enter the Preference threshold (p) for criterion', x.critNames[criterion]+':')
            x.p[0, criterion] = input_data()
            if x.p[0, criterion] >= x.q[0, criterion]:
                break
            else:
                print('The value has to be >= of q=' +
                      str(x.q[0, criterion]), 'for criterion', x.critNames[criterion] + '.')
        while True:
            print('Enter the Veto threshold (v) for criterion', x.critNames[criterion]+':')
            x.v[0, criterion] = input_data()
            if x.v[0, criterion] >= 0:  # x.p[0, criterion]:
                break
            else:
                print('The value has to be >= 0. If there is no value just enter 0.')
    return x


def generate_r_thresh_values(class_1: El3_init, class_2: El3_init):     # random generated data

    x = class_1
    y = class_2
    rng = np.random.default_rng()
    y.w = x.w.copy()
    y.p = x.p.copy()
    y.q = x.q.copy()
    y.v = x.v.copy()

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
            y.q[0, crit] = float(rng.uniform(low=(x.q[0, crit] - (tolerance * x.q[0, crit])),
                                             high=(x.q[0, crit] + (tolerance * x.q[0, crit])), size=1))

            while True:
                if x.p[0, crit] != 0:
                    p = float(rng.uniform(low=(x.p[0, crit] - (tolerance * x.p[0, crit])),
                                          high=(x.p[0, crit] + (tolerance * x.p[0, crit])), size=1))
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break
                else:
                    p = float(rng.uniform(low=0, high=tolerance, size=1))
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break

            while True:
                if x.v[0, crit] != 0:
                    v = float(rng.uniform(low=(x.v[0, crit] - (tolerance * x.v[0, crit])),
                                          high=(x.v[0, crit] + (tolerance * x.v[0, crit])), size=1))
                    if v >= y.p[0, crit]:
                        y.v[0, crit] = v
                        break
                else:
                    v = float(rng.uniform(low=0, high=tolerance, size=1))
                    y.v[0, crit] = v
                    break

        elif dist == '2':
            val = np.array([(x.q[0, crit] - (tolerance * x.q[0, crit])), (x.q[0, crit] + (tolerance * x.q[0, crit]))])
            m = np.mean(a=val)
            s = np.std(a=val)
            y.q[0, crit] = rng.normal(loc=float(m), scale=s/3.05)

            while True:
                if x.p[0, crit] != 0:
                    val[0] = (x.p[0, crit] - (tolerance * x.p[0, crit]))
                    val[1] = (x.p[0, crit] + (tolerance * x.p[0, crit]))
                    m = np.mean(a=val)
                    s = np.std(a=val)
                    p = rng.normal(loc=float(m), scale=s/3.05)
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break
                else:
                    val[0] = 0
                    val[1] = tolerance
                    m = np.mean(a=val)
                    s = np.std(a=val)
                    p = rng.normal(loc=float(m), scale=s/3.05)
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break

            while True:
                if x.v[0, crit] != 0:
                    val[0] = (x.v[0, crit] - (tolerance * x.v[0, crit]))
                    val[1] = (x.v[0, crit] + (tolerance * x.v[0, crit]))
                    m = np.mean(a=val)
                    s = np.std(a=val)
                    v = rng.normal(loc=float(m), scale=s/3.05)
                    if v >= y.p[0, crit]:
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
            left = (x.q[0, crit] - (tolerance * x.q[0, crit]))
            right = (x.q[0, crit] + (tolerance * x.q[0, crit]))
            y.q[0, crit] = rng.triangular(left=left, right=right,
                                          mode=float(rng.uniform(low=left, high=right, size=1)), size=1)

            while True:
                if x.p[0, crit] != 0:
                    left = (x.p[0, crit] - (tolerance * x.p[0, crit]))
                    right = (x.p[0, crit] + (tolerance * x.p[0, crit]))
                    p = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break
                else:
                    left = 0
                    right = tolerance
                    p = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    if p >= y.q[0, crit]:
                        y.p[0, crit] = p
                        break

            while True:
                if x.v[0, crit] != 0:
                    left = (x.v[0, crit] - (tolerance * x.v[0, crit]))
                    right = (x.v[0, crit] + (tolerance * x.v[0, crit]))
                    v = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    if v >= y.p[0, crit]:
                        y.v[0, crit] = v
                        break
                else:
                    left = 0
                    right = tolerance
                    v = rng.triangular(left=left, right=right,
                                       mode=float(rng.uniform(low=left, high=right, size=1)), size=1)
                    y.v[0, crit] = v
                    break

        elif dist == '4':
            thresh = np.array([(x.q[0, crit] - (tolerance * x.q[0, crit])),
                              (x.q[0, crit] + (tolerance * x.q[0, crit]))])
            exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
            coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                             ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
            Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
            Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
            c = rng.beta(a=float(Alpha), b=float(Beta), size=1)
            interval = thresh[1] - thresh[0]
            relocation = thresh[0] + (interval * c)
            q = relocation
            if q >= thresh[0] and q <= thresh[1]:
                y.q[0, crit] = q

            while True:
                if x.p[0, crit] != 0:
                    thresh[0] = (x.p[0, crit] - (tolerance * x.p[0, crit]))
                    thresh[1] = (x.p[0, crit] + (tolerance * x.p[0, crit]))
                    exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
                    coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                                     ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
                    Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
                    Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
                    c = rng.beta(a=float(Alpha), b=float(Beta), size=1)
                    interval = thresh[1] - thresh[0]
                    relocation = thresh[0] + (interval * c)
                    p = relocation
                    if p >= y.q[0, crit] and p <= thresh[1]:
                        y.p[0, crit] = p
                        break
                else:
                    thresh[0] = 0
                    thresh[1] = tolerance
                    exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
                    coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                                     ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
                    Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
                    Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
                    c = rng.beta(a=float(Alpha), b=float(Beta), size=1)
                    interval = thresh[1] - thresh[0]
                    relocation = thresh[0] + (interval * c)
                    p = relocation
                    if p >= y.q[0, crit] and p <= thresh[1]:
                        y.p[0, crit] = p
                        break
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
                    interval = thresh[1] - thresh[0]
                    relocation = thresh[0] + (interval * c)
                    v = relocation
                    if v >= y.p[0, crit] and v <= thresh[1]:
                        y.v[0, crit] = v
                        break
                else:
                    thresh[0] = 0
                    thresh[1] = tolerance
                    exp = rng.uniform(low=float(thresh[0]), high=float(thresh[1]), size=1)
                    coef = 1 + (4 * (((exp - thresh[0]) * (thresh[1] - exp)) /
                                     ((thresh[1] - thresh[0]) * (thresh[1] - thresh[0]))))
                    Alpha = (2 * thresh[1] + (4 * exp) - (5 * thresh[0])) / (3 * (thresh[1] - thresh[0])) * coef
                    Beta = (2 * (5 * thresh[1]) - (4 * exp) - thresh[0]) / (3 * (thresh[1] - thresh[0])) * coef
                    c = rng.beta(a=float(Alpha), b=float(Beta), size=1)
                    interval = thresh[1] - thresh[0]
                    relocation = thresh[0] + (interval * c)
                    v = relocation
                    if v >= thresh[0] and v <= thresh[1]:
                        y.v[0, crit] = v
                        break
    return y


def run(class_: ld.Store_data):  # run with user input
    x = class_
    x = El3_init(class_=x)
    x = get_input(class_=x)
    return x


def run_r(class_: El3_init, tolerance, dist):  # run with generator attributes
    x = class_
    x.tolerance = tolerance
    x.dist = dist
    y = copy.deepcopy(x)
    y = generate_r_thresh_values(class_1=x, class_2=y)
    return y
