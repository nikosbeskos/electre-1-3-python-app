

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.5 as T
import Qt5Compat.GraphicalEffects

T.Button {
    id: control
    width: 65
    height: 55

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       textItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        textItem.implicitHeight + topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: ""
    property bool isChecked: false
    property alias icon_source: control.icon.source
    icon.color: "#070b10"
    icon.height: 1024
    icon.width: 1024
    display: AbstractButton.IconOnly
    icon.source: "images/START.svg"

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 5
        border.color: "#730215"
        border.width: 0

        Rectangle {
            id: rectangle
            width: 2
            color: "#00ffffff"
            radius: 1
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            z: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
        }
    }

    contentItem: textItem
    Text {
        id: textItem
        text: control.text

        opacity: enabled ? 1.0 : 0.3
        visible: false
        color: "#047eff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Image {
        id: image
        anchors.fill: parent
        source: control.icon.source
        layer.enabled: true
        layer.effect: ColorOverlay {
            id: colorOverlay
            color: image.colorOverlay
        }
        property color colorOverlay: "#b8b8b8"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 2
        fillMode: Image.PreserveAspectFit
    }

    Connections {
        target: control
        function onClicked() {
            if (control.isChecked) {
                control.isChecked = false
            } else {
                control.isChecked = true
            }
        }
    }

    Connections {
        target: control
        function onIsCheckedChanged() {
            if (control.isChecked) {
                control.state = "checked"
            }
        }
    }

    states: [
        State {
            name: "normal"
            when: control.hovered && !control.down

            PropertyChanges {
                target: buttonBackground
                color: "#d90528"
                border.color: "#730215"
                border.width: 0
            }

            PropertyChanges {
                target: textItem
                color: "#047eff"
            }

            PropertyChanges {
                target: image
                colorOverlay: "#ffffff"
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 2
            }
        },
        State {
            name: "down"
            when: control.down && control.hovered
            PropertyChanges {
                target: textItem
                color: "#ffffff"
            }

            PropertyChanges {
                target: buttonBackground
                color: "#730215"
                radius: 5
                border.color: "#222222"
                border.width: 0
            }

            PropertyChanges {
                target: control
                checkable: true
            }
        },
        State {
            name: "checked"
            when: control.isChecked
            PropertyChanges {
                target: textItem
                color: "#ffffff"
            }

            PropertyChanges {
                target: buttonBackground
                color: "#730215"
                radius: 5
                border.color: "#222222"
                border.width: 0
            }

            PropertyChanges {
                target: control
                checkable: true
            }

            PropertyChanges {
                target: rectangle
                width: 3
                color: "#b8b8b8"
            }
        }
    ]
}
