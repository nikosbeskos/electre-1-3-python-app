# This Python file uses the following encoding: utf-8
import os
import pickle
import sys

# import copy
from PySide6.QtCore import (QAbstractTableModel, QObject, Qt, QThread,  # noqa
                            QtMsgType, QUrl, Signal, Slot,
                            qInstallMessageHandler)
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QJSValue, QQmlApplicationEngine, qmlRegisterType

import backend
import create_table_model_E
from el_py.electre_1 import main as el1_main
from el_py.electre_1 import main_random as el1_main_random
from el_py.electre_3 import main as el3_main
from el_py.electre_3 import main_random as el3_main_random


class Comm(QObject):
    '''
    Object - slot-owner and signal acceptor/emiter.\n
    Trully a comms class.
    '''
    excelReadDataSignal = Signal(list, list, name='excelReadDataSignal', arguments=['rown', 'coln'])
    processError = Signal(str, name="processError", arguments=['err'])
    progress = Signal(float, name='progress', arguments=['num'])
    close_thread = Signal()
    crit_alt_num = Signal(list, name='crit_alt_num', arguments=['altCritNum'])
    backend_finished = Signal()
    get_results_models = Signal()
    svg_src = Signal(str)

    def __init__(self) -> None:
        super().__init__()
        self.existing_model: create_table_model_E.CustomTableModel = None
        self.results_model: create_table_model_E.CustomTableModel = None
        self.row_names = None
        self.col_names = None
        self.optType = None
        self.method = None
        self.mode = None
        self.s_thresh = None
        self.iter_no = None
        self.distribution = None
        self.excelfilepath = None
        self.decmatrix = None
        self.tolerance = None
        self.x = None
        self.Wthread: QThread = None
        self.worker: backend.BackendWorker = None
        self.final_data = None

    def get_excel_data(self) -> None:
        x = el3_main.electre3.hlp.ld.run_auto(self.excelfilepath)
        self.row_names = x.altNames.tolist()
        self.col_names = x.critNames.tolist()
        self.decmatrix = x.decMatrix
        self.x = x
        self.crit_alt_num.emit([self.x.alt, self.x.crit])

    @Slot(QJSValue, QJSValue)
    def handle_row_col_data(self, row_names: QJSValue, col_data: QJSValue) -> None:
        row_names = row_names.toVariant()
        col_data = col_data.toVariant()
        col_names = []
        optType = []
        print("Signal received from QML - Row Names:", row_names)
        print("Signal received from QML - Column Names:", col_data)
        print("Updating the Table Model..")
        self.row_names = list(row_names)
        for item in col_data:
            col_names.append(item[0])
            optType.append(item[1])
        self.col_names = col_names
        self.optType = optType

    @Slot(str, str)
    def handle_method_and_mode(self, method: str, mode: str) -> None:
        self.method = method
        self.mode = mode
        if method == "el1":
            data = [self.optType, self.decmatrix]
            model = create_table_model_E.update_model(
                self.row_names, self.col_names, data, self.existing_model, False)
        elif method == "el3":
            data = [self.optType, self.decmatrix]
            model = create_table_model_E.update_model(
                self.row_names, self.col_names, data, self.existing_model, True)

        if model:
            print("Table Model ready")

    @Slot(QJSValue)
    def handle_filepath(self, filepath: QJSValue) -> None:
        self.excelfilepath = filepath.toLocalFile()
        self.get_excel_data()

        self.excelReadDataSignal.emit(self.row_names, self.col_names)

    @Slot(str, str, str)
    def handle_options_data(self, s_thresh: str, iter_no: str, distribution: str, tolerance: str) -> None:
        self.s_thresh = (float(s_thresh) if s_thresh != '' else s_thresh)
        self.iter_no = (int(iter_no) if iter_no != '' else iter_no)
        self.distribution = distribution
        self.tolerance = tolerance

    @Slot(QJSValue)
    def handle_results_models(self, models: QJSValue) -> None:
        if self.method == 'el1':
            if self.mode == 'simple':
                models = models.toVariant()
                # graph the rank
                from el_py.electre_3 import graphs  # noqa

                final = self.final_data[2][3]

                # get svg icon code because matplotlib gets demonized with pyside6
                svg_code = graphs.run_el1(final)
                self.svg_src.emit(svg_code)

                # superiority
                create_table_model_E.update_results_model(
                    models[0], self.final_data, 'superiority', self.existing_model, s_thresh=self.s_thresh, isEl3=False)

                # ranking
                create_table_model_E.update_results_model(
                    models[1], self.final_data, 'ranking', self.existing_model, isEl3=False)
            if self.mode == 'monte':
                models = models.toVariant()
                # expected
                create_table_model_E.update_results_model(
                    models[0], self.final_data, 'expected', self.existing_model, isEl3=False)
                # accpetability
                create_table_model_E.update_results_model(
                    models[1], self.final_data, 'acceptability', self.existing_model, isEl3=False)
        if self.method == 'el3':
            if self.mode == 'simple':
                models = models.toVariant()
                # graphs with distillations
                from el_py.electre_3 import graphs  # noqa

                descending = self.final_data[2][3]
                ascending = self.final_data[2][4]
                final = self.final_data[2][5]
                # get svg icon code because matplotlib gets demonized with pyside6
                svg_code = graphs.run(ascending, descending, final)
                self.svg_src.emit(svg_code)

                # creddeg
                create_table_model_E.update_results_model(
                    models[0], self.final_data, 'creddeg', self.existing_model)
                # ranking
                create_table_model_E.update_results_model(
                    models[1], self.final_data, 'ranking', self.existing_model)
            if self.mode == 'monte':
                models = models.toVariant()
                # expected
                create_table_model_E.update_results_model(
                    models[0], self.final_data, 'expected', self.existing_model)
                # accpetability
                create_table_model_E.update_results_model(
                    models[1], self.final_data, 'acceptability', self.existing_model)

    @Slot()
    def handle_start_python_process(self) -> None:
        if self.method == 'el1':
            if self.mode == 'simple':
                data = [self.excelfilepath, self.x, self.s_thresh, self.existing_model.getAllData()]
                data = pickle.dumps(data)

                # Start a process for the back end work so that main process can continue the gui loop.
                # Main backend work process

                if self.Wthread is None:
                    self.Wthread = QThread()    # Workerthread
                # Instanciate BackendWorker object
                self.worker = backend.BackendWorker(None, None)
                self.worker.runargs = [el1_main.run_auto, data, self.worker]

                # Move the worker to the QThread
                try:
                    self.worker.moveToThread(self.Wthread)
                except Exception as ex:
                    if type(ex) is RuntimeError:
                        self.Wthread = QThread()
                        if self.worker.thread() is com.thread() or self.worker.thread() is not self.Wthread:
                            self.worker.moveToThread(self.Wthread)
                    else:
                        print(ex)

                # Connct signals of worker object to this class's signals
                self.worker.progress.connect(self.handle_progress)
                self.worker.finished.connect(self.handle_backend_finished)
                self.worker.error.connect(self.handle_error)
                self.close_thread.connect(self.worker.terminate_process)

                # Start the QThread
                self.Wthread.started.connect(self.worker.start_executing)
                self.Wthread.start()

            elif self.mode == 'monte':
                data = [self.excelfilepath, self.x, self.s_thresh, self.tolerance,
                        self.distribution, self.iter_no, self.existing_model.getAllData()]
                data = pickle.dumps(data)

                # Start a process for the back end work so that main process can continue the gui loop.
                # Main backend work process

                if self.Wthread is None:
                    self.Wthread = QThread()    # Workerthread
                # Instanciate BackendWorker object
                self.worker = backend.BackendWorker(None, None)
                self.worker.runargs = [el1_main_random.run_auto, data, self.worker]

                # Move the worker to the QThread
                try:
                    self.worker.moveToThread(self.Wthread)
                except Exception as ex:
                    if type(ex) is RuntimeError:
                        self.Wthread = QThread()
                        if self.worker.thread() is com.thread() or self.worker.thread() is not self.Wthread:
                            self.worker.moveToThread(self.Wthread)
                    else:
                        print(ex)

                # Connct signals of worker object to this class's signals
                self.worker.progress.connect(self.handle_progress)
                self.worker.finished.connect(self.handle_backend_finished)
                self.worker.error.connect(self.handle_error)
                self.close_thread.connect(self.worker.terminate_process)

                # Start the QThread
                self.Wthread.started.connect(self.worker.start_executing)
                self.Wthread.start()
        if self.method == 'el3':
            if self.mode == 'simple':
                data = [self.excelfilepath, self.x, self.existing_model.getAllData()]
                data = pickle.dumps(data)

                # Start a process for the back end work so that main process can continue the gui loop.
                # Main backend work process

                if self.Wthread is None:
                    self.Wthread = QThread()    # Workerthread
                # Instanciate BackendWorker object
                self.worker = backend.BackendWorker(None, None)
                self.worker.runargs = [el3_main.run_auto, data, self.worker]

                # Move the worker to the QThread
                try:
                    self.worker.moveToThread(self.Wthread)
                except Exception as ex:
                    if type(ex) is RuntimeError:
                        self.Wthread = QThread()
                        if self.worker.thread() is com.thread() or self.worker.thread() is not self.Wthread:
                            self.worker.moveToThread(self.Wthread)
                    else:
                        print(ex)

                # Connct signals of worker object to this class's signals
                self.worker.progress.connect(self.handle_progress)
                self.worker.finished.connect(self.handle_backend_finished)
                self.worker.error.connect(self.handle_error)
                self.close_thread.connect(self.worker.terminate_process)

                # Start the QThread
                self.Wthread.started.connect(self.worker.start_executing)
                self.Wthread.start()

            elif self.mode == 'monte':
                data = [self.excelfilepath, self.x, self.tolerance,
                        self.distribution, self.iter_no, self.existing_model.getAllData()]
                data = pickle.dumps(data)

                # Start a process for the back end work so that main process can continue the gui loop.
                # Main backend work process

                if self.Wthread is None:
                    self.Wthread = QThread()    # Workerthread
                # Instanciate BackendWorker object
                self.worker = backend.BackendWorker(None, None)
                self.worker.runargs = [el3_main_random.run_auto, data, self.worker]

                # Move the worker to the QThread
                try:
                    self.worker.moveToThread(self.Wthread)
                except Exception as ex:
                    if type(ex) is RuntimeError:
                        self.Wthread = QThread()
                        if self.worker.thread() is com.thread() or self.worker.thread() is not self.Wthread:
                            self.worker.moveToThread(self.Wthread)
                    else:
                        print(ex)

                # Connct signals of worker object to this class's signals
                self.worker.progress.connect(self.handle_progress)
                self.worker.finished.connect(self.handle_backend_finished)
                self.worker.error.connect(self.handle_error)
                self.close_thread.connect(self.worker.terminate_process)

                # Start the QThread
                self.Wthread.started.connect(self.worker.start_executing)
                self.Wthread.start()

    @Slot(list)
    def handle_backend_finished(self, proc_list, err=None) -> None:
        # Handle backend work completion

        if proc_list != []:
            print(f'----------\n---\n---\n---process list not empty: {proc_list}\n---\n---\n----------')

        # Clean up the QThread and Worker
        self.Wthread.quit()
        self.Wthread.wait(7000)
        try:
            if self.Wthread.isRunning():
                print("Thread waiting timed out. Terminating...")
                self.Wthread.terminate()
                print("Thread terminated.")
        except Exception as ex:
            print(type(ex))
            print(ex)

        self.final_data = list(self.worker.shared_list)  # Get the data from the worker
        # Delete the Worker instance
        self.worker.deleteLater()
        self.Wthread.deleteLater()

        self.backend_finished.emit()
        if err is None:
            print("Backend work finished successfully")
            self.get_results_models.emit()
        else:
            print(f'Backend work finished with error: {err}')

    @Slot(float)
    def handle_progress(self, num) -> None:
        self.progress.emit(num)

    @Slot(str, list)
    def handle_error(self, err, proc_list) -> None:
        print("HENDLE ERROR")
        self.processError.emit(str(err))
        self.handle_backend_finished(proc_list, err=err)

    @Slot()
    def close_app(self):
        self.close_thread.emit()
        if isinstance(self.Wthread, QThread):
            try:
                if self.Wthread.isRunning():
                    self.worker.terminate_process()
                    self.Wthread.quit()
                    self.Wthread.wait()
            except Exception as ex:
                print(type(ex))
                print(ex)
        app.quit()


def debug_handler(msg_type, context, message) -> None:
    line_num = context.line
    log = f'- {line_num} - {message}'
    if msg_type == QtMsgType.QtDebugMsg:
        print(f'\033[34m[Debug]: {context.file} : {line_num} :\n\n{message} \n\033[0m')     # blue color
    elif msg_type == QtMsgType.QtInfoMsg:
        print(f'\033[32m[Info]: {context.file} : {line_num} :\n\n{message} \n\033[0m')      # green
    elif msg_type == QtMsgType.QtWarningMsg:
        ignore = False
        ignored = [f'Data_entry.qml:{line_num}:17: Unable to assign [undefined] to bool',
                   f'Table_customDelegate_DisplayOnly.qml:{line_num}:9: Unable to assign [undefined] to QString',
                   f'Table_customDelegate_DisplayOnly.qml:{line_num}: Error: Cannot assign [undefined] to QString',
                   f'Table_customDelegate_NEW.qml:{line_num}:9: Unable to assign [undefined] to QString',
                   f'Table_customDelegate_NEW.qml:{line_num}: Error: Cannot assign [undefined] to QString',
                   f"Results_screen.qml:{line_num}:13: QML QQuickItem*: Cannot anchor to an item that isn't a parent or sibling.",  # noqa
                   f'Table_delegate_c.qml:{line_num}:13: QML ComboBox: Binding loop detected for property "currentIndex"',  # noqa
                   'QML Connections: Implicitly defined onFoo properties in Connections are deprecated.']
        for msg in ignored:
            if msg in message:
                ignore = True
        if ignore is False:
            if 'Could not convert array value at position 0 from  to QChar' in message:
                print(f'\033[33m[Warning]: {context.file} {log} \n\033[0m')
            else:
                print(f'\033[33m[Warning]: {log} \n\033[0m')   # yellow
        else:
            pass
    elif msg_type == QtMsgType.QtCriticalMsg:
        print(f'\033[31m[Critical]: {log} \n\033[0m')  # red
    elif msg_type == QtMsgType.QtFatalMsg:
        print(f'\033[35m[Fatal]: {log} \n\033[0m')     # magenta
    elif msg_type == QtMsgType.QtSystemMsg:
        print(f'\033[36m[System]: {log} \n\033[0m')    # cyan


# Register the CustomTableModel with QML
sys.path.append('create_table_model_E.py')
qmlRegisterType(create_table_model_E.CustomTableModel, "myCustomTableModel", 1, 0, "MyCustomTableModel")

# Handler for debug messages
qInstallMessageHandler(debug_handler)


if __name__ == '__main__':
    backend.freeze_support()
    # Create a QApplication instance
    app = QGuiApplication(sys.argv)

    # Get the absolute path to the QML file
    qml_file = os.path.abspath('content/App.qml')

    # Reciever class
    com = Comm()

    # Create a QQmlApplicationEngine instance
    engine = QQmlApplicationEngine()

    # Expose the communication class to QML environment
    engine.rootContext().setContextProperty("comm", com)

    # Load the main QML file
    engine.load(QUrl.fromLocalFile(qml_file))

    qml_obj = engine.rootObjects()[0]

    # Signals and Slots connections to com instance
    rowColData_comp = qml_obj.findChild(QObject, "data_to_table")   # comp = component
    rowColData_comp.rowColData.connect(com.handle_row_col_data, type=Qt.ConnectionType.QueuedConnection)

    methodAndMode_comp = qml_obj.findChild(QObject, "confirm_connection")
    methodAndMode_comp.methodAndMode.connect(com.handle_method_and_mode, type=Qt.ConnectionType.QueuedConnection)

    loadingScreenTimer_comp = qml_obj.findChild(QObject, "loading_screen_timer")
    loadingScreenTimer_comp.start_python_process.connect(
        com.handle_start_python_process, type=Qt.ConnectionType.QueuedConnection)

    options_data_connection_comp = qml_obj.findChild(QObject, "connect_btn_to_py")
    options_data_connection_comp.options.connect(com.handle_options_data, type=Qt.ConnectionType.QueuedConnection)

    filedialog_comp = qml_obj.findChild(QObject, "fileDialog")
    filedialog_comp.filepath_to_py.connect(com.handle_filepath, type=Qt.ConnectionType.QueuedConnection)

    close_btn = qml_obj.findChild(QObject, "close_btn")
    close_btn.closeApp.connect(com.close_app, type=Qt.ConnectionType.QueuedConnection)

    results_screen_comp = qml_obj.findChild(QObject, "results_screen_root")
    results_screen_comp.sendModels.connect(com.handle_results_models, type=Qt.ConnectionType.QueuedConnection)

    model = qml_obj.findChild(QAbstractTableModel, "model")
    com.existing_model = model

    # If the rootObjects() method of the QQmlApplicationEngine
    # instance returns an empty list,
    # it means the QML file could not be loaded, so exit the
    # application with a status code of -1
    if not engine.rootObjects():
        sys.exit(-1)

    # Start the main event loop of the application by calling app.exec()
    sys.exit(app.exec())
