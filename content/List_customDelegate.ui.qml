

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: delegate
    width: ListView.view.width
    height: 40
    antialiasing: true

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.axis: Drag.XAxis
        preventStealing: true
        scrollGestureEnabled: false
        hoverEnabled: true
    }

    Rectangle {
        id: rectangle
        anchors.margins: 12
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        visible: true
        color: model.colorCode
        radius: 2
        border.width: 0
        anchors.fill: parent
    }

    Text {
        id: label
        color: "#343434"

        text: name
        anchors.fill: parent
        anchors.margins: 24
        verticalAlignment: Text.AlignVCenter
        font.family: "Nunito"
        font.pointSize: 16
        anchors.rightMargin: 0
        anchors.leftMargin: 5
        anchors.bottomMargin: 1
        anchors.topMargin: 1
    }

    states: [
        State {
            name: "Highlighted"

            when: mouseArea.entered && mouseArea.containsMouse
            PropertyChanges {
                target: label
                color: "#ffffff"
                anchors.topMargin: 1
            }

            PropertyChanges {
                target: rectangle
                visible: true
                color: "#8c545e"
            }

            PropertyChanges {
                target: delegate
                width: ListView.view.width
            }
        }
    ]
}
