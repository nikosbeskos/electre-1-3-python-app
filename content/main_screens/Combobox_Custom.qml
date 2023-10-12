import QtQuick 2.15
import QtQuick.Controls.Universal 2.15

Item {
    width: 100
    height: 30
    property alias comboBox: comboBox

    ComboBox {
        id: comboBox
        anchors.fill: parent
        wheelEnabled: true
        font.pointSize: 10
        font.family: "Nunito"
        model: ["Uniform", "Normal", "Beta", "Triangular"]
        displayText: comboBox.currentText

        popup: Popup {
            y: comboBox.height - 1
            width: comboBox.width
            implicitHeight: contentItem.implicitHeight
            padding: 1
            closePolicy: Popup.CloseOnEscape
            modal: true

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }
    }
}
