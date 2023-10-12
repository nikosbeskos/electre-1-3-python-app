import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.3

Item {
    id: root
    width: view.width
    height: 40

    property alias altName: textInput.text
    property alias _id: text1.text

    RowLayout {
        id: rowLayout
        width: 250
        height: 40
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: combo_area
            color: "#ffffff"
            border.color: "#57b9fc"
            border.width: 1
            Layout.minimumHeight: 40
            Layout.preferredWidth: 45
            Layout.maximumWidth: 50
            Layout.minimumWidth: 40
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.leftMargin: 0
            Layout.maximumHeight: 40

            Text {
                id: text1
                text: id_m.toString()
                anchors.fill: parent
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Nunito"
            }
        }
        Rectangle {
            id: text_area
            color: "#ffffff"
            border.color: "#57b9fc"
            Layout.preferredWidth: parent.width - combo_area.width
            Layout.maximumWidth: parent.width - combo_area.width
            Layout.minimumWidth: 137
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            Layout.alignment: Qt.AlignRight | Qt.AlignTop

            MouseArea {
                id: mouseArea
                x: 2
                y: 2
                anchors.fill: parent
                propagateComposedEvents: true
                cursorShape: Qt.IBeamCursor
                scrollGestureEnabled: false
                anchors.topMargin: 2
                anchors.bottomMargin: 2
                anchors.leftMargin: 2
                anchors.rightMargin: 2
            }

            TextInput {
                id: textInput
                color: "#000000"
                text: alternativeName
                anchors.fill: parent
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
                selectionColor: "#57b9fc"
                selectByMouse: true
                maximumLength: 100
                rightPadding: 3
                bottomPadding: 2
                topPadding: 2
                leftPadding: 3
                font.styleName: "Regular"
                font.family: "Nunito"

                onTextChanged: {
                    if (textInput.text !== alternativeName) {
                        alternativeName = textInput.text
                    }
                }
            }
        }
    }
}
