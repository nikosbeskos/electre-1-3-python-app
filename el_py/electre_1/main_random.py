# This is the handling file of the project with random generated values

import numpy as np
from io import StringIO
import pickle
import multiprocessing
from math import ceil
from tqdm import tqdm
from . import electre1
from . import analysis as an

termination_Event = multiprocessing.Event()


def initialize():   # for console input [not used with GUI]
    print('\n\nELECTRE I algorithm with random numbers generator strarted.\n')

    # Load files from .xlsx file
    electre1.hlp.ld.run()
    desision_makers = int(input('How many desision makers are running the ELECTRE I algorithm?\n'))

    while True:     # get +- tolerance
        print('Enter the tolerance for the random numbers generator. ' +
              'Numbers will be generated from user input at |\u00B1 0-100%|')
        tolerance = electre1.hlp.input_data() / 100
        if tolerance > 0 and tolerance < 1:
            electre1.hlp.y.tolerance = tolerance
            print(f'The generated numbers will be \u00B1 {tolerance*100}% from user inputs.')
            break
        else:
            print('Wrong input. has to be in (0,100).')

    while True:     # get distribution
        print('What distribution do you wand to apply to random numbers?')
        print('       |uniform=1|\n       |normal=2|\n       |triangular=3|\n       |beta=4|')
        dist = input()
        if dist in ['1', '2', '3', '4']:
            electre1.hlp.y.dist = dist
            break
        else:
            print(f'Has to be one of the {[1, 2, 3, 4]}')

    # This changes the electre1.alt variable to its real value
    alt = electre1.hlp.ld.x.alt

    results_phi = np.full((desision_makers, alt), 0)
    phi_net = np.full((desision_makers, alt), 0, dtype=np.float64)
    index_values = np.empty(shape=(1, desision_makers), dtype=object)

    # start the process
    # First we need to get seed attributes from user first using 'x' instance
    electre1.hlp.run()

    # And then generate random values using user's seed attributes and get them
    temp = []
    for desisionMaker in range(desision_makers):
        print(f'Process starts for desision maker {desisionMaker + 1}.')
        temp = list(electre1.run_r())
        results_phi[desisionMaker] = temp[0]
        phi_net[desisionMaker] = temp[1]

    # show the progress and set the index values for the dataframe
    for maker in range(desision_makers):
        print(f'Desision maker {maker + 1} results phi rank: {results_phi[maker]}')
        index_values[0, maker] = f'Desision maker {maker+1}'

    expexted_rank, rank_acceptability = an.run(
        results_phi=results_phi, index_values=index_values)

    print(f'\n\nRank acceptabilty matrix (Φ):\n{rank_acceptability[:,:alt]*100}\n')
    print(f'expected ranks (Φ):\n{expexted_rank[:alt]}\n')


def initialize_auto(data):
    x = data[1]
    s = data[2]
    tolerance = data[3]
    distribution = data[4]
    iternum = data[5]
    fullinitialdata = data[6]

    if x is None:
        x = electre1.hlp.ld.Store_data()
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

    altnames = altnames[1:-3]
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

    return x, tolerance, distribution, iternum


# using multiprocessing for better and faster performance in a large number of iterations (e.g. 10000)
def run_iteration(args):    # one iteration block
    iter_num, class_, tolerance, dist = args
    temp = list(electre1.run_r(class_=class_, tolerance=tolerance, dist=dist))
    return temp


# Monte Carlo (run all iterations) with multiprocessing
def run_monte_carlo(iter_num, class_: electre1.hlp.El1_init, tolerance, dist, shared_list):
    global termination_Event

    cores_num = multiprocessing.cpu_count()
    # limit simultaneous processes to the number of logical cores of the systems cpu
    pool = multiprocessing.Pool(processes=ceil(cores_num * (90/100)))
    # start multiprocessing, and use tqdm to print a progreass bar of the opaerations
    results = []
    tqdm_output = StringIO()
    tqdm_obj = tqdm(total=iter_num, file=tqdm_output)

    for result in pool.imap_unordered(run_iteration, [(i, class_, tolerance, dist) for i in range(iter_num)]):
        results.append(result)
        tqdm_obj.update()
        shared_list[0] = tqdm_obj.n / iter_num * 100

        if termination_Event.is_set():
            pool.terminate()
            pool.join()
            raise KeyboardInterrupt('Interrupted by user')

    tqdm_output.close()

    return results


def get_acceptabilities(results):
    temp = an.run([result[0] for result in results])
    return temp


def run_auto(shared_list, data, event):
    global termination_Event
    termination_Event = event
    data = pickle.loads(data)

    try:
        x, tolerance, dist, iter_num = initialize_auto(data)
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
