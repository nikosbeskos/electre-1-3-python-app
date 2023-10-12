

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

    text: "File"
    checkable: true
    display: AbstractButton.IconOnly
    font.family: "Nunito"
    flat: true

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 0
        border.color: "#000000"
        border.width: 0
    }

    contentItem: textItem
    Text {
        id: textItem
        text: control.text
        anchors.fill: parent

        opacity: enabled ? 1.0 : 0.3
        color: "#000000"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.styleName: "SemiBold"
        font.family: "Nunito"
    }

    states: [
        State {
            name: "State1"
            when: !control.hovered && !control.checked
        },

        State {
            name: "hovered"
            when: control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#d6d6d6"
                border.color: "#000000"
            }

            PropertyChanges {
                target: textItem
                color: "#000000"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                font.styleName: "SemiBold"
                font.family: "Nunito"
            }
        }
    ]
}
