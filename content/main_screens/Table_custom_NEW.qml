import QtQuick
import QtQuick.Controls 2.15
import myCustomTableModel 1.0

Item {
    id: root
    width: 400
    height: 200
    property alias view: view

    TableView {
        id: view
        objectName: "TableView"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        reuseItems: true
        activeFocusOnTab: true
        boundsBehavior: Flickable.StopAtBounds
        focus: true
        interactive: true
        anchors.topMargin: 0
        rowSpacing: -1
        columnSpacing: -1
        clip: false

        property bool tabpressed: false
        property bool returnpressed: false
        property bool uppressed: false
        property bool downpressed: false
        property bool leftpressed: false
        property bool rightpressed: false

        rowHeightProvider: function (index) {
            return 30
        }
        columnWidthProvider: function (index) {
            return 100
        }

        selectionModel: ItemSelectionModel {
            id: itemSelectionModel
            model: view.model
        }

        model: MyCustomTableModel {
            id: model
            objectName: "model"
        }

        delegate: Table_customDelegate_NEW {
            id: viewdelegate
            width: 100
            height: 30
        }

        onModelChanged: {
            if (view.model.index(1, 1).row() === 1 && view.model.index(
                        1, 1).column() === 1) {
                console.log("MODEL WAS RESET !!!")
            }
        }
    }

    HorizontalHeaderView {
        id: horizontalheader
        x: 0
        y: 0

        width: view.width
        height: 30
        focus: false
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        clip: true

        delegate: Item {
            id: wrapper
            implicitWidth: 100
            implicitHeight: 30

            Rectangle {
                id: background
                color: "#dbdbdb"
                border.color: "#000000"
                border.width: 1
                anchors.fill: parent

                Rectangle {
                    id: rectangle
                    x: 1
                    width: 1
                    color: index === 0 ? "#222222" : "#00ffffff"
                    border.width: 0
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                }
            }

            Text {
                id: text1
                color: "#3b3b3b"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.rightMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 2
                text: display
                anchors.fill: parent
            }
        }
        syncView: view
    }

    Component.onCompleted: view.focus = true
}
