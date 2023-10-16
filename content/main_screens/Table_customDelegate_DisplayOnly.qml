import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 100
    height: 30

    required property bool selected
    required property bool current
    property bool showLabel: checkStatus()

    function checkStatus() {
        if (index < view.model.rowCount()) {
            return true
        } else if (index % view.model.rowCount() === 0) {
            return true
        } else {
            return false
        }
    }

    onShowLabelChanged: {
        if (root.showLabel === true) {
            text1.enabled = true
            text1.visible = true
            textInput.enabled = false
            textInput.visible = false
        } else {
            text1.enabled = false
            text1.visible = false
            textInput.enabled = true
            textInput.visible = true
        }
    }

    Rectangle {
        id: background
        color: showLabel ? "#dbdbdb" : "#ffffff"
        border.color: "#222222"
        border.width: 1

        anchors.fill: parent
        z: -1

        Rectangle {
            id: rectangle
            x: 1
            width: 1
            color: root.showLabel ? "#222222" : "#00ffffff"
            border.width: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 0
        }
    }

    Text {
        id: text1
        visible: root.showLabel
        color: "#3b3b3b"
        text: display
        elide: Text.ElideRight
        anchors.fill: parent
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z: 1
        enabled: root.showLabel
        padding: 2
        font.family: "Nunito"

        Keys.onTabPressed: {
            var row = model.row
            var column = model.column

            if (column + 1 < view.columns) {
                var idx = view.model.index(row, column + 1)

                view.tabpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onReturnPressed: {
            var row = model.row
            var column = model.column

            if (row + 1 < view.rows) {
                var idx = view.model.index(row + 1, column)

                view.returnpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onUpPressed: {
            var row = model.row
            var column = model.column

            if (row - 1 >= 0) {
                var idx = view.model.index(row - 1, column)

                view.uppressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onDownPressed: {
            var row = model.row
            var column = model.column

            if (row + 1 < view.rows) {
                var idx = view.model.index(row + 1, column)

                view.downpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onLeftPressed: {
            var row = model.row
            var column = model.column

            if (column - 1 >= 0) {
                var idx = view.model.index(row, column - 1)

                view.leftpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onRightPressed: {
            var row = model.row
            var column = model.column

            if (column + 1 < view.columns) {
                var idx = view.model.index(row, column + 1)

                view.rightpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        cursorShape: Qt.ArrowCursor
        propagateComposedEvents: true
        onClicked: {

            var row = model.row
            var column = model.column
            var idx = view.model.index(row, column)

            view.selectionModel.setCurrentIndex(
                        idx, ItemSelectionModel.SelectCurrent)

            view.tabpressed = false
            view.returnpressed = false
            view.uppressed = false
            view.downpressed = false
            view.leftpressed = false
            view.rightpressed = false

            console.log("DELEGATE: IDX:" + "(" + row + ", " + column + ")")
            console.log("SLECTED INDEX: " + "(" + view.selectionModel.currentIndex.row
                        + ", " + view.selectionModel.currentIndex.column + ")")
            console.log("SELECTED: " + root.selected + " CURRENT: " + root.current)
        }
    }

    Text {
        id: textInput
        visible: !root.showLabel
        color: "#222222"
        text: display
        elide: Text.ElideRight

        anchors.fill: parent
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        clip: true
        enabled: !root.showLabel
        padding: 2
        font.family: "Nunito"



        Component.onCompleted: {
            textInput.text = display
        }

        Keys.onTabPressed: {
            var row = model.row
            var column = model.column

            if (column + 1 < view.columns) {
                var idx = view.model.index(row, column + 1)

                view.tabpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onReturnPressed: {
            var row = model.row
            var column = model.column
            textInput.accepted()

            if (row + 1 < view.rows) {
                var idx = view.model.index(row + 1, column)

                view.returnpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onUpPressed: {
            var row = model.row
            var column = model.column

            if (row - 1 >= 0) {
                var idx = view.model.index(row - 1, column)

                view.uppressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onDownPressed: {
            var row = model.row
            var column = model.column

            if (row + 1 < view.rows) {
                var idx = view.model.index(row + 1, column)

                view.downpressed = true

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)
            }
        }

        Keys.onLeftPressed: {
            if (textInput.cursorPosition === 0) {
                var row = model.row
                var column = model.column

                if (column - 1 >= 0) {
                    var idx = view.model.index(row, column - 1)

                    view.leftpressed = true

                    view.selectionModel.setCurrentIndex(
                                idx, ItemSelectionModel.SelectCurrent)
                }
            } else {
                textInput.focus = true
                textInput.cursorPosition -= 1
            }
        }

        Keys.onRightPressed: {
            if (textInput.cursorPosition === textInput.length) {
                var row = model.row
                var column = model.column

                if (column + 1 < view.columns) {
                    var idx = view.model.index(row, column + 1)

                    view.rightpressed = true

                    view.selectionModel.setCurrentIndex(
                                idx, ItemSelectionModel.SelectCurrent)
                }
            } else {
                textInput.focus = true
                textInput.cursorPosition += 1
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: true
            cursorShape: Qt.ArrowCursor
            propagateComposedEvents: true

            onClicked: {
                var row = model.row
                var column = model.column
                var idx = view.model.index(row, column)
                var data = view.model.data(idx, "display")

                view.selectionModel.setCurrentIndex(
                            idx, ItemSelectionModel.SelectCurrent)

                console.log("DELEGATE: IDX:" + "(" + row + ", " + column + ")")

                console.log("SLECTED INDEX: " + "(" + view.selectionModel.currentIndex.row
                            + ", " + view.selectionModel.currentIndex.column + ")")
                console.log("SELECTED: " + root.selected + " CURRENT: " + root.current)

                console.log("DATA: " + data)

                view.tabpressed = false
                view.returnpressed = false
                view.uppressed = false
                view.downpressed = false
                view.leftpressed = false
                view.rightpressed = false
                textInput.focus = true
            }

            onDoubleClicked: {
                textInput.focus = true
                view.tabpressed = false
                view.returnpressed = false
                view.uppressed = false
                view.downpressed = false
                view.leftpressed = false
                view.rightpressed = false
            }
        }
    }

    onCurrentChanged: {
        view.positionViewAtCell(model.column, model.row, TableView.Contain)

        if (view.tabpressed || view.returnpressed || view.uppressed
                || view.downpressed || view.leftpressed || view.rightpressed) {
            if (textInput.enabled && textInput.visible) {
                if (root.selected && root.current) {
                    root.state = "selected"
                } else {
                    root.state = "unselected"
                }
                view.forceLayout()
                textInput.forceActiveFocus()
                textInput.focus = true

            } else if (text1.enabled && text1.visible) {
                if (root.selected && root.current) {
                    root.state = "selected"
                } else {
                    root.state = "unselected"
                }
                view.forceLayout()
                text1.forceActiveFocus()
                text1.focus = true
            }
        }

        console.log("textInput.data: " + textInput.data)
        console.log("view.model.index(): " + view.model.index(model.row,
                                                              model.column))
        console.log("textInput.displayText: " + textInput.displayText)
        console.log("DATA: " + view.model.data(view.model.index(model.row,
                                                                model.column),
                                               "display"))
    }

    states: [
        State {
            name: "selected"
            when: root.selected && root.current

            PropertyChanges {
                target: background
                border.color: "#c80425"
                border.width: 3
            }
            PropertyChanges {
                target: rectangle
                color: "#00000000"
            }
        },
        State {
            name: "unselected"
            when: !root.selected && !root.current
        }
    ]
    transitions: [
        Transition {
            id: transition
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 0
                    }

                    PropertyAnimation {
                        target: background
                        property: "border.width"
                        duration: 100
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 0
                    }

                    PropertyAnimation {
                        target: background
                        property: "border.color"
                        duration: 100
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]
}
