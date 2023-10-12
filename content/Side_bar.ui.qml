

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.3

Item {
    id: root
    width: 65
    height: 1080
    property alias home_btn: home_btn
    property alias side_menu_btn1: side_menu_btn1
    property alias side_menu_btn: side_menu_btn

    Menu_toggle_btn {
        id: menu_toggle_btn
        width: 45
        text: "MENU"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        display: AbstractButton.IconOnly
        anchors.topMargin: 4

        Connections {
            target: menu_toggle_btn
            function onClicked() {
                if (root.state === "State1") {
                    root.state = ""
                } else {
                    root.state = "State1"
                }
            }
        }

        Label {
            id: label
            x: 85
            y: 0
            width: 70
            height: 45
            visible: false
            color: "#ffffff"
            text: menu_toggle_btn.text
            anchors.left: menu_toggle_btn.right
            anchors.top: menu_toggle_btn.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Medium"
            font.pointSize: 17
            font.family: "Nunito"
            anchors.topMargin: 0
            anchors.leftMargin: 25
        }
    }

    Home_btn {
        id: home_btn
        text: "Welcome"
        anchors.left: parent.left
        anchors.top: menu_toggle_btn.bottom
        display: AbstractButton.IconOnly
        anchors.leftMargin: 10
        anchors.topMargin: 5

        Label {
            id: label2
            x: 70
            width: 70
            height: 45
            visible: false
            color: "#ffffff"
            text: home_btn.text
            anchors.left: parent.right
            anchors.top: parent.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 25
            font.pointSize: 17
            font.family: "Nunito"
            font.styleName: "Medium"
            anchors.topMargin: 0
        }
    }

    Rectangle {
        id: bacground_color
        color: "#8c031a"
        radius: 0
        border.color: "#8c031a"
        border.width: 0
        anchors.fill: parent
        z: -1
    }

    ColumnLayout {
        id: columnLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: menu_toggle_btn.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 100

        Side_menu_btn {
            id: side_menu_btn
            width: 65
            text: "START"
            Layout.leftMargin: 2
            antialiasing: true
            display: AbstractButton.IconOnly
            Layout.maximumHeight: 55
            Layout.maximumWidth: 60
            Layout.minimumHeight: 55
            Layout.minimumWidth: 60
            Layout.preferredHeight: 55
            Layout.preferredWidth: 60
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Label {
                id: label1
                width: 70
                height: 55
                visible: false
                color: "#ffffff"
                text: side_menu_btn.text
                anchors.left: parent.right
                anchors.top: parent.top
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                font.styleName: "Medium"
                font.family: "Nunito"
                anchors.leftMargin: 25
                anchors.topMargin: 0
            }
        }

        Side_menu_btn {
            id: side_menu_btn1
            icon.source: "images/results_icon_1024.svg"
            enabled: false
            Layout.leftMargin: 2
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.maximumHeight: 55
            Layout.minimumHeight: 55
            Layout.preferredHeight: 55
            Layout.maximumWidth: 60
            Layout.minimumWidth: 60
            Layout.preferredWidth: 60

            Label {
                id: label3
                x: 81
                y: -60
                width: 70
                height: 55
                visible: false
                color: "#ffffff"
                text: side_menu_btn1.text
                anchors.left: parent.right
                anchors.top: parent.top
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 25
                font.pointSize: 10
                font.family: "Nunito"
                font.styleName: "Medium"
                anchors.topMargin: 0
            }
        }
    }

    states: [
        State {
            name: "State1"

            PropertyChanges {
                target: root
                width: 250
            }

            PropertyChanges {
                target: side_menu_btn
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: false
            }

            PropertyChanges {
                target: menu_toggle_btn
                display: AbstractButton.IconOnly
            }

            PropertyChanges {
                target: label
                visible: true
                text: menu_toggle_btn.text
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: "Nunito"
            }

            PropertyChanges {
                target: label1
                visible: true
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 15
            }

            PropertyChanges {
                target: side_menu_btn1
                text: "RESULTS"
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            }

            PropertyChanges {
                target: label2
                visible: true
            }

            PropertyChanges {
                target: label3
                visible: true
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 15
            }
        }
    ]
    transitions: [
        Transition {
            id: transition
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 50
                    }

                    PropertyAnimation {
                        target: root
                        property: "width"
                        duration: 150
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]
}

/*##^##
Designer {
    D{i:0}D{i:21;transitionDuration:2000}
}
##^##*/

