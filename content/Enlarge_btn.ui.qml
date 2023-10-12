

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls.Universal 2.15

Button {
    id: control
    width: 30
    height: 30

    implicitWidth: Math.max(
                       buttonBackground ? buttonBackground.implicitWidth : 0,
                       leftPadding + rightPadding)
    implicitHeight: Math.max(
                        buttonBackground ? buttonBackground.implicitHeight : 0,
                        topPadding + bottomPadding)
    leftPadding: 0
    rightPadding: 0

    text: ""
    flat: true
    bottomPadding: 0
    topPadding: 0
    display: AbstractButton.IconOnly

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00ffffff"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 2
        border.color: "#047eff"
        border.width: 0

        Image {
            id: image
            width: 16
            height: 16
            anchors.verticalCenter: parent.verticalCenter
            source: "images/rectangle_512.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }
    }

    states: [
        State {
            name: "hovered"
            when: control.hovered && !control.down

            PropertyChanges {
                target: buttonBackground
                color: "#dddddd"
                radius: 1
                border.color: "#047eff"
                border.width: 0
            }

            PropertyChanges {
                target: image
                x: 0
                y: 0
                width: 20
                height: 20
            }
        },
        State {
            name: "down"
            when: control.down && control.hovered

            PropertyChanges {
                target: buttonBackground
                color: "#bababa"
                radius: 1
                border.color: "#00000000"
            }
        }
    ]
    transitions: [
        Transition {
            id: base_hovered
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "y"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "height"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "width"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "x"
                        duration: 65
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.color"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.width"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "radius"
                        duration: 65
                    }
                }
            }
            to: "hovered"
            from: ""
        },
        Transition {
            id: hovered_base
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "y"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "height"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "width"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: image
                        property: "x"
                        duration: 145
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.color"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "border.width"
                        duration: 145
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 35
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "radius"
                        duration: 145
                    }
                }
            }
            to: "hovered"
            from: "hovered"
        }
    ]
}

/*##^##
Designer {
    D{i:0}D{i:8;transitionDuration:2000}D{i:35;transitionDuration:2000}
}
##^##*/

