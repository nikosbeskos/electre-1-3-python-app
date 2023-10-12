

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 140
    height: 65
    visible: true
    property alias documantation: documantation
    property alias welcome: welcome
    property alias timer: timer
    property alias mouse_area: mouse_area
    layer.enabled: true
    layer.effect: DropShadow {
        id: dropShadow
        color: "#4d4d4d"
        radius: 8
        verticalOffset: 2
        spread: 0.5
        samples: 16
        horizontalOffset: 2
    }
    enabled: true

    signal timerTriggered

    Item {
        id: spacer
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: welcome.bottom
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Rectangle {
            id: line
            height: 1
            color: "#808080"
            border.color: "#808080"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 3
            anchors.leftMargin: 3
        }
    }

    Rectangle {
        id: background
        color: "#d6d6d6"
        anchors.fill: parent
        z: -1
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        scrollGestureEnabled: false
        preventStealing: false
        enabled: true
        propagateComposedEvents: true
        hoverEnabled: true

        Connections {
            target: mouse_area

            function contains_mouse() {
                // if mouse is inside the area but cant be seen from mousArea
                if (welcome.hovered || documantation.hovered) {
                    return true
                } else {
                    return false
                }
            }

            function onExited() {
                if (contains_mouse()) {
                    console.log("MOUSE OVER BUTTON FROM POP UP")
                } else {
                    console.log("MOUSE_OUT!!! FROM POP UP")
                }
            }
        }
    }

    Context_menu_btn {
        id: welcome
        height: 25
        text: "Welcome Screen"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        shortcutText: ""
        font.pointSize: 8
        font.family: "Nunito"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 2
    }

    Context_menu_btn {
        id: documantation
        x: 8
        y: 8
        height: 25
        text: "Documentation"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: spacer.bottom
        shortcutText: ""
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0

        Connections {
            target: documantation
            function onClicked() {console.log("BUTTON____CLICKED")}
        }
    }

    Timer {
        id: timer
        interval: 1000 * 3
    }

    Connections {
        target: timer
        function onTriggered() {
            root.timerTriggered()
            console.log("TRIGERED FROM POP UP")
        }
    }
}
