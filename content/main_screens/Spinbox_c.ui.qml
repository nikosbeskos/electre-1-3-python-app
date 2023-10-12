

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls.Universal 2.15
import Qt5Compat.GraphicalEffects

SpinBox {
    id: control
    width: 150
    height: 80
    focusPolicy: Qt.ClickFocus
    font.styleName: "SemiBold"
    font.family: "Nunito"
    rightPadding: 6
    wheelEnabled: true
    value: 3
    editable: true

    contentItem: TextInput {
        id: textInput
        z: 2
        text: control.value

        font: control.font
        color: "#222222"
        selectionColor: "#57b9fc"
        selectedTextColor: "#222222"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        overwriteMode: false
        maximumLength: 5
        selectByMouse: true

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Rectangle {
        id: upIndicator
        x: control.mirrored ? parent.width - width + 1 : 0 + 1
        y: 1
        width: height
        height: (parent.height / 2) - 1
        visible: false
        color: "#00000000"
        radius: 0
        implicitWidth: 40
        implicitHeight: 40
        border.color: "#222222"
        border.width: 0
        z: 3

        Image {
            id: image
            anchors.fill: parent
            source: "../images/chevron_up_1024.svg"
            anchors.topMargin: parent.width / 6
            property color overlayColor: "#00ffffff"
            antialiasing: false
            sourceSize.height: 200
            sourceSize.width: 200
            anchors.rightMargin: parent.width / 6
            anchors.leftMargin: parent.width / 6
            anchors.bottomMargin: parent.width / 6
            layer.enabled: true
            layer.effect: ColorOverlay {
                id: colorOverlay
                visible: true
                color: image.overlayColor
                enabled: true
                cached: true
            }
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text1
            text: "+"
            font.pixelSize: control.font.pixelSize * 2
            color: "#000000"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        id: downIndicator
        x: control.mirrored ? parent.width - width + 1 : 0 + 1
        y: (parent.height / 2)
        width: height
        height: (parent.height / 2) - 1
        visible: false
        color: "#00000000"
        implicitWidth: 40
        implicitHeight: 40
        border.color: "#222222"
        border.width: 0
        z: 3

        Image {
            id: image1
            anchors.fill: parent
            source: "../images/chevron_down_1024.svg"
            property color overlayColor: "#00ffffff"
            anchors.rightMargin: parent.height / 6
            anchors.leftMargin: parent.width / 6
            anchors.bottomMargin: parent.height / 6
            anchors.topMargin: parent.width / 6
            layer.enabled: true
            layer.effect: ColorOverlay {
                id: colorOverlay1
                visible: true
                color: image1.overlayColor
                enabled: true
                cached: true
            }
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text2
            text: "-"
            font.pixelSize: control.font.pixelSize * 2
            color: "#000000"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: backgroundRect

    Rectangle {
        id: backgroundRect
        color: "#00000000"
        implicitWidth: 140
        border.color: "#222222"
        z: -1
    }

    ToolSeparator {
        id: toolSeparator
        visible: false
        anchors.left: upIndicator.right
        anchors.right: textInput.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        bottomPadding: 3
        topPadding: 3
        rightPadding: 1
        leftPadding: 2
        anchors.bottomMargin: 1
        anchors.topMargin: 1
        anchors.rightMargin: 3
        anchors.leftMargin: 3
    }

    states: [
        State {
            name: "normal"
            when: !control.down.pressed && !control.up.pressed
                  && control.enabled && !control.hovered

            PropertyChanges {
                target: upIndicator
                visible: false
                border.color: "#222222"
            }

            PropertyChanges {
                target: downIndicator
                visible: false
                border.color: "#047eff"
            }

            PropertyChanges {
                target: backgroundRect
                border.color: "#222222"
            }

            PropertyChanges {
                target: textInput
                color: "#222222"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.styleName: "SemiBold"
                selectionColor: "#ffffff"
            }

            PropertyChanges {
                target: text1
                color: "#047eff"
            }

            PropertyChanges {
                target: text2
                color: "#047eff"
            }
        },
        State {
            name: "hovered"
            when: control.hovered && !control.up.pressed
                  && !control.down.pressed
            PropertyChanges {
                target: upIndicator
                visible: true
                border.color: "#222222"
            }

            PropertyChanges {
                target: downIndicator
                visible: true
                border.color: "#047eff"
            }

            PropertyChanges {
                target: backgroundRect
                color: "#dbdbdb"
                border.color: "#222222"
            }

            PropertyChanges {
                target: textInput
                color: "#222222"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.styleName: "SemiBold"
                selectionColor: "#ffffff"
            }

            PropertyChanges {
                target: text1
                visible: false
                color: "#047eff"
            }

            PropertyChanges {
                target: text2
                visible: false
                color: "#047eff"
            }

            PropertyChanges {
                target: image
                visible: true
            }

            PropertyChanges {
                target: image1
                visible: true
            }

            PropertyChanges {
                target: toolSeparator
                visible: true
            }
        },

        State {
            name: "upPressed"
            when: control.up.pressed && control.up.hovered

            PropertyChanges {
                target: text1
                visible: false
                color: "#ffffff"
            }

            PropertyChanges {
                target: upIndicator
                x: control.mirrored ? parent.width - width + 1 : 0 + 1
                y: 1
                height: (parent.height / 2) - 1
                visible: true
                color: "#e6052b"
                radius: 0
                border.color: "#e6052b"
            }

            PropertyChanges {
                target: textInput
                color: "#222222"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                selectionColor: "#ffffff"
            }

            PropertyChanges {
                target: downIndicator
                x: control.mirrored ? parent.width - width + 1 : 0 + 1
                visible: true
                border.color: "#047eff"
            }

            PropertyChanges {
                target: text2
                color: "#047eff"
            }

            PropertyChanges {
                target: backgroundRect
                color: "#dbdbdb"
                border.color: "#222222"
            }

            PropertyChanges {
                target: image1
                visible: true
            }

            PropertyChanges {
                target: image
                visible: true
                overlayColor: "#ffffff"
            }

            PropertyChanges {
                target: toolSeparator
                visible: true
            }
        },
        State {
            name: "downPressed"
            when: control.down.pressed

            PropertyChanges {
                target: text2
                color: "#ffffff"
            }

            PropertyChanges {
                target: downIndicator
                visible: true
                color: "#e6052b"
                border.color: "#047eff"
            }

            PropertyChanges {
                target: textInput
                color: "#222222"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                selectionColor: "#ffffff"
            }

            PropertyChanges {
                target: upIndicator
                visible: true
                border.color: "#047eff"
            }

            PropertyChanges {
                target: text1
                color: "#047eff"
            }

            PropertyChanges {
                target: backgroundRect
                color: "#dbdbdb"
                border.color: "#222222"
            }

            PropertyChanges {
                target: image1
                visible: true
                overlayColor: "#ffffff"
            }

            PropertyChanges {
                target: image
                visible: true
            }

            PropertyChanges {
                target: toolSeparator
                visible: true
            }
        },
        State {
            name: "disabled"
            when: !control.enabled

            PropertyChanges {
                target: downIndicator
                border.color: "#b3047eff"
            }

            PropertyChanges {
                target: upIndicator
                border.color: "#b3047eff"
            }

            PropertyChanges {
                target: textInput
                color: "#b3222222"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            PropertyChanges {
                target: text1
                color: "#b3047eff"
            }

            PropertyChanges {
                target: text2
                color: "#b3047eff"
            }

            PropertyChanges {
                target: backgroundRect
                border.color: "#b3222222"
            }
        }
    ]
    to: 50
    from: 3
}
