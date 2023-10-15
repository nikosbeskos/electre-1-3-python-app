# This is the handling file of the project with random generated values

from io import StringIO
from math import ceil
import multiprocessing
import numpy as np
import pickle
from tqdm import tqdm

from . import analysis as an
from . import electre3

termination_Event = multiprocessing.Event()


def intitialize():  # get required initial values, load data form ecxel etc. For console input [not used with GUI]     # noqa
    print('\n\nELECTRE III algorithm with random numbers generator strarted.\n')

    # Load files from .xlsx file
    x = electre3.hlp.ld.run()
    if x is None:
        raise ValueError('File path not specified.')

    desision_makers = int(input('How many desision makers are running the ELECTRE III algorithm?\n'))

    while True:     # get +- tolerance
        print('Enter the thresholds for the random numbers generator. ' +
              'Numbers will be generated from user input at |\u00B1 0-100%|')
        tolerance = electre3.hlp.input_data() / 100
        if tolerance > 0 and tolerance < 1:
            print(f'The generated numbers will be \u00B1 {tolerance*100}% from user inputs.')
            break
        else:
            print('Wrong input. has to be in (0,100).')

    while True:     # get distribution
        print('What distribution do you wand to apply to random numbers?')
        print('       |uniform=1|\n       |normal=2|\n       |triangular=3|\n       |beta=4|')
        dist = input()
        if dist in ['1', '2', '3', '4']:
            break
        else:
            print(f'Has to be one of the {[1, 2, 3, 4]}')

    x = electre3.hlp.run(class_=x)

    return x, tolerance, dist, desision_makers


def intitialize_auto(data):
    x = data[1]
    tolerance = data[2]
    distribution = data[3]
    iternum = data[4]
    fullinitialdata = data[5]

    if x is None:
        x = electre3.hlp.ld.Store_data()
        raise ValueError('Cant retrieve data.')

    if tolerance.endswith(' %'):
        tolerance = int(tolerance[:-2])/100
    else:
        tolerance = int(tolerance)/100

    if distribution == 'Uniform':
        distribution = '1'
    elif distribution == 'Normal':
        distribution = '2'
    elif distribution == 'Triangular':
        distribution = '3'
    elif distribution == "Beta":
        distribution = '4'
    else:
        raise ValueError(f'Wrong distribution value was given: {distribution}')

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

    x = electre3.hlp.El3_init(class_=x, tolerance=tolerance, dist=distribution)
    x.optType = np.array(optType).reshape((1, x.crit))
    x.w = np.array(weights).reshape((1, x.crit))
    x.q = np.array(q).reshape((1, x.crit))
    x.p = np.array(p).reshape((1, x.crit))
    x.v = np.array(v).reshape((1, x.crit))

    if x.w.all() == 0 or x.p.all() == 0 or decMatrix.all() == 0:
        raise ValueError(
            'There were no values entered. Please enter the correct values in the Data Entry table. ' +
            'Do not leave the cells empty.')

    return x, tolerance, distribution, iternum


# using multiprocessing for better and faster performance in a large number of iterations (e.g. 10000)
def run_iteration(args):    # one iteration block
    iteration_num, class_, tolerance, dist = args
    temp = list(electre3.run_r(class_=class_, tolerance=tolerance, dist=dist))
    return temp


# Monte Carlo (run all iterations) with multiprocessing
def run_monte_carlo(num_iterations, class_: electre3.hlp.El3_init, tolerance, dist, shared_list):
    global termination_Event

    num_cores = multiprocessing.cpu_count()
    # limit simultaneous processes to the number of logical cores of the systems cpu
    pool = multiprocessing.Pool(processes=ceil(num_cores * (90/100)))
    # start multiprocessing, and use tqdm to print a progreass bar of the opaerations
    results = []
    tqdm_output = StringIO()
    tqdm_obj = tqdm(total=num_iterations, file=tqdm_output)
    for result in pool.imap_unordered(run_iteration, [(i, class_, tolerance, dist) for i in range(num_iterations)]):
        results.append(result)
        tqdm_obj.update()
        shared_list[0] = tqdm_obj.n / num_iterations * 100

        if termination_Event.is_set():
            pool.terminate()
            pool.join()
            raise KeyboardInterrupt('Interrupted by user')

    tqdm_output.close()

    return results


def get_acceptabilities(results):   # self explanatory
    temp = an.run([result[0] for result in results])
    return temp


def run_auto(shared_list, data, event):  # Run the script
    global termination_Event
    termination_Event = event
    data = pickle.loads(data)

    try:
        x, tolerance, dist, iter_num = intitialize_auto(data)
    except ValueError as ve:
        shared_list.append(['ve', ve])
        raise ValueError(ve)

    try:
        results = run_monte_carlo(iter_num, x, tolerance, dist, shared_list)
        expected_rank, rank_acceptability = get_acceptabilities(results)
        shared_list.append(x.decMatrix)
        shared_list.append(expected_rank)
        shared_list.append(rank_acceptability)
    except KeyboardInterrupt as ki:
        raise KeyboardInterrupt(ki)
