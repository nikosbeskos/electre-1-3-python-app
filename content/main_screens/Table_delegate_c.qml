import QtQuick 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Layouts 6.3

Item {
    id: root
    width: view.width
    height: 40

    property alias optType: comboBox.currentIndex

    RowLayout {
        id: rowLayout
        width: 250
        height: 40
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: text_area
            color: "#ffffff"
            border.color: "#57b9fc"
            Layout.preferredWidth: parent.width - combo_area.width
            Layout.maximumWidth: parent.width - combo_area.width
            Layout.minimumWidth: 137
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

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
                text: criteriaName
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
                    if (textInput.text !== criteriaName) {
                        criteriaName = textInput.text
                    }
                }
            }
        }

        Rectangle {
            id: combo_area
            color: "#ffffff"
            border.color: "#57b9fc"
            border.width: 1
            Layout.minimumHeight: 40
            Layout.preferredWidth: 125
            Layout.maximumWidth: 130
            Layout.minimumWidth: 120
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.leftMargin: 0
            Layout.maximumHeight: 40

            ComboBox {
                id: comboBox
                anchors.fill: parent
                font.pointSize: 12
                font.family: "Nunito"
                wheelEnabled: true
                displayText: comboBox.currentText
                model: ["Maximize", "Minimize"]
                leftInset: 1
                rightInset: 1
                bottomInset: 1
                topInset: 1

                property int loopcounter: 0

                currentIndex: {
                    if (optimizationType === "Maximize") {
                        0
                    } else if (optimizationType === "Minimize") {
                        1
                    }
                }

                onCurrentIndexChanged: {
                    if (comboBox.loopcounter < 3) {
                        if (comboBox.currentIndex === 0) {
                            optimizationType = "Maximize"
                        } else if (comboBox.currentIndex === 1) {
                            optimizationType = "Minimize"
                        }
                        comboBox.loopcounter++
                    } else if (comboBox.loopcounter >= 3) {
                        comboBox.loopcounter = 0
                    }
                }
            }
        }
    }
}
