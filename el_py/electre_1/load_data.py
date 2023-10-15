# This module is used to load data form .xlsx files

import numpy as np
import pandas as pd
import os


class Store_data:   # Stores the data from the file
    def __init__(self) -> None:
        self.altNames = 0    # alternatives names
        self.critNames = 0   # criteria names
        self.decMatrix = 0   # Decision Matrix
        self.crit = 0        # num of criteria
        self.alt = 0         # num of alternatives

    # DEFAULT VALUES FOR DEBUG ######################################
    # critNames = ['C1', 'C2', 'C3', 'C4']
    # altNames = ['A1', 'A2', 'A3', 'A4', 'A5', 'A6']
    # optType = np.array([1, 0, 0, 0])  # Min or Max
    # w =       np.array([0.33, 0.27, 0.2, 0.2])  # weights
    # v =       np.array([150, 2, 0, 0])  # Veto Threshold

    # temp = np.array([[300, 3, 2, 2],
    #                 [250, 3, 1, 2],
    #                 [250, 2, 2, 2],
    #                 [200, 2, 2, 1],
    #                 [200, 2, 1, 2],
    #                 [100, 1, 1, 1]])  # Decision Matrix data

    # decMatrix = temp  # Decision Matrix
    #################################################################


def file_input(filepath=None):      # console usage [not used with GUI]
    file_path = r'your\filepath\to\excelfile.xlsx'
    filepath = file_path
    check = input(f'Is this the file(default file) you want to load? |file: {filepath} |y/n\n')  # noqa

    while True:
        if check.lower() == 'y':
            filepath = file_path
            if os.path.exists(filepath):
                break
            else:
                print(f"File not found at path: {filepath}")
                check = input("Do you want to provide another path? y/n\n")
                if check.lower() == 'y':
                    filepath = input('Put the filepath followed with {\\filename.xlsx} of the file you want to load: ')     # noqa
                else:
                    break
        elif check.lower() == 'n':
            filepath = input('Put the filepath followed with {\\filename.xlsx} of the file you want to load: ')  # noqa
            if os.path.exists(filepath):
                break
            else:
                print(f"File not found at path: {filepath}")
                check = input("Do you want to provide another path? y/n\n")
        try:
            if os.path.isfile(filepath):
                if not filepath.endswith('.xlsx'):
                    raise ValueError("Invalid file format. Only excel (.xlsx) files are accepted.")     # noqa
                break
            else:
                print(f"File not found at path: {filepath}")
                check = input("Do you want to provide another path? y/n\n")

        except Exception as e:
            print(f"An error occurred: {e}")
            check = input("Do you want to provide another path? y/n\n")
    return filepath


def load_data(class_: Store_data, ismanual: bool, path=None):   # loads data from file_path, cleans it, and dumps it in Store_data # noqa

    x = class_
    if ismanual:
        filepath = file_input()
    else:
        if path:
            filepath = path
        else:
            return None

    df = pd.read_excel(filepath, 0)

    df.dropna(axis=0, how='all', inplace=True)
    df.dropna(axis=1, how='all', inplace=True)
    df.set_axis(labels=df.iloc[0], axis='columns', copy=False)

    x.altNames = df.iloc[1:, 0].to_numpy()
    df.drop(df.columns[0], axis='columns', inplace=True)

    x.critNames = df.columns.to_numpy()

    decMatrix = df.iloc[1:].to_numpy(dtype=np.float64)  # Decision Matrix
    x.decMatrix = np.abs((decMatrix))

    x.crit = np.shape(decMatrix)[1]
    x.alt = np.shape(decMatrix)[0]

    check = x.alt * x.crit
    if check != 0:
        print(f'Data loaded succesfully from {filepath}')
    else:
        print(f'Thers has to be something wrong with the file. filepath: {filepath}')  # noqa
    return x


def run():      # console usage [not used with GUI]
    x = Store_data()
    x = load_data(x, ismanual=True)
    return x


def run_auto(filepath):
    x = Store_data()
    x = load_data(x, False, filepath)
    return x
