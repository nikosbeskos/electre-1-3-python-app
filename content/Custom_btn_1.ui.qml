

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.5 as T

T.Button {
    id: control
    width: 150
    height: 50

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       textItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        textItem.implicitHeight + topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: "New Project"
    property alias textItem: textItem
    display: AbstractButton.IconOnly

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 2
        border.color: "#000000"
        border.width: 1
        anchors.fill: parent

        Rectangle {
            id: rectangle
            width: 10
            color: "#8c031a"
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
        }
    }

    Text {
        id: textItem
        anchors.left: parent.left
        anchors.right: parent.right

        opacity: enabled ? 1.0 : 0.3
        color: "#000000"
        text: control.text
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.styleName: "Medium"
        font.family: "Nunito"
        font.pointSize: 16
        textFormat: Text.RichText
        anchors.rightMargin: 0
        anchors.leftMargin: 12
    }

    states: [
        State {
            name: "down"
            when: control.down
            PropertyChanges {
                target: textItem
                color: "#000000"
            }

            PropertyChanges {
                target: buttonBackground
                color: "#b8b8b8"
                border.color: "#000000"
            }
        },
        State {
            name: "hover"
            when: control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#d1d1d1"
            }
        }
    ]
}
