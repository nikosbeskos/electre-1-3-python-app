
from copy import deepcopy
from typing import Any, Union

from PySide6.QtCore import (QAbstractTableModel, QModelIndex,
                            QPersistentModelIndex, Qt, Signal)


class CustomTableModel(QAbstractTableModel):

    dataChanged = Signal(QModelIndex, QModelIndex, list)

    def __init__(self, data=[[None]], headers=[[None]], parent=None) -> None:
        super(CustomTableModel, self).__init__(parent)
        self._data = deepcopy(data)
        self._headers = deepcopy(headers)

    def rowCount(self, parent=None) -> int:
        # Return the number of rows in the table
        return len(self._data)

    def columnCount(self, parent=None) -> int:
        # Return the number of columns in the table
        return len(self._data[0])

    def data(self, index: Union[QModelIndex, QPersistentModelIndex], role=Qt.DisplayRole) -> Any:
        # Return the data for a specific index and role
        if not index.isValid():
            return None

        row = index.row()
        col = index.column()

        if role == Qt.DisplayRole:
            # Return the display data for the cell
            return self._data[row][col]

    def headerData(self, section, orientation: Qt.Orientation, role=Qt.DisplayRole) -> Any:
        # Return the header data for a specific section and role
        if role == Qt.DisplayRole:
            if orientation == Qt.Horizontal:
                # Return the horizontal header data
                return self._headers[section]
            elif orientation == Qt.Vertical:
                # Return the vertical header data
                return str(section + 1)

    # ... editable model methods ...
    def setData(self, index: Union[QModelIndex, QPersistentModelIndex], value: Any, role: int = Qt.EditRole) -> bool:  # noqa
        if role == Qt.EditRole:
            row = index.row()
            column = index.column()
            if 0 <= row < self.rowCount() and 0 <= column < self.columnCount():
                # Update the data in the internal data structure
                self._data[row][column] = value
                # Emit dataChanged signal to notify the view
                self.dataChanged.emit(index, index, [role])
                return True
        return False

    def flags(self, index: Union[QModelIndex, QPersistentModelIndex]) -> Qt.ItemFlag:
        default_flags = super().flags(index)
        if index.isValid():
            # Set the item flags to be editable
            return default_flags | Qt.ItemIsEditable
        return default_flags

    # ... other methods ...

    def insertRows(self, row, count, parent=QModelIndex()) -> bool:
        self.beginInsertRows(parent, row, row + count - 1)
        for _ in range(count):
            empty_row = [''] * self.columnCount()
            self._data.insert(row, empty_row)
        self.endInsertRows()
        return True

    def insertColumns(self, column, count, parent=QModelIndex()) -> bool:
        self.beginInsertColumns(parent, column, column + count - 1)
        for _ in range(count):
            for row in self._data:
                row.insert(column, '')
            self._headers.insert(column, '')
        self.endInsertColumns()
        return True

    def removeRows(self, row, count, parent=QModelIndex()) -> bool:
        self.beginRemoveRows(parent, row, row + count - 1)
        for _ in range(count):
            self._data.pop(row)
        self.endRemoveRows()
        return True

    def removeColumns(self, column, count, parent=QModelIndex()) -> bool:
        self.beginRemoveColumns(parent, column, column + count - 1)
        for row in self._data:
            for _ in range(count):
                row.pop(column)
            self._headers.pop(column)
        self.endRemoveColumns()
        return True

    def getAllData(self) -> list:
        """
        Return all data in the model.
        """
        return self._data

    def resetData(self) -> bool:
        '''
        Resets the data and the headers of the model.
        '''
        self.beginResetModel()
        self.removeRows(0, self.rowCount())
        self._data = [[None]]
        self._headers = [[None]]
        self.endResetModel()

        self.dataChanged.emit(
            self.index(0, 0),    # top-left index of the updated data
            self.index(self.rowCount()-1, self.columnCount()-1),    # bottom-right index of the updated data
            Qt.DisplayRole
        )
        return True

    def isEmpty(self) -> bool:
        '''
        Check if model is empty
        '''
        rows = self.rowCount()
        cols = self.columnCount()
        if rows == 1 and cols == 1:
            if self._data == [[None]]:
                return True

        return False


def update_model(rowsn: list, colsn: list, celldata: list, model: CustomTableModel, isEl3: bool = True) -> bool:

    rownames = ['names']
    colnames = ['names']

    for col in colsn:
        colnames.append(col)
    for row in rowsn:
        rownames.append(row)

    rownames.append('Optimization Type')
    rownames.append('Weights')
    if isEl3:
        rownames.append('Indifference(q)')
        rownames.append('Preference(p)')

    rownames.append('Veto')

    data = []
    temp = []

    for rid, row in enumerate(rownames):
        for id, col in enumerate(colnames):
            if rid == 0:
                temp.append(col)
            else:
                if id == 0:
                    temp.append(row)
                else:
                    temp.append('')
        data.append(deepcopy(temp))
        temp.clear()

    if model.isEmpty():
        model.insertColumns(0, len(colnames)-1)
        model.insertRows(0, len(rownames)-1)
        model._data[model.rowCount()-1][model.columnCount()-1] = ""
    else:
        model.resetData()
        model.insertColumns(0, len(colnames)-1)
        model.insertRows(0, len(rownames)-1)
        model._data[model.rowCount()-1][model.columnCount()-1] = ""

    for idx, item in enumerate(rownames):
        index = model.index(idx, 0)
        model.setData(index, str(item))

    for idx, item in enumerate(colnames):
        index = model.index(0, idx)
        model.setData(index, str(item))
        model._headers[idx] = item

    optType = celldata[0]
    decmatrix = celldata[1]

    if len(optType) > 1:
        optidx = rownames.index('Optimization Type')

        for idx, item in enumerate(optType):
            index = model.index(optidx, idx + 1)
            model.setData(index, str(item))

    if decmatrix is not None:
        for idx, row in enumerate(decmatrix):
            for idx2, val in enumerate(row):
                index = model.index(idx + 1, idx2 + 1)
                model.setData(index, str(val))

    if isinstance(model, QAbstractTableModel):
        return True
    else:
        return False


def update_results_model(model: CustomTableModel, data: list, modeltype: str, basemodel: CustomTableModel,
                         rowsn: list = None, colsn: list = None, celldata: list = None,
                         isEl3: bool = True, s_thresh=None) -> bool:

    rownames = ['names']
    colnames = ['names']

    if isEl3 is False:

        if modeltype == 'superiority':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-3]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = deepcopy(colsn)
            rowsn.append('s')

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        elif id == 1:
                            if row == 's':
                                temp.append(s_thresh)
                            else:
                                temp.append('')
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            model.setData(model.index(model.rowCount()-1, 1), str(s_thresh))

            celldata = data[2][2]

            for idx, row in enumerate(celldata):
                for idx2, val in enumerate(row):
                    index = model.index(idx + 1, idx2 + 1)
                    model.setData(index, str(val))

        if modeltype == 'ranking':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-3]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = ['Ranking', 'Φnet']

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            rank = data[2][0]
            phi_net = data[2][1]

            rnkindex = rownames.index('Ranking')
            for idx, item in enumerate(rank):
                index = model.index(rnkindex, idx + 1)
                model.setData(index, str(item))

            phindex = rownames.index('Φnet')
            for idx, item in enumerate(phi_net):
                index = model.index(phindex, idx + 1)
                model.setData(index, str(item))

        if modeltype == 'expected':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-3]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = ['Expected Rank']

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            expected = data[2]

            expindex = rownames.index('Expected Rank')
            for idx, item in enumerate(expected):
                index = model.index(expindex, idx + 1)
                model.setData(index, str(item))

        if modeltype == 'acceptability':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-3]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = deepcopy(colsn)

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            acceptability = data[3]

            for idx, row in enumerate(acceptability):
                for idx2, val in enumerate(row):
                    index = model.index(idx + 1, idx2 + 1)
                    model.setData(index, str(val))
    if isEl3 is True:
        if modeltype == 'creddeg':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-5]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = deepcopy(colsn)

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            creddeg = data[2][6]

            for idx, row in enumerate(creddeg):
                for idx2, val in enumerate(row):
                    index = model.index(idx + 1, idx2 + 1)
                    model.setData(index, format(val, ".3f"))
        if modeltype == 'ranking':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-5]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = ['Final Ranking', 'Descending Ranking', 'Ascending Ranking']

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            final = data[2][0]

            finindex = rownames.index('Final Ranking')
            for idx, item in enumerate(final):
                index = model.index(finindex, idx + 1)
                model.setData(index, str(item))

            desc = data[2][1]

            descindex = rownames.index('Descending Ranking')
            for idx, item in enumerate(desc):
                index = model.index(descindex, idx + 1)
                model.setData(index, str(item))

            asc = data[2][2]

            ascindex = rownames.index('Ascending Ranking')
            for idx, item in enumerate(asc):
                index = model.index(ascindex, idx + 1)
                model.setData(index, str(item))
        if modeltype == 'expected':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-5]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = ['Expected Rank']

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            expected = data[2]

            expindex = rownames.index('Expected Rank')
            for idx, item in enumerate(expected):
                index = model.index(expindex, idx + 1)
                model.setData(index, str(item))
        if modeltype == 'acceptability':
            basedata = basemodel.getAllData()

            colsn = basedata[1:-5]
            for idx, row in enumerate(colsn):
                colsn[idx] = row[0]

            rowsn = deepcopy(colsn)

            for col in colsn:
                colnames.append(col)
            for row in rowsn:
                rownames.append(row)

            celldata = []
            temp = []

            for rid, row in enumerate(rownames):
                for id, col in enumerate(colnames):
                    if rid == 0:
                        temp.append(col)
                    else:
                        if id == 0:
                            temp.append(row)
                        else:
                            temp.append('')
                celldata.append(deepcopy(temp))
                temp.clear()

            if model.isEmpty():
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""
            else:
                model.resetData()
                model.insertColumns(0, len(colnames)-1)
                model.insertRows(0, len(rownames)-1)
                model._data[model.rowCount()-1][model.columnCount()-1] = ""

            for idx, item in enumerate(rownames):
                index = model.index(idx, 0)
                model.setData(index, str(item))

            for idx, item in enumerate(colnames):
                index = model.index(0, idx)
                model.setData(index, str(item))
                model._headers[idx] = item

            acceptability = data[3]

            for idx, row in enumerate(acceptability):
                for idx2, val in enumerate(row):
                    index = model.index(idx + 1, idx2 + 1)
                    model.setData(index, str(val))
