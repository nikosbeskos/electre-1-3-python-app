

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 600
    height: 650

    Rectangle {
        id: backgorund
        color: "#d1d1d1"
        radius: 10
        border.color: "#858585"
        border.width: 1
        anchors.fill: parent
    }

    Label {
        id: header
        height: 20
        color: "#222222"
        text: qsTr("Excel file required characteristics.")
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 16
        font.family: "Nunito"
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: border_rect
        width: parent.width * 90 / 100
        height: width / 2.237
        color: "#ffffff"
        border.color: "#6b6b6b"
        border.width: 1
        anchors.top: header.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: image
            anchors.fill: parent
            source: "../images/excel_help.png"
            sourceSize.height: 426
            sourceSize.width: 953
            anchors.rightMargin: border_rect.border.width
            anchors.leftMargin: border_rect.border.width
            anchors.bottomMargin: border_rect.border.width
            anchors.topMargin: border_rect.border.width
            fillMode: Image.PreserveAspectFit
        }
    }

    Text {
        id: text1
        width: parent.width * 95 / 100
        text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'Segoe UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Nunito'; font-size:20pt; font-weight:700; color:#222222;\">Requirements </span><span style=\" font-family:'Nunito'; font-size:16pt; font-weight:700; color:#222222;\"> </span></p>\n<ul style=\"margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; -qt-list-indent: 1;\">\n<li style=\" font-family:'Nunito'; font-size:12pt; font-weight:700; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-weight:400;\">The Excel file must be of type [filename.xlsx].</span></li></ul>\n<ul style=\"margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px; -qt-list-indent: 1;\">\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">The import process uses only the first sheet of the file to get the data.</li>\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">The formating of the import data have to be as the image above shows:</li>\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Blue Rectangle: criteria names. Additionally, the criteria have to be in a row layout as shown in the image above. This means that all criteria names have to be in a single row on the top side of the data.</li>\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Green Rectangle: alternatives names. Additionally, the alternatives have to be in a column layout exactly as shown in the image above. This means that all the alternatives names have to be in a single column, on the right side of the data.</li>\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Purple Rectangle: data entries of the &quot;Decision Matrix&quot;</li>\n<li style=\" font-family:'Nunito'; font-size:12pt; color:#222222;\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Red Rectangle: This cell has no impact on the data. However, under no circumstances can it be empty, in order for the data to be imported correctly. Leave it as it is(&quot;CritAltNames&quot;).</li></ul></body></html>"
        anchors.top: border_rect.bottom
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
