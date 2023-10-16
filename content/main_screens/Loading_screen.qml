import QtQuick 2.15
import QtQuick.Controls.Universal 2.15

Item {
    id: item1
    width: 1920
    height: 1080
    property alias error_text: error_text
    property alias progressBar: progressBar
    property alias busyIndicator: busyIndicator
    property alias label: label
    property alias timer: timer
    objectName: "loading_screen_timer"

    signal start_python_process
    property int count: 0

    Rectangle {
        id: background
        color: "#eaeaea"
        anchors.fill: parent
        z: -1
    }

    BusyIndicator {
        id: busyIndicator
        width: 40
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label
        width: 200
        height: 40
        color: "#222222"
        text: "Waiting for the results"
        anchors.top: busyIndicator.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 13
        font.family: "Nunito"
        anchors.topMargin: 40
        anchors.horizontalCenter: busyIndicator.horizontalCenter
    }

    Timer {
        id: timer

        onTriggered: {
            if (item1.count === 0) {
                item1.start_python_process()
                item1.state = "progress"
            }
        }
    }

    Text {
        id: error_text
        width: 600
        height: 200
        visible: false
        text: ""
        anchors.top: label.top
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        wrapMode: Text.WordWrap
        font.family: "Nunito"
        anchors.topMargin: 0
        anchors.horizontalCenter: label.horizontalCenter
    }

    ProgressBar {
        id: progressBar
        width: parent.width * 0.5
        height: 20
        opacity: 0
        visible: false
        anchors.top: label.bottom
        to: 100
        from: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
        value: 0

        PropertyAnimation {
            id: animation
            target: progressBar
            property: "anchors.topMargin"
            to: 175
            duration: 250
        }
    }

    Text {
        id: percentage
        width: 15
        height: 20
        opacity: 0
        visible: false
        color: "#222222"
        text: "0"
        anchors.verticalCenter: progressBar.verticalCenter
        anchors.left: progressBar.right
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        styleColor: "#222222"
        font.family: "Nunito"
        anchors.leftMargin: 15
    }

    Text {
        id: percentSymbol
        x: 1406
        y: 800
        width: 15
        height: 20
        opacity: 0
        visible: percentage.visible
        color: "#222222"
        text: "%"
        font.pixelSize: 15
        verticalAlignment: Text.AlignTop
        anchors.leftMargin: margNum
        font.family: "Nunito"
        anchors.verticalCenter: percentage.verticalCenter
        anchors.left: percentage.right
        property double margNum: 0
        property int diffcount: 0

        Timer {
            id: percent_timer
            repeat: true
            running: true
            interval: 150

            onTriggered: {
                var diff
                var oldmarg = percentSymbol.margNum
                var newmarg = (percentage.text.length * (percentage.font.pixelSize / 4))
                diff = oldmarg - newmarg
                if (diff !== 7.5) {
                    percentSymbol.margNum = newmarg
                    percentSymbol.diffcount = 0

                } else {
                    percentSymbol.diffcount += 1
                    if (percentSymbol.diffcount > 10) {
                        percentSymbol.margNum = newmarg
                        percentSymbol.diffcount = 0
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "progress"

            PropertyChanges {
                target: progressBar
                opacity: 1
                visible: true
            }

            PropertyChanges {
                target: percentage
                opacity: 1
                visible: true
                text: "0"
            }

            PropertyChanges {
                target: percentSymbol
                opacity: 1
                visible: true
            }
        }
    ]
    transitions: [
        Transition {
            id: transition
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 0
                    }

                    PropertyAnimation {
                        target: percentage
                        property: "opacity"
                        duration: 180
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 0
                    }

                    PropertyAnimation {
                        target: percentSymbol
                        property: "opacity"
                        duration: 180
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 0
                    }

                    PropertyAnimation {
                        target: progressBar
                        property: "opacity"
                        duration: 180
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]

    Connections {
        id: communication_to_py
        target: comm

        onProcessError: function (err) {
            label.visible = false
            error_text.text = err
            animation.restart()
            error_text.visible = true
            console.info("\n\n\n[comm to py from qml] Error: " + err)
            busyIndicator.running = false
            item1.count = 0
        }

        onProgress: function (num) {
            progressBar.value = num
            percentage.text = num.toString()
        }
    }
}



