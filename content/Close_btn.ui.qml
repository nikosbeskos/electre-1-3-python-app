import QtQuick 2.15
import QtQuick.Controls.Universal 2.15

Button {
    id: control
    width: 40
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
    display: AbstractButton.IconOnly
    bottomPadding: 0
    topPadding: 0
    icon.color: "#0026282a"
    flat: true

    background: buttonBackground
    Rectangle {
        id: buttonBackground
        color: "#00000000"
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        radius: 0
        border.color: "#047eff"
        border.width: 0
        anchors.fill: parent
    }

    Image {
        id: image
        x: 15
        y: 7
        width: 16
        height: 16
        anchors.verticalCenter: parent.verticalCenter
        source: "images/x.svg"
        z: -1
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: 150
        sourceSize.width: 150
        fillMode: Image.PreserveAspectFit
    }
    states: [
        State {
            name: "hovered"
            when: control.hovered && !control.pressed

            PropertyChanges {
                target: buttonBackground
                color: "#c80425"
            }

            PropertyChanges {
                target: image
                source: "images/x-white.svg"
                z: 0
                explicit: false
            }

            PropertyChanges {
                target: control
                display: AbstractButton.IconOnly
            }
        },

        State {
            name: "pressed"
            when: control.hovered && control.pressed

            PropertyChanges {
                target: image
                source: "images/x-white.svg"
            }

            PropertyChanges {
                target: buttonBackground
                color: "#8cc80425"
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
                        property: "z"
                        duration: 85
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
                        duration: 85
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
                        duration: 30
                    }

                    PropertyAnimation {
                        target: image
                        property: "z"
                        duration: 70
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 30
                    }

                    PropertyAnimation {
                        target: buttonBackground
                        property: "color"
                        duration: 70
                    }
                }
            }
            to: ""
            from: "hovered"
        }
    ]
}
