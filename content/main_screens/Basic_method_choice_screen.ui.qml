

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.3
import "../"

Item {
    id: root
    width: 1920
    height: 1080
    property alias next_btn: next_btn
    property alias e_btn1: e_btn1
    property alias e_btn: e_btn

    Rectangle {
        id: rectangle
        color: "#eaeaea"
        border.width: 0
        anchors.fill: parent
        z: -1
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent

        Item {
            id: left_area
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2
            Layout.maximumHeight: 1080
            Layout.minimumHeight: 420
            Layout.minimumWidth: left_area.width > 480 ? (480 + (left_area.x - frame.x)) : 480
            Layout.maximumWidth: 960

            Label {
                id: header
                x: 200
                y: 150
                width: 450
                height: 90
                color: "#222222"
                text: qsTr("Select an ELECTRE method\nand then press Next")
                anchors.left: parent.left
                anchors.top: parent.top
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 21 / 100
                anchors.topMargin: parent.height * 14 / 100
                styleColor: "#222222"
                renderTypeQuality: Text.DefaultRenderTypeQuality
                font.pointSize: 25
                font.styleName: "Regular"
                font.family: "Nunito"
            }

            Frame {
                id: frame
                x: 200
                y: 310
                width: 480
                height: 300
                anchors.left: header.left
                anchors.top: header.bottom
                anchors.topMargin: 100
                anchors.leftMargin: 0

                Label {
                    id: label
                    y: e_btn.y + (e_btn.height / 2) - (label.height / 2)
                    width: 115
                    height: 40
                    text: qsTr("ELECTRE I")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 15
                    anchors.horizontalCenterOffset: parent.width / -4
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.styleName: "ExtraBold"
                    font.family: "Nunito"
                }

                Label {
                    id: label1
                    y: e_btn1.y + (e_btn1.height / 2) - (label.height / 2)
                    width: 115
                    height: 40
                    text: qsTr("ELECTRE III")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 15
                    font.styleName: "ExtraBold"
                    font.family: "Nunito"
                    anchors.horizontalCenterOffset: parent.width / -4
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ColumnLayout {
                    id: columnLayout
                    x: 447
                    width: parent.width / 2
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    E_btn {
                        id: e_btn
                        width: 90
                        height: e_btn.width
                        property string description: "ELECTRE I is a decision-making method that helps you choose the best option from a limited set of alternatives based on multiple criteria. It assigns scores to each alternative based on how well it meets the criteria and applies a veto threshold. If an alternative falls below this threshold, it is automatically eliminated, regardless of its performance on other criteria.\n\nThis method is useful in situations such as choosing the best car to buy or deciding which house to rent."
                        hoverEnabled: true
                        Layout.maximumHeight: e_btn.height
                        Layout.minimumHeight: e_btn.height
                        Layout.maximumWidth: e_btn.width
                        Layout.minimumWidth: e_btn.width
                        Layout.preferredHeight: e_btn.height
                        Layout.preferredWidth: e_btn.width
                        Layout.fillWidth: false
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        Connections {
                            target: e_btn
                            function onIsCheckedChanged() {
                                if (e_btn.isChecked) {
                                    e_btn1.isChecked = false
                                }
                            }
                        }

                        Connections {
                            target: e_btn
                            function onHoveredChanged() {
                                if (e_btn.hovered || e_btn.isChecked) {
                                    text_description.text = e_btn.description
                                } else if (e_btn1.isChecked) {
                                    text_description.text = e_btn1.description
                                } else {
                                    text_description.text = ""
                                }
                            }
                        }
                    }

                    E_btn {
                        id: e_btn1
                        width: 90
                        height: 90
                        property string description: "ELECTRE III is a decision-making method that helps you choose the best option from a larger set of alternatives based on multiple criteria. It assigns scores to each alternative based on how well it meets the criteria and takes into account the importance of each criterion. Unlike ELECTRE I, ELECTRE III has multiple thresholds, which allow for a more nuanced analysis of the alternatives. These thresholds help to eliminate options that fall below a certain level of performance on specific criteria.\n\nThis method is useful in situations such as choosing the best college to attend or deciding on an investment strategy."
                        Layout.maximumWidth: e_btn1.width
                        Layout.minimumWidth: e_btn1.width
                        Layout.preferredWidth: e_btn1.width
                        Layout.maximumHeight: e_btn1.height
                        Layout.minimumHeight: e_btn1.height
                        Layout.preferredHeight: e_btn1.height
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        icon.source: "../images/logo_2.svg"

                        Connections {
                            target: e_btn1
                            function onIsCheckedChanged() {
                                if (e_btn1.isChecked) {
                                    e_btn.isChecked = false
                                }
                            }
                        }

                        Connections {
                            target: e_btn1
                            function onHoveredChanged() {
                                if (e_btn1.hovered || e_btn1.isChecked) {
                                    text_description.text = e_btn1.description
                                } else if (e_btn.isChecked) {
                                    text_description.text = e_btn.description
                                } else {
                                    text_description.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: right_area
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.minimumWidth: 485
            Layout.minimumHeight: 420
            Layout.maximumWidth: 960
            Layout.maximumHeight: 1080

            Item {
                id: dumpb_spcer_item
                width: 200
                height: 90
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: parent.height * 14 / 100
            }

            Frame {
                id: frame1
                width: 480
                height: 300
                anchors.left: parent.left
                anchors.top: dumpb_spcer_item.bottom
                anchors.leftMargin: parent.width < 480 ? 0 : ((parent.width - frame1.width) / 2)
                anchors.topMargin: 100

                Text {
                    id: text_description
                    color: "#222222"
                    anchors.fill: parent
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.WordWrap
                    font.styleName: "Regular"
                    font.family: "Nunito"
                }
            }

            Custom_btn_1 {
                id: next_btn
                x: 570
                text: "Next"
                anchors.right: frame1.right
                anchors.top: frame1.bottom
                anchors.topMargin: 200
                anchors.rightMargin: 0
                enabled: (e_btn.isChecked || e_btn1.isChecked) ? true : false
                textItem.verticalAlignment: Text.AlignVCenter
                textItem.color: "#222222"
                textItem.horizontalAlignment: Text.AlignHCenter
                display: AbstractButton.IconOnly
            }
        }
    }
    states: [
        State {
            name: "H<880 W>1150"
            when: root.height <= 880 && root.height >= 670 && root.width > 1150

            PropertyChanges {
                target: next_btn
                anchors.topMargin: 25
            }
        },

        State {
            name: "H<670 W>1150"
            when: root.height < 670 && root.width > 1150

            PropertyChanges {
                target: next_btn
                anchors.topMargin: 25
            }

            PropertyChanges {
                target: header
                anchors.topMargin: parent.height * 4 / 100
            }

            PropertyChanges {
                target: dumpb_spcer_item
                anchors.topMargin: parent.height * 4 / 100
            }

            PropertyChanges {
                target: frame
                anchors.topMargin: 10
            }

            PropertyChanges {
                target: frame1
                anchors.topMargin: 10
            }
        },
        State {
            name: "H<=670 W<=1150"
            when: root.height <= 670 && root.width <= 1150 && root.width > 720
            PropertyChanges {
                target: next_btn
                anchors.rightMargin: 0
                anchors.topMargin: 25
            }

            PropertyChanges {
                target: header
                text: qsTr("Select an ELECTRE method\nand then press Next")
                anchors.topMargin: parent.height * 4 / 100
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
                anchors.topMargin: 10
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                visible: true
                anchors.leftMargin: (parent.width
                                     < frame1.width) ? 0 : ((parent.width - frame1.width) / 2)
                anchors.topMargin: 10
            }

            PropertyChanges {
                target: dumpb_spcer_item
                anchors.topMargin: parent.height * 4 / 100
            }
        },

        State {
            name: "H>880 W<1150"
            when: root.height >= 880 && root.width <= 1150 && root.width > 720

            PropertyChanges {
                target: header
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                anchors.leftMargin: (parent.width < 336) ? 0 : ((parent.width - frame1.width) / 2)
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
            }
        },

        State {
            name: "H<880 W<=1150"
            when: root.height > 670 && root.height < 880 && root.width <= 1150
                  && root.width > 720
            PropertyChanges {
                target: next_btn
                anchors.topMargin: 25
            }

            PropertyChanges {
                target: header
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                anchors.leftMargin: (parent.width
                                     < frame1.width) ? 0 : ((parent.width - frame1.width) / 2)
            }
        },

        State {
            name: "H<=880 W<=720"
            when: root.height <= 880 && root.height > 670 && root.width <= 720
            PropertyChanges {
                target: next_btn
                anchors.rightMargin: frame1.width - next_btn.width
                anchors.topMargin: 25
            }

            PropertyChanges {
                target: header
                text: root.width
                      >= 440 ? qsTr("Select an ELECTRE method\nand then press Next") : qsTr(
                                   "Select an ELECTRE\nmethod and then\npress Next")
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                visible: false
            }
        },

        State {
            name: "H<=670 W<=720"
            when: root.height <= 670 && root.width <= 720
            PropertyChanges {
                target: next_btn
                anchors.rightMargin: frame1.width - next_btn.width
                anchors.topMargin: 25
            }

            PropertyChanges {
                target: header
                text: root.width
                      >= 440 ? qsTr("Select an ELECTRE method\nand then press Next") : qsTr(
                                   "Select an ELECTRE\nmethod and then\npress Next")
                anchors.topMargin: parent.height * 4 / 100
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
                anchors.topMargin: 10
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                visible: false
                anchors.topMargin: 10
                anchors.leftMargin: (parent.width
                                     < frame1.width) ? 0 : ((parent.width - frame1.width) / 2)
            }

            PropertyChanges {
                target: dumpb_spcer_item
                anchors.topMargin: parent.height * 4 / 100
            }
        },

        State {
            name: "H>880 W<=720"
            when: root.height > 880 && root.width <= 720
            PropertyChanges {
                target: header
                text: root.width
                      >= 440 ? qsTr("Select an ELECTRE method\nand then press Next") : qsTr(
                                   "Select an ELECTRE\nmethod and then\npress Next")
                anchors.leftMargin: parent.width * 5 / 100
            }

            PropertyChanges {
                target: frame1
                width: 480 * (70 / 100)
                height: 305
                visible: false
                anchors.leftMargin: (parent.width < 336) ? 0 : ((parent.width - frame1.width) / 2)
            }

            PropertyChanges {
                target: frame
                width: 480 * (70 / 100)
            }

            PropertyChanges {
                target: next_btn
                anchors.rightMargin: frame1.width - next_btn.width
                anchors.topMargin: 200
            }
        }
    ]
    transitions: [
        Transition {
            id: transition
            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: frame
                        property: "anchors.topMargin"
                        duration: 65
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: frame1
                        property: "anchors.topMargin"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: frame1
                        property: "height"
                        duration: 65
                    }
                }
            }

            ParallelAnimation {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: next_btn
                        property: "anchors.topMargin"
                        duration: 65
                    }
                }

                SequentialAnimation {
                    PauseAnimation {
                        duration: 10
                    }

                    PropertyAnimation {
                        target: next_btn
                        property: "anchors.rightMargin"
                        duration: 65
                    }
                }
            }
            to: "*"
            from: "*"
        }
    ]
}
