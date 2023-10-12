

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtCore
import QtQuick 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Layouts 6.3
import QtQuick.Dialogs
import "../"

Item {
    id: item1
    width: 1920
    height: 1080
    property alias previous_btn: previous_btn
    property alias confirm_btn: confirm_btn

    signal dataReady(variant critData, variant altData)

    function resetValues() {

        spinBox_Alt.value = 3
        spinBox_Crit.value = 3

        table_like_list_view_crit.model.set(0, {
                                                "criteriaName": "Criteria 1",
                                                "optimizationType": "Maximize"
                                            })
        table_like_list_view_crit.model.set(1, {
                                                "criteriaName": "Criteria 2",
                                                "optimizationType": "Minimize"
                                            })
        table_like_list_view_crit.model.set(2, {
                                                "criteriaName": "Criteria 3",
                                                "optimizationType": "Maximize"
                                            })

        table_like_list_view_alt.model.set(0, {
                                               "id_m": 1,
                                               "alternativeName": "Alternative 1"
                                           })
        table_like_list_view_alt.model.set(1, {
                                               "id_m": 2,
                                               "alternativeName": "Alternative 2"
                                           })
        table_like_list_view_alt.model.set(2, {
                                               "id_m": 3,
                                               "alternativeName": "Alternative 3"
                                           })

        spinBox_Alt.valueModified()
        spinBox_Crit.valueModified()
    }

    Rectangle {
        id: rectangle
        color: "#eaeaea"
        border.width: 0
        anchors.fill: parent
        z: -1
        layer.enabled: true
    }

    MouseArea {
        // used for closing the popup when clicked outside of the popup_mouseArea
        id: mouseArea_screen
        anchors.fill: parent
        enabled: false
        scrollGestureEnabled: false
        propagateComposedEvents: true

        Connections {
            target: mouseArea_screen

            function popupIsOpen() {
                if (popup_help.enabled && popup_help.visible
                        && popup_mouseArea.enabled) {
                    return true
                } else {
                    return false
                }
            }
            onClicked: {
                if (popupIsOpen()) {
                    if (!popup_mouseArea.containsMouse) {
                        popup_help.visible = false
                        popup_help.enabled = false
                        popup_mouseArea.enabled = false
                        mouseArea_screen.enabled = false
                        mouseArea_scrollview.enabled = false
                        popup_help.focus = false
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent

        Item {
            id: item2
            Layout.maximumHeight: parent.height
            Layout.minimumHeight: parent.height
            Layout.preferredHeight: parent.height
            Layout.maximumWidth: parent.width
            Layout.minimumWidth: parent.width
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Item {
                id: top_container
                height: 210
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                z: 1
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Label {
                    id: header
                    width: 480
                    height: 80
                    color: "#222222"
                    text: qsTr("Set the core elements for the problem or import form Excel.")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.styleName: "Regular"
                    font.pointSize: 25
                    font.family: "Nunito"
                    anchors.leftMargin: parent.width * 2 / 100
                    anchors.topMargin: parent.height * 15 / 100
                }

                Label {
                    id: crit
                    width: 115
                    height: 60
                    color: "#222222"
                    text: qsTr("Criteria :")
                    anchors.left: header.left
                    anchors.top: header.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: parent.height * 15 / 100
                    anchors.leftMargin: 0
                    font.styleName: "ExtraLight"
                    font.bold: true
                    font.italic: false
                    font.family: "Nunito"
                    font.pointSize: 20
                }

                Label {
                    id: alt
                    width: 175
                    height: 60
                    color: "#222222"
                    text: qsTr("Alternatives :")
                    anchors.verticalCenter: spinBox_Crit.verticalCenter
                    anchors.left: spinBox_Crit.right
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenterOffset: 0
                    font.styleName: "ExtraLight"
                    font.strikeout: false
                    font.underline: false
                    font.italic: false
                    font.bold: true
                    font.family: "Nunito"
                    font.pointSize: 20
                    anchors.leftMargin: 60
                }

                Spinbox_c {
                    id: spinBox_Crit
                    width: 100
                    height: 50
                    anchors.verticalCenter: crit.verticalCenter
                    anchors.left: crit.right
                    z: 5
                    to: 20
                    font.pointSize: 20
                    anchors.leftMargin: 10

                    Connections {
                        target: spinBox_Crit

                        onValueModified: {
                            timer_crit.restart()
                        }
                    }

                    Timer {
                        id: timer_crit
                        interval: 800

                        onTriggered: {
                            var spinValue = spinBox_Crit.value
                            var modelValueCount = table_like_list_view_crit.model.count
                            var diff = spinValue - modelValueCount

                            if (diff > 0) {
                                for (var i = 0; i < diff; i++) {
                                    table_like_list_view_crit.model.append({
                                                                               "criteriaName": "Input name",
                                                                               "optimizationType": "Maximize"
                                                                           })
                                }
                            } else if (diff < 0) {
                                var absdiff = diff * -1
                                for (i = 0; i < absdiff; i++) {
                                    table_like_list_view_crit.model.remove(
                                                table_like_list_view_crit.model.count - 1)
                                }
                            }
                        }
                    }
                }

                Spinbox_c {
                    id: spinBox_Alt
                    width: 100
                    height: 50
                    anchors.verticalCenter: alt.verticalCenter
                    anchors.left: alt.right
                    z: 5
                    font.pointSize: 20
                    from: 3
                    anchors.leftMargin: 10

                    Connections {
                        target: spinBox_Alt

                        onValueModified: {
                            timer_alt.restart()
                        }
                    }

                    Timer {
                        id: timer_alt
                        interval: 800

                        onTriggered: {
                            var spinValue = spinBox_Alt.value
                            var modelValueCount = table_like_list_view_alt.model.count
                            var diff = spinValue - modelValueCount

                            if (diff > 0) {
                                for (var i = 0; i < diff; i++) {
                                    table_like_list_view_alt.model.append({
                                                                              "id_m": (spinValue - diff + i + 1),
                                                                              "alternativeName": "Input name"
                                                                          })
                                }
                            } else if (diff < 0) {
                                var absdiff = diff * -1
                                for (i = 0; i < absdiff; i++) {
                                    table_like_list_view_alt.model.remove(
                                                table_like_list_view_alt.model.count - 1)
                                }
                            }
                        }
                    }
                }

                Import_excel {
                    // TODO: NOTE: connect to python load excel file
                    id: import_excel
                    width: 60
                    height: 60
                    anchors.verticalCenter: spinBox_Alt.verticalCenter
                    anchors.left: spinBox_Alt.right
                    anchors.leftMargin: 80

                    onClicked: {
                        import_excel.isChecked = true
                        fileDialog.open()
                    }
                }

                FileDialog {
                    id: fileDialog
                    objectName: "fileDialog"

                    currentFolder: StandardPaths.standardLocations(
                                       StandardPaths.DocumentsLocation)[0]
                    title: "Open File..."
                    nameFilters: ["All Files (*)", "Excel Files (*.xlsx)"]

                    signal filepath_to_py(variant path)

                    onAccepted: {
                        var filepath = fileDialog.selectedFile
                        fileDialog.filepath_to_py(filepath)
                    }
                }

                Info {
                    id: info
                    height: 30
                    anchors.left: import_excel.right
                    anchors.top: import_excel.top
                    anchors.topMargin: 0
                    anchors.leftMargin: 10

                    Connections {
                        target: info
                        onClicked: {
                            popup_help.visible = true
                            popup_help.enabled = true
                            popup_mouseArea.enabled = true
                            mouseArea_screen.enabled = true
                            mouseArea_scrollview.enabled = true
                            popup_help.focus = true
                        }
                    }
                }

                Popup_help {
                    id: popup_help
                    visible: false
                    anchors.left: info.right
                    anchors.top: parent.top
                    z: 10
                    focus: true
                    enabled: false
                    anchors.topMargin: 60
                    anchors.leftMargin: 20

                    MouseArea {
                        id: popup_mouseArea
                        anchors.fill: parent
                        scrollGestureEnabled: false
                        propagateComposedEvents: true
                        enabled: false
                    }

                    Keys.onEscapePressed: {
                        popup_help.visible = false
                        popup_help.enabled = false
                        popup_mouseArea.enabled = false
                        mouseArea_screen.enabled = false
                        mouseArea_scrollview.enabled = false
                        popup_help.focus = false
                    }
                }

                Item {
                    id: separator
                    x: 20
                    y: 215
                    width: parent.width - 40
                    height: 7
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -3
                    z: -1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: rectangle1
                        color: "#858585"
                        radius: 1.5
                        border.width: 0
                        anchors.fill: parent
                        anchors.rightMargin: 2
                        anchors.leftMargin: 2
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                    }
                }
            }

            Item {
                id: bottom_container
                x: 0
                y: 210
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: top_container.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Label {
                    id: header1
                    x: 38
                    y: -175
                    width: 768
                    height: 80
                    color: "#222222"
                    text: qsTr("Fill in the names of thecriteria and alternatives, and select the optimization type as well")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    anchors.topMargin: parent.height * 3.5 / 100
                    font.styleName: "Regular"
                    font.family: "Nunito"
                    font.pointSize: 25
                    anchors.leftMargin: parent.width * 2 / 100
                }

                Item {
                    id: flick_container
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: header1.bottom
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 25

                    ScrollView {
                        id: scrollView
                        anchors.fill: parent
                        contentWidth: 1855
                        antialiasing: true
                        clip: true
                        contentHeight: 750

                        ScrollBar.vertical: ScrollBar {
                            id: vbar
                            parent: scrollView
                            x: scrollView.mirrored ? 0 : scrollView.width - width
                            y: scrollView.topPadding
                            width: 18
                            height: scrollView.availableHeight
                            active: scrollView.ScrollBar.horizontal.active
                        }

                        ScrollBar.horizontal: ScrollBar {
                            id: hbar
                            parent: scrollView
                            x: scrollView.leftPadding
                            y: scrollView.height - height
                            width: scrollView.availableWidth
                            height: 18
                            active: vbar.active
                            interactive: true
                        }

                        MouseArea {
                            id: mouseArea_scrollview
                            x: 0
                            y: 0
                            anchors.fill: parent
                            enabled: false
                            propagateComposedEvents: true
                            anchors.rightMargin: 0

                            Connections {
                                target: mouseArea_scrollview

                                function popupIsOpen() {
                                    if (popup_help.enabled && popup_help.visible
                                            && popup_mouseArea.enabled) {
                                        return true
                                    } else {
                                        return false
                                    }
                                }

                                onClicked: {
                                    if (popupIsOpen()) {
                                        if (!popup_mouseArea.containsMouse) {
                                            popup_help.visible = false
                                            popup_help.enabled = false
                                            popup_mouseArea.enabled = false
                                            mouseArea_screen.enabled = false
                                            mouseArea_scrollview.enabled = false
                                            popup_help.focus = false
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            id: table_container
                            x: 38
                            y: 0
                            width: 960
                            height: 500
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: (item1.width > (width + 15)) ? ((parent.parent.width - width) / 2) : 0
                            anchors.topMargin: 0

                            Rectangle {
                                id: table_header
                                width: 420
                                height: 440
                                color: "#00ffffff"
                                border.color: "#57b9fc"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                z: 0

                                Rectangle {
                                    id: name_rect
                                    height: 40
                                    color: "#dbdbdb"
                                    border.color: "#57b9fc"
                                    border.width: 2
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: table_like_list_view_crit.top
                                    anchors.rightMargin: 126
                                    anchors.leftMargin: 0
                                    anchors.bottomMargin: 0
                                    anchors.topMargin: 0

                                    Label {
                                        id: label
                                        color: "#222222"
                                        text: qsTr("Criterion Name")
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 12
                                        font.family: "Nunito"
                                        anchors.rightMargin: 5
                                        anchors.leftMargin: 5
                                        anchors.bottomMargin: 5
                                        anchors.topMargin: 5
                                    }
                                }

                                Rectangle {
                                    id: opttype_rect
                                    height: 40
                                    color: "#dbdbdb"
                                    border.color: "#57b9fc"
                                    border.width: 2
                                    anchors.left: name_rect.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: table_like_list_view_crit.top
                                    anchors.rightMargin: 0
                                    anchors.leftMargin: 0
                                    anchors.bottomMargin: 0
                                    anchors.topMargin: 0

                                    Label {
                                        id: label1
                                        color: "#222222"
                                        text: qsTr("Optim. Type")
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 12
                                        font.family: "Nunito"
                                        anchors.rightMargin: 5
                                        anchors.leftMargin: 5
                                        anchors.bottomMargin: 5
                                        anchors.topMargin: 5
                                    }
                                }

                                Table_like_list_view_crit {
                                    id: table_like_list_view_crit
                                    y: 0
                                    height: 400
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.rightMargin: 1
                                    anchors.leftMargin: 1
                                    anchors.bottomMargin: 1
                                }
                            }

                            Rectangle {
                                id: table_header1
                                width: 420
                                height: 440
                                color: "#00ffffff"
                                border.color: "#57b9fc"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: table_header.right
                                anchors.leftMargin: 90

                                Rectangle {
                                    id: _ID_rect
                                    height: 40
                                    color: "#dbdbdb"
                                    border.color: "#57b9fc"
                                    border.width: 2
                                    anchors.left: parent.left
                                    anchors.right: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: table_like_list_view_alt.top
                                    anchors.leftMargin: 0
                                    anchors.rightMargin: -46
                                    anchors.bottomMargin: 0

                                    Label {
                                        color: "#222222"
                                        text: qsTr("ID")
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        font.pointSize: 12
                                        font.family: "Nunito"
                                        anchors.bottomMargin: 5
                                        anchors.topMargin: 5
                                    }
                                    anchors.topMargin: 0
                                }

                                Rectangle {
                                    id: altName_rect
                                    height: 40
                                    color: "#dbdbdb"
                                    border.color: "#57b9fc"
                                    border.width: 2
                                    anchors.left: _ID_rect.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: table_like_list_view_alt.top
                                    anchors.leftMargin: 0
                                    anchors.rightMargin: 0
                                    anchors.bottomMargin: 0

                                    Label {
                                        color: "#222222"
                                        text: qsTr("Alternative Name")
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.leftMargin: 5
                                        anchors.rightMargin: 5
                                        font.pointSize: 12
                                        font.family: "Nunito"
                                        anchors.bottomMargin: 5
                                        anchors.topMargin: 5
                                    }
                                    anchors.topMargin: 0
                                }

                                Table_like_list_view_alt {
                                    id: table_like_list_view_alt
                                    height: 400
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.rightMargin: 1
                                    anchors.leftMargin: 1
                                    anchors.bottomMargin: 1
                                }
                                z: 0
                            }

                            Connections {
                                id: com_to_py_get_excel_data
                                target: comm

                                onExcelReadDataSignal: function (rown, coln) {
                                    console.info("ExcelReadDataSignal recieved")
                                    var colcount = coln.length
                                    var rowcount = rown.length

                                    for (var i = 0; i < colcount; i++) {
                                        table_like_list_view_crit.model.set(i, {
                                                                                "criteriaName": coln[i],
                                                                                "optimizationType": "Maximize"
                                                                            })
                                    }
                                    for (i = 0; i < rowcount; i++) {
                                        table_like_list_view_alt.model.set(i, {
                                                                               "id_m": (i + 1),
                                                                               "alternativeName": rown[i]
                                                                           })
                                    }

                                    spinBox_Alt.value = rowcount
                                    spinBox_Crit.value = colcount

                                    spinBox_Alt.valueModified()
                                    spinBox_Crit.valueModified()
                                }
                            }

                            //                            // workaround for qt not being able to handle signals directly from python
                            //                            signal reemit(variant rown, variant coln)

                            //                            // connect the python signal to the "reemit" signal, like a repeater concept
                            //                            Component.onCompleted: comm.ExcelReadDataSignal.connect(
                            //                                                       reemit)

                            //                            onReemit: {
                            //                                console.log("REEMIT")
                            //                                var rownames = rown
                            //                                var colnames = coln
                            //                                var colcount = colnames.length
                            //                                var rowcount = rownames.length

                            //                                for (var i = 0; i < colcount; i++) {
                            //                                    table_like_list_view_crit.model.set(i, {
                            //                                                                            "criteriaName": colnames[i],
                            //                                                                            "optimizationType": "Maximize"
                            //                                                                        })
                            //                                }
                            //                                for (i = 0; i < rowcount; i++) {
                            //                                    table_like_list_view_alt.model.set(i, {
                            //                                                                           "id_m": (i + 1),
                            //                                                                           "alternativeName": rownames[i]
                            //                                                                       })
                            //                                }

                            //                                spinBox_Alt.value = rowcount
                            //                                spinBox_Crit.value = colcount

                            //                                spinBox_Alt.valueModified()
                            //                                spinBox_Crit.valueModified()
                            //                            }
                        }

                        Custom_btn_1 {
                            id: confirm_btn
                            x: 848
                            y: 525
                            anchors.right: table_container.right
                            anchors.top: table_container.bottom
                            textItem.color: "#222222"
                            textItem.horizontalAlignment: Text.AlignHCenter
                            textItem.verticalAlignment: Text.AlignVCenter
                            textItem.text: "Confirm"
                            anchors.topMargin: 25
                            anchors.rightMargin: 0

                            onClicked: {
                                var dataC = []
                                var dataA = []
                                var countC = table_like_list_view_crit.model.count
                                var countA = table_like_list_view_alt.model.count

                                for (var i = 0; i < countC; i++) {
                                    var item = table_like_list_view_crit.model.get(
                                                i)
                                    dataC.push([item.criteriaName, item.optimizationType])
                                }

                                for (i = 0; i < countA; i++) {
                                    item = table_like_list_view_alt.model.get(i)
                                    dataA.push([item.id_m, item.alternativeName])
                                }

                                // NOTE: emit data to MainApp
                                dataReady(dataC, dataA)
                                console.log("DATA EMITED [CRITALTSCREEN]")
                            }
                        }

                        Custom_btn_1 {
                            id: previous_btn
                            text: "Previous"
                            anchors.verticalCenter: confirm_btn.verticalCenter
                            anchors.right: confirm_btn.left
                            anchors.rightMargin: 25
                        }
                    }
                }
            }
        }
    }
}
