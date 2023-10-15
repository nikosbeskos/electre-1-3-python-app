from multiprocessing import Manager, Process, freeze_support, managers

from PySide6.QtCore import QObject, Signal, Slot

from el_py.electre_1.main_random import run_auto as el1_run_auto
from el_py.electre_3.main_random import run_auto as el3_run_auto


class BackendWorker(QObject):
    '''
    Worker object for performing the backend work in a separate thread.
    '''
    progress = Signal(float)
    finished = Signal(list)
    error = Signal(str, list)

    def __init__(self, shared_list: managers.ListProxy, process: Process, runargs: list = []) -> None:
        super().__init__()
        self.shared_list = shared_list
        self.process = process
        self.progress_old = 0
        self.running = []
        self.runargs = runargs

    def run(self) -> None:
        try:
            self.process.start()
            self.running.append(self.process)

            while True:
                if len(self.shared_list) > 0:
                    progress_value = self.shared_list[0]
                    progress_value = float(format(progress_value, ".1f"))
                    if progress_value - self.progress_old > 0.01:
                        self.progress.emit(progress_value)
                        self.progress_old = progress_value
                    # print(progress_value)

                if not self.process.is_alive():
                    break

            self.process.join()
            if self.process in self.running:
                self.running.remove(self.process)
            for item in self.shared_list:
                print(f'ITEM:\t{item}')
                if isinstance(item, list):
                    print('item is list')
                    if 've' in item:
                        print('ve in item')
                        raise ValueError(item[1])
            print('NORMAL FINNISH')
            print(f'----\n--self.running: {self.running}\n--\n--shared_list: {self.shared_list}\n----')
            self.finished.emit(self.running)
        except Exception as ex:
            print('\n\nEXXXX\n')
            if self.process.is_alive():
                self.process.kill()
            self.process.join()
            if self.process in self.running:
                self.running.remove(self.process)
            if type(ex) == ValueError:      # noqa
                self.error.emit(str(ex), self.running)
                print('FROM BACKEND RUN')
                raise ValueError(ex)
            elif type(ex) == TypeError:     # noqa
                self.error.emit(ex, self.running)
                raise TypeError(ex)
            else:
                self.error.emit(ex, self.running)
                print('FROM BACKEND RUN')
                raise Exception(ex)

    @Slot()
    def terminate_process(self):
        if self.process.is_alive():
            self.termination_Event.set()
        self.process.join()
        if self.process in self.running:
            self.running.remove(self.process)
        self.error.emit(KeyboardInterrupt('Interrupted by user'), self.running)

    def start_executing(self):
        freeze_support()
        manager = Manager()
        self.termination_Event = manager.Event()
        shared_list = manager.list()
        shared_list.append(0)
        target = self.runargs[0]
        print(f'''\t\t----------
        ----------
        ----TARGET: {target}
        ----TARGET IS EL3 RANDOM RUN AUTO: {target is el3_run_auto}
        ----------
        ----------''')
        args = self.runargs[1]
        worker = self.runargs[2]
        if target is el3_run_auto or target is el1_run_auto:
            args = (shared_list, args, self.termination_Event)
        else:
            args = (shared_list, args)

        try:
            p1 = Process(target=target, args=args)

            worker.shared_list = shared_list
            worker.process = p1

            worker.run()
        except Exception as ex:
            print(ex)
            print('FROM BACKEND EXECUTING')
