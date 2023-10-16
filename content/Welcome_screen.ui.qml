

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.3

Item {
    id: welcome_screen
    width: 1920
    height: 1080
    property alias new_project_btn: new_project_btn

    GridLayout {
        id: gridLayout
        anchors.fill: parent
        rowSpacing: 0
        columnSpacing: 0
        rows: 1
        columns: 2

        Item {
            id: left_area
            width: parent.width / 2
            height: parent.height
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2
            Layout.minimumHeight: 650
            Layout.minimumWidth: 500
            Layout.maximumHeight: 1080
            Layout.maximumWidth: 1920
            Layout.fillHeight: false

            Item {
                id: container
                width: 500
                height: 650
                anchors.top: parent.top
                anchors.topMargin: parent.height > container.height ? (left_area.height
                                                                       - container.height) / 2 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: header_txt
                    color: "#222222"
                    text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'Segoe UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Nunito ExtraBold'; font-size:40pt; color:#222222;\">OptimizeIt</span></p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Nunito ExtraBold'; font-size:16pt; color:#222222;\">Optimize your decision-making</span></p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Nunito ExtraBold'; font-size:16pt; color:#222222;\">process with ELECTRE.</span></p></body></html>"
                    font.family: "Nunito"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: 17
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1
                    styleColor: "#222222"
                    font.hintingPreference: Font.PreferFullHinting
                    renderType: Text.QtRendering
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    textFormat: Text.RichText
                    font.styleName: "ExtraBold"
                }

                Custom_btn_1 {
                    id: new_project_btn
                    height: 50
                    text: "New Project"
                    anchors.left: parent.left
                    anchors.top: header_txt.bottom
                    enabled: false
                    anchors.leftMargin: 0
                    anchors.topMargin: 60
                    display: AbstractButton.IconOnly
                }

                Custom_btn_1 {
                    id: open_project_btn
                    width: 150
                    visible: true
                    text: "Open Project"
                    anchors.left: parent.left
                    anchors.top: new_project_btn.bottom
                    enabled: false
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Text {
                    id: recent_txt
                    y: 363
                    width: 110
                    height: 50
                    visible: true
                    color: "#333333"
                    text: "Recent"
                    anchors.left: parent.left
                    anchors.top: open_project_btn.bottom
                    font.pixelSize: 36
                    verticalAlignment: Text.AlignVCenter
                    enabled: false
                    font.styleName: "ExtraBold"
                    font.family: "Nunito"
                    anchors.leftMargin: 0
                    textFormat: Text.RichText
                    anchors.topMargin: 70
                }

                Item {
                    id: list_conatiner
                    x: 0
                    y: 750
                    width: 200
                    height: 180
                    visible: true
                    anchors.top: recent_txt.bottom
                    enabled: true
                    anchors.topMargin: 5

                    List_custom {
                        id: list_custom
                        anchors.fill: parent

                        enabled: true
                        clip: true
                        anchors.bottomMargin: 35
                        anchors.topMargin: 30
                    }
                }
            }
        }

        Item {
            id: right_area
            width: parent.width / 2
            height: parent.height
            Layout.preferredHeight: parent.height
            Layout.maximumHeight: 1080
            Layout.maximumWidth: 1920
            Layout.preferredWidth: parent.width / 2
            smooth: false

            Image {
                id: icon_img
                width: parent.width / 1.875
                height: parent.height / 2
                visible: true
                anchors.verticalCenter: parent.verticalCenter
                source: "images/window_icon.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 1024
                fillMode: Image.PreserveAspectFit
                sourceSize.height: 1024
            }
        }
    }

    states: [
        State {
            name: "low W large H"
            when: welcome_screen.width < 1000 && welcome_screen.height >= 665

            PropertyChanges {
                target: right_area
                visible: false
            }

            PropertyChanges {
                target: container
                width: 500
                height: 650
                anchors.leftMargin: (parent.width / 2) - (container.width / 2)
                anchors.topMargin: parent.height > container.height ? (left_area.height
                                                                       - container.height) / 2 : 0
            }

            PropertyChanges {
                target: icon_img
                visible: true
            }
        },
        State {
            name: "low H large W"
            when: welcome_screen.height < 665 && welcome_screen.width >= 1000
            PropertyChanges {
                target: right_area
                visible: true
            }

            PropertyChanges {
                target: left_area
                anchors.rightMargin: 0
            }

            PropertyChanges {
                target: header_txt
                visible: false
            }

            PropertyChanges {
                target: new_project_btn
                anchors.topMargin: 0 - header_txt.height
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: container
                anchors.leftMargin: (parent.width / 2) - container.width
                anchors.topMargin: parent.height > container.height ? (left_area.height
                                                                       - container.height) / 2 : 0
            }

            PropertyChanges {
                target: icon_img
                visible: true
            }
        },
        State {
            name: "low"
            when: welcome_screen.width < 1000 && welcome_screen.height < 665
            PropertyChanges {
                target: right_area
                visible: false
            }

            PropertyChanges {
                target: left_area
                anchors.rightMargin: 0
            }

            PropertyChanges {
                target: header_txt
                visible: false
            }

            PropertyChanges {
                target: new_project_btn
                anchors.topMargin: 0 - header_txt.height
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: container
                anchors.topMargin: parent.height > container.height ? (left_area.height
                                                                       - container.height) / 2 : 0
                anchors.leftMargin: (parent.width / 2) - container.width
            }

            PropertyChanges {
                target: icon_img
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
                        target: left_area
                        property: "anchors.rightMargin"
                        duration: 30
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]
}
