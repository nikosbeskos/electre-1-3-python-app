

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 260
    height: 190
    visible: true
    property alias timer: timer
    property alias exit: exit
    property alias export_results: export_results
    property alias save_project: save_project
    property alias close_project: close_project
    property alias open_project: open_project
    property alias new_project: new_project
    property alias mouse_area: mouse_area
    layer.enabled: true
    layer.effect: DropShadow {
        id: dropShadow
        color: "#4d4d4d"
        radius: 8
        baselineOffset: 0
        transparentBorder: true
        samples: 16
        verticalOffset: 2
        spread: 0.5
        horizontalOffset: 2
        cached: false
    }
    enabled: true

    signal timerTriggered

    Item {
        id: spacer3
        x: 13
        y: 13
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: export_results.bottom
        Rectangle {
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
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    Item {
        id: spacer2
        x: -3
        y: -3
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: save_project.bottom
        Rectangle {
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
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    Item {
        id: spacer1
        x: 5
        y: 5
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: close_project.bottom
        Rectangle {
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
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    Item {
        id: spacer
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: open_project.bottom
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
                if (new_project.hovered || open_project.hovered
                        || close_project.hovered || save_project.hovered
                        || save_project.hovered || export_results.hovered
                        || exit.hovered) {
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
        id: new_project
        height: 25
        text: "New Project"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        shortcutText: "Ctrl+N"
        font.pointSize: 8
        font.family: "Nunito"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 2
    }

    Context_menu_btn {
        id: open_project
        x: 8
        y: 8
        height: 25
        text: "Open Project"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: new_project.bottom
        shortcutText: "Ctrl+O"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0

        Connections {
            target: open_project
            function onClicked() {console.log("BUTTON____CLICKED")}
        }
    }

    Context_menu_btn {
        id: close_project
        x: 0
        y: 0
        height: 25
        text: "Close Project \"projectName\""
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: spacer.bottom
        shortcutText: ""
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0
    }

    Context_menu_btn {
        id: save_project
        x: 7
        y: 7
        height: 25
        text: "Save \"projectName\""
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: spacer1.bottom
        shortcutText: "Ctrl+S"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0
    }

    Context_menu_btn {
        id: export_results
        x: 16
        y: 16
        height: 25
        text: "Export Results"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: spacer2.bottom
        shortcutText: "Ctrl+E"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0
    }

    Context_menu_btn {
        id: exit
        x: 12
        y: 12
        height: 25
        text: "Exit"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: spacer3.bottom
        shortcutText: "Ctrl+Q"
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.topMargin: 0
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
