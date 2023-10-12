

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
    width: 45
    height: 45

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        topPadding + bottomPadding)
    leftPadding: 4
    rightPadding: 4

    text: "MENU"
    hoverEnabled: true
    property bool isChecked: false
    checkable: true
    flat: true
    display: AbstractButton.IconOnly

    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 2
        border.color: "#047eff"
        border.width: 0
        anchors.bottom: parent.bottom
        anchors.fill: parent
        z: 0
    }

    Image {
        id: image
        width: 32
        height: 32
        anchors.verticalCenter: parent.verticalCenter
        source: "images/menu.svg"
        layer.enabled: true
        layer.effect: ColorOverlay {
            id: colorOverlay
            color: image.overlayColor
        }
        property string overlayColor: "#b1b1b1"
        layer.format: ShaderEffectSource.Alpha
        layer.samples: 0
        sourceSize.height: 200
        sourceSize.width: 200
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Connections {
        target: control
        function onPressed() {
            control.state = "down"
        }
    }

    states: [
        State {
            name: "hovered"
            when: control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#640212"
                radius: 4
                border.color: "#181818"
                border.width: 0
            }

            PropertyChanges {
                target: image
                overlayColor: "white"
            }
        },
        State {
            name: "down"
            when: control.down

            PropertyChanges {
                target: buttonBackground
                color: "#cd0426"
                radius: 4
                border.color: "#00000000"
                border.width: 0
                z: -1
            }

            PropertyChanges {
                target: control
                checked: false
                antialiasing: true
            }

            PropertyChanges {
                target: image
                visible: true
            }
        }
    ]
    transitions: [
        Transition {
            id: base_hovered
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 11
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 49
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 11
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.color"
                        duration: 49
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 11
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.width"
                        duration: 49
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 11
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "radius"
                        duration: 49
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 11
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "z"
                        duration: 49
                    }
                }
            }
            to: "*"
            from: "hovered"
        },
        Transition {
            id: hovered_base
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 55
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.color"
                        duration: 55
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.width"
                        duration: 55
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "radius"
                        duration: 55
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "z"
                        duration: 55
                    }
                }
            }
            to: ""
            from: "*"
        }
    ]
}

/*##^##
Designer {
    D{i:0}D{i:12;transitionDuration:2000}D{i:29;transitionDuration:2000}
}
##^##*/

