

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
    width: 480
    height: control.width

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: ""
    hoverEnabled: true
    property bool isChecked: false
    property alias icon_source: control.icon.source
    checked: false
    icon.source: "../images/logo_1.svg"
    icon.color: "#000000"
    icon.height: 1
    icon.width: 1
    autoExclusive: true

    display: AbstractButton.IconOnly

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 5
        border.color: "#730215"
        border.width: 2
    }

    Image {
        id: image
        visible: true
        anchors.fill: parent
        source: control.icon.source
        property string overlayColor: "transparent"
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 10
        layer.enabled: true
        layer.effect: ColorOverlay {
            id: colorOverlay
            visible: true
            color: image.overlayColor
            cached: true
            enabled: true
        }
        sourceSize.height: 1024
        sourceSize.width: 1024
        fillMode: Image.PreserveAspectFit
    }

    Connections {
        target: control
        function onPressed() {
            control.state = "down"
        }
    }

    Connections {
        target: control
        function onClicked() {
            if (control.isChecked) {
                control.isChecked = !control.isChecked
            } else {
                control.isChecked = !control.isChecked
            }
        }
    }

    states: [
        State {
            name: "hovered"
            when: control.hovered && !control.isChecked

            PropertyChanges {
                target: buttonBackground
                color: "#d1d1d1"
                border.color: "#730215"
            }

            PropertyChanges {
                target: image
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                overlayColor: "#e6052b"
            }
        },
        State {
            name: "down"

            PropertyChanges {
                target: buttonBackground
                color: "#b8b8b8"
                border.color: "#730215"
            }

            PropertyChanges {
                target: image
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
            }
        },
        State {
            name: "checked"
            when: control.isChecked || (control.isChecked && control.hovered)

            PropertyChanges {
                target: buttonBackground
                color: "#b8b8b8"
                border.color: "#222222"
            }
        },
        State {
            name: "State1"
            when: !control.isChecked
        }
    ]
    transitions: [
        Transition {
            id: transition
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.color"
                        duration: 100
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 100
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: image
                        property: "anchors.leftMargin"
                        duration: 100
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: image
                        property: "anchors.bottomMargin"
                        duration: 100
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: image
                        property: "anchors.topMargin"
                        duration: 100
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 20
                    }

                    PropertyAnimation {
                        target: image
                        property: "anchors.rightMargin"
                        duration: 100
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]
}
