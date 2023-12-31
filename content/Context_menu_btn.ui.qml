

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       textItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        textItem.implicitHeight + topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: "My Button"
    property string shortcutText: "Shortcut"

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 2
        border.color: "#047eff"
        border.width: 0
    }

    contentItem: textItem
    Text {
        id: textItem
        width: 124
        height: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        opacity: enabled ? 1.0 : 0.3
        color: "#333333"
        text: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        styleColor: "#333333"
        anchors.leftMargin: 6
        font.styleName: "Medium"
        font.pointSize: 10
        font.family: "Nunito"
    }

    Text {
        id: shortcut_txt
        x: 4
        y: 4
        width: 70
        height: 15
        opacity: enabled ? 1.0 : 0.3
        color: "#333333"
        text: control.shortcutText
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 0
        font.styleName: "Medium"
        font.pointSize: 10
        font.family: "Nunito"
    }

    states: [
        State {
            name: "hovered"
            when: control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#d7d90428"
                radius: 2
                border.color: "#730215"
                border.width: 1
            }

            PropertyChanges {
                target: textItem
                color: "#ffffff"
            }

            PropertyChanges {
                target: shortcut_txt
                color: "#ffffff"
            }
        }
    ]
}
