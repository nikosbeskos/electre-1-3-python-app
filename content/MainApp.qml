
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 6.3
import "main_screens"

Item {
    id: root
    width: 1920
    height: 1080
    property alias enlarge_btn: enlarge_btn
    property alias minimize_btn: minimize_btn

    antialiasing: false

    Item {
        id: main_area
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: backgound
            x: 0
            y: 30
            color: "#eaeaea"
            border.color: "#ffffff"
            border.width: 0
            anchors.fill: parent
            z: -1
        }

        Side_bar {
            id: side_bar
            x: 0
            y: 30
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            z: 1
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0

            Connections {
                target: side_bar.side_menu_btn
                onClicked: function () {
                    stackView.replace(basic_method_choice_screen)
                    if (side_bar.side_menu_btn1.isChecked) {
                        side_bar.side_menu_btn1.isChecked = false
                        loading_screen.state = ""
                        loading_screen.progressBar.anchors.topMargin = 30
                        loading_screen.progressBar.value = 0
                    }
                }
            }

            Connections {
                target: side_bar.side_menu_btn1
                onClicked: function () {
                    stackView.replace(loading_screen)
                    if (side_bar.side_menu_btn.isChecked) {
                        side_bar.side_menu_btn.isChecked = false
                    }
                }
            }

            Connections {
                target: side_bar.home_btn
                onClicked: function () {

                    function checkInitItem() {
                        return Object.is(stackView.currentItem,
                                         stackView.initialItem)
                    }

                    if (!(checkInitItem())) {

                        stackView.clear()
                        timer1.restart()
                    }
                }
            }

            Timer {
                id: timer1
                interval: 250

                onTriggered: {
                    stackView.push(stackView.initialItem)
                    basic_method_choice_screen.e_btn.isChecked = false
                    basic_method_choice_screen.e_btn1.isChecked = false
                    monte_carlo_choice_screen.e_btn_monte.isChecked = false
                    monte_carlo_choice_screen.e_btn_simple.isChecked = false
                    crit_Alt_screen.resetValues()
                    data_entry.textInput.clear()
                    data_entry.textInput2.clear()
                    data_entry.textInput3.clear()
                    side_bar.side_menu_btn.isChecked = false
                    side_bar.side_menu_btn1.isChecked = false
                    side_bar.side_menu_btn1.enabled = false
                    loading_screen.count = 0
                    loading_screen.label.visible = true
                    loading_screen.error_text.visible = false
                    loading_screen.progressBar.visible = false
                    loading_screen.progressBar.anchors.topMargin = 30
                    loading_screen.progressBar.value = 0
                    loading_screen.state = ""
                }
            }
        }

        StackView {
            id: stackView
            x: 65
            y: -30
            anchors.left: side_bar.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            topInset: 0
            topPadding: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            initialItem: welcome_screen

            Results_screen {
                id: results_screen
                x: parent.width
                width: parent.width
                height: parent.height
            }

            Loading_screen {
                id: loading_screen
                x: parent.width
                width: parent.width
                height: parent.height

                Connections {
                    id: coms_form_to_py_loading_scr
                    target: comm

                    onBackend_finished: function () {
                        if (loading_screen.progressBar.value === 100) {
                            stackView.push(results_screen)
                        }
                    }
                }

            }

            Data_entry {
                id: data_entry
                x: parent.width
                y: 0
                width: parent.width
                height: parent.height

                Connections {
                    id: previous_connection_DE
                    target: data_entry.previous_btn

                    onClicked: function () {
                        stackView.pop(crit_Alt_screen)
                    }
                }

                Connections {
                    id: data_to_table
                    target: crit_Alt_screen
                    objectName: "data_to_table"

                    // row and column names signal
                    signal rowColData(var rowNames, var colNames)

                    onDataReady: function (critData, altData) {
                        var dataC = []
                        var dataA = []
                        for (var i = 0; i < critData.length; i++) {
                            dataC.push(critData[i])
                        }
                        for (i = 0; i < altData.length; i++) {
                            dataA.push(altData[i][1])
                        }

                        data_to_table.rowColData(dataA, dataC) // emit to python
                    }
                }

                Connections {
                    id: confirm_connetion_DE
                    target: data_entry.confirm_btn

                    onClicked: function () {
                        side_bar.side_menu_btn1.enabled = true
                        side_bar.side_menu_btn.isChecked = false
                        side_bar.side_menu_btn1.isChecked = true
                        stackView.clear()
                        timer.restart()
                    }
                }

                Timer {
                    id: timer
                    interval: 250

                    onTriggered: {
                        loading_screen.busyIndicator.running = true
                        loading_screen.label.visible = true
                        loading_screen.error_text.visible = false
                        loading_screen.progressBar.visible = false
                        loading_screen.state = ""
                        stackView.push(loading_screen)
                        loading_screen.timer.restart()
                    }
                }
            }

            Crit_Alt_screen {
                id: crit_Alt_screen
                x: parent.width
                width: parent.width
                height: parent.height

                Connections {
                    target: crit_Alt_screen.previous_btn

                    onClicked: function () {
                        stackView.pop(monte_carlo_choice_screen)
                    }
                }

                Connections {
                    id: confirm_connection
                    target: crit_Alt_screen.confirm_btn
                    objectName: "confirm_connection"
                    property var eldata: []

                    signal methodAndMode(string el, string mode)

                    onClicked: function () {
                        if (confirm_connection.eldata.length > 0) {
                            var method = confirm_connection.eldata[0]
                            var type = confirm_connection.eldata[1]

                            if (method === "el1") {
                                if (type === "simple") {
                                    confirm_connection.methodAndMode(method,
                                                                     type)
                                    data_entry.el1 = true
                                    data_entry.simple = true
                                    data_entry.el3 = false
                                    data_entry.monte = false
                                    data_entry.state = "el1_simple"
                                    stackView.push(data_entry)
                                } else if (type === "monte") {
                                    confirm_connection.methodAndMode(method,
                                                                     type)
                                    data_entry.el1 = true
                                    data_entry.monte = true
                                    data_entry.el3 = false
                                    data_entry.simple = false
                                    data_entry.state = "el1_monte"
                                    stackView.push(data_entry)
                                }
                            } else if (method === "el3") {
                                if (type === "simple") {
                                    confirm_connection.methodAndMode(method,
                                                                     type)
                                    data_entry.el3 = true
                                    data_entry.simple = true
                                    data_entry.el1 = false
                                    data_entry.monte = false
                                    data_entry.state = "el3_simple"
                                    stackView.push(data_entry)
                                } else if (type === "monte") {
                                    confirm_connection.methodAndMode(method,
                                                                     type)
                                    data_entry.el3 = true
                                    data_entry.monte = true
                                    data_entry.el1 = false
                                    data_entry.simple = false
                                    data_entry.state = "el3_monte"
                                    stackView.push(data_entry)
                                }
                            }
                        }
                    }
                }

                Connections {
                    target: monte_carlo_choice_screen
                    onMethodData: function (method, type) {
                        confirm_connection.eldata = []
                        confirm_connection.eldata.push(method)
                        confirm_connection.eldata.push(type)
                    }
                }
            }

            Monte_carlo_choice_screen {
                id: monte_carlo_choice_screen
                x: parent.width
                width: parent.width
                height: parent.height
                property bool electre3selected: false
                property bool electre1selected: false

                // signl for sending the data to python end
                signal methodData(string method, string type)

                Connections {
                    target: monte_carlo_choice_screen.previous_btn
                    onClicked: function () {
                        stackView.pop(basic_method_choice_screen)
                    }
                }

                Connections {
                    target: monte_carlo_choice_screen.next_btn
                    onClicked: function () {
                        var data = 0
                        data = get_data()

                        console.error("data: " + data)
                        console.error("data[i]: " + data[0])

                        monte_carlo_choice_screen.methodData(
                                    data[0], data[1]) // emit the signal

                        stackView.push(crit_Alt_screen)
                    }

                    function get_data() {
                        var method = ""
                        var type = ""
                        if (monte_carlo_choice_screen.electre1selected) {
                            if (monte_carlo_choice_screen.e_btn_simple.isChecked) {
                                method = "el1"
                                type = "simple"
                                results_screen.isEl1 = true
                                results_screen.isSimple = true
                            } else if (monte_carlo_choice_screen.e_btn_monte.isChecked) {
                                method = "el1"
                                type = "monte"
                                results_screen.isEl1 = true
                                results_screen.isSimple = false
                            }
                        } else if (monte_carlo_choice_screen.electre3selected) {
                            if (monte_carlo_choice_screen.e_btn_simple.isChecked) {
                                method = "el3"
                                type = "simple"
                                results_screen.isEl1 = false
                                results_screen.isSimple = true
                            } else if (monte_carlo_choice_screen.e_btn_monte.isChecked) {
                                method = "el3"
                                type = "monte"
                                results_screen.isEl1 = false
                                results_screen.isSimple = false
                            }
                        } else {
                            console.info("No montecarlo_choice_screen electre is selected.\n[method, type] = [" + method + ', ' + type + ']')
                        }

                        return [method, type]
                    }
                }
            }

            Basic_method_choice_screen {
                id: basic_method_choice_screen
                x: parent.width
                width: parent.width
                height: parent.height

                Connections {
                    target: basic_method_choice_screen.next_btn
                    onClicked: function () {
                        stackView.push(monte_carlo_choice_screen)
                    }
                }

                Connections {
                    id: changeInfo_connection
                    target: basic_method_choice_screen.next_btn

                    onClicked: function () {
                        monte_carlo_choice_screen.electre1selected = false
                        monte_carlo_choice_screen.electre3selected = false
                        changeDisplayInfo()
                    }

                    function changeDisplayInfo() {
                        if (basic_method_choice_screen.e_btn.isChecked) {
                            // electre 1 is selected
                            monte_carlo_choice_screen.label_simple.text = qsTr(
                                        "ELECTRE I Simple")
                            monte_carlo_choice_screen.e_btn_simple.icon_source
                                    = "../images/logo_1.svg"
                            monte_carlo_choice_screen.label_monte.text = qsTr(
                                        "ELECTRE I Monte Carlo")
                            monte_carlo_choice_screen.e_btn_monte.icon_source
                                    = "../images/logo_1_dice.svg"
                            monte_carlo_choice_screen.e_btn_simple.description = qsTr(
                                        "Run a simple, single ELECTRE I method.")
                            monte_carlo_choice_screen.e_btn_monte.description = qsTr(
                                        "Run a Monte Carlo simulation along with ELECTRE I method, that includes a seed input and random numbers distribution selection.")
                            monte_carlo_choice_screen.electre1selected = true
                            monte_carlo_choice_screen.electre3selected = false
                        } else if (basic_method_choice_screen.e_btn1.isChecked) {
                            // electre 3 is selected
                            monte_carlo_choice_screen.label_simple.text = qsTr(
                                        "ELECTRE III Simple")
                            monte_carlo_choice_screen.e_btn_simple.icon_source
                                    = "../images/logo_2.svg"
                            monte_carlo_choice_screen.label_monte.text = qsTr(
                                        "ELECTRE III Monte Carlo")
                            monte_carlo_choice_screen.e_btn_monte.icon_source
                                    = "../images/logo_2_dice.svg"
                            monte_carlo_choice_screen.e_btn_simple.description = qsTr(
                                        "Run a simple, single ELECTRE III method.")
                            monte_carlo_choice_screen.e_btn_monte.description = qsTr(
                                        "Run a Monte Carlo simulation along with ELECTRE III method, that includes a seed input and random numbers distribution selection.")
                            monte_carlo_choice_screen.electre1selected = false
                            monte_carlo_choice_screen.electre3selected = true
                        }
                    }
                }
            }

            Welcome_screen {
                id: welcome_screen
                x: 0
                y: 0
                width: parent.width
                height: parent.height
            }
        }
    }

    Rectangle {
        id: titleBar
        height: 30
        color: "#eaeaea"
        border.color: "#ffffff"
        border.width: 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 1
        smooth: false
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Text {
            id: title
            width: parent.width / 5
            height: 20
            color: "#222222"
            text: qsTr("OptimizeIt")
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.preferShaping: true
            style: Text.Normal
            renderType: Text.QtRendering
            font.styleName: "ExtraLight"
            font.family: "Nunito"
        }

        MouseArea {
            id: titleBarMouseArea
            anchors.left: menuBar1.right
            anchors.right: windowButtonsRow_frame.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            property var clickPos: null

            onPressed: {
                clickPos = Qt.point(mouseX, mouseY)
            }

            onPositionChanged: {
                var delta = Qt.point(mouseX - clickPos.x, mouseY - clickPos.y)
                var new_x = window.x + delta.x
                var new_y = window.y + delta.y
                if (new_y <= 0) {
                    window.showFullScreen()
                } else if (new_y >= Screen.desktopAvailableHeight) {
                    window.x = new_x
                    window.y = Screen.desktopAvailableHeight - 31
                } else {
                    if (window.visibility === Window.FullScreen) {
                        window.showNormal()
                    }
                    window.x = new_x
                    window.y = new_y
                }
            }
        }

        Item {
            id: iconContainer
            width: 30
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0

            Image {
                id: image
                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                source: "images/window_icon_24x24.svg"
                antialiasing: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }
        }

        MenuBar1 {
            id: menuBar1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: iconContainer.right
            isClicked: false
            anchors.leftMargin: 15

            Pop_up_submenu {
                id: file_submenu
                x: 12
                width: 260
                visible: false
                anchors.left: parent.file_btn.left
                anchors.top: parent.bottom
                anchors.topMargin: 0
                anchors.leftMargin: 0
                z: 10

                Connections {
                    target: file_submenu.mouse_area
                    function onExited() {

                        if (!(contains_mouse())) {
                            console.log("STARTING TIMER__FORM_MAIN")
                            file_submenu.timer.start()
                        }
                    }

                    function contains_mouse() {
                        // if mouse is inside the area but cant be seen from mousArea
                        if (file_submenu.new_project.hovered
                                || file_submenu.open_project.hovered
                                || file_submenu.close_project.hovered
                                || file_submenu.save_project.hovered
                                || file_submenu.export_results.hovered
                                || file_submenu.exit.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
                Connections {
                    target: file_submenu
                    function onTimerTriggered() {
                        console.log("SIGNAL RECIEVED__FROM_MAIN")
                        if (!(contains_mouse()
                              || file_submenu.mouse_area.containsMouse)) {
                            console.log("CLOSED__SUBMENU__FROM_MAIN")
                            file_submenu.visible = false
                            menuBar1.isClicked = false
                        }
                    }

                    function contains_mouse() {
                        // if mouse is inside the area but cant be seen from mousArea
                        if (file_submenu.new_project.hovered
                                || file_submenu.open_project.hovered
                                || file_submenu.close_project.hovered
                                || file_submenu.save_project.hovered
                                || file_submenu.export_results.hovered
                                || file_submenu.exit.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }

            Pop_up_edit {
                id: pop_up_edit
                visible: false
                anchors.left: parent.edit_btn.left
                anchors.top: parent.bottom
                z: 10
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Connections {
                    target: pop_up_edit.mouse_area
                    function onExited() {
                        if (!(contains_mouse())) {
                            pop_up_edit.timer.start()
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_edit.undo.hovered || pop_up_edit.redo.hovered
                                || pop_up_edit.cut.hovered
                                || pop_up_edit.copy.hovered
                                || pop_up_edit.paste.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }

                Connections {
                    target: pop_up_edit
                    function onTimerTriggered() {
                        if (!(contains_mouse()
                              || pop_up_edit.mouse_area.containsMouse)) {
                            pop_up_edit.visible = false
                            menuBar1.isClicked = false
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_edit.undo.hovered || pop_up_edit.redo.hovered
                                || pop_up_edit.cut.hovered
                                || pop_up_edit.copy.hovered
                                || pop_up_edit.paste.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }

            Pop_up_view {
                id: pop_up_view
                visible: false
                anchors.left: parent.view_btn.left
                anchors.top: parent.bottom
                z: 10
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Connections {
                    target: pop_up_view.mouse_area
                    function onExited() {
                        if (!(contains_mouse())) {
                            pop_up_view.timer.start()
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_view.light_theme.hovered
                                || pop_up_view.dark_theme.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }

                Connections {
                    target: pop_up_view
                    function onTimerTriggered() {
                        if (!(contains_mouse()
                              || pop_up_view.mouse_area.containsMouse)) {
                            pop_up_view.visible = false
                            menuBar1.isClicked = false
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_view.light_theme.hovered
                                || pop_up_view.dark_theme.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }

            Pop_up_help {
                id: pop_up_help
                visible: false
                anchors.left: parent.help_btn.left
                anchors.top: parent.bottom
                z: 10
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Connections {
                    target: pop_up_help.mouse_area
                    function onExited() {
                        if (!(contains_mouse())) {
                            pop_up_help.timer.start()
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_help.welcome.hovered
                                || pop_up_help.documantation.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }

                Connections {
                    target: pop_up_help
                    function onTimerTriggered() {
                        if (!(contains_mouse()
                              || pop_up_help.mouse_area.containsMouse)) {
                            pop_up_help.visible = false
                            menuBar1.isClicked = false
                        }
                    }

                    function contains_mouse() {
                        if (pop_up_help.welcome.hovered
                                || pop_up_help.documantation.hovered) {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }

            Connections {
                target: menuBar1.file_btn
                function onClicked() {
                    if (file_submenu.visible) {
                        file_submenu.visible = false
                        menuBar1.isClicked = false
                    } else {
                        file_submenu.visible = true
                        menuBar1.isClicked = true
                    }
                }
            }

            Connections {
                target: menuBar1.file_btn
                function onHoveredChanged() {
                    if (menuBar1.file_btn.hovered
                            || file_submenu.mouse_area.containsMouse) {
                        if (menuBar1.isClicked) {
                            file_submenu.visible = true
                            pop_up_edit.visible = false
                            pop_up_view.visible = false
                            pop_up_help.visible = false
                        }
                    } else {
                        file_submenu.visible = false
                    }
                }
            }

            Connections {
                target: menuBar1.edit_btn
                function onClicked() {
                    if (pop_up_edit.visible) {
                        pop_up_edit.visible = false
                        menuBar1.isClicked = false
                    } else {
                        pop_up_edit.visible = true
                        menuBar1.isClicked = true
                    }
                }
            }

            Connections {
                target: menuBar1.edit_btn
                function onHoveredChanged() {
                    if (menuBar1.edit_btn.hovered
                            || pop_up_edit.mouse_area.containsMouse) {
                        if (menuBar1.isClicked) {
                            pop_up_edit.visible = true
                            file_submenu.visible = false
                            pop_up_view.visible = false
                            pop_up_help.visible = false
                        }
                    } else {
                        pop_up_edit.visible = false
                    }
                }
            }

            Connections {
                target: menuBar1.view_btn
                function onClicked() {
                    if (pop_up_view.visible) {
                        pop_up_view.visible = false
                        menuBar1.isClicked = false
                    } else {
                        pop_up_view.visible = true
                        menuBar1.isClicked = true
                    }
                }
            }

            Connections {
                target: menuBar1.view_btn
                function onHoveredChanged() {
                    if (menuBar1.view_btn.hovered
                            || pop_up_view.mouse_area.containsMouse) {
                        if (menuBar1.isClicked) {
                            pop_up_view.visible = true
                            file_submenu.visible = false
                            pop_up_edit.visible = false
                            pop_up_help.visible = false
                        }
                    } else {
                        pop_up_view.visible = false
                    }
                }
            }

            Connections {
                target: menuBar1.help_btn
                function onClicked() {
                    if (pop_up_help.visible) {
                        pop_up_help.visible = false
                        menuBar1.isClicked = false
                    } else {
                        pop_up_help.visible = true
                        menuBar1.isClicked = true
                    }
                }
            }

            Connections {
                target: menuBar1.help_btn
                function onHoveredChanged() {
                    if (menuBar1.help_btn.hovered
                            || pop_up_help.mouse_area.containsMouse) {
                        if (menuBar1.isClicked) {
                            pop_up_help.visible = true
                            file_submenu.visible = false
                            pop_up_edit.visible = false
                            pop_up_view.visible = false
                        } else {
                            pop_up_help.visible = false
                        }
                    }
                }
            }
        }

        Row {
            id: windowButtonsRow_frame
            x: 1869
            width: 138
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 1
            layoutDirection: Qt.RightToLeft
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0

            Close_btn {
                id: close_btn
                objectName: "close_btn"
                width: 45

                signal closeApp

                onClicked: {
                    closeApp()
                }
            }

            Enlarge_btn {
                id: enlarge_btn
                width: 45
            }

            Minimize_btn {
                id: minimize_btn
                width: 45
            }
        }

        Rectangle {
            id: botttom_border
            y: 13
            height: 1
            visible: true
            color: "#222222"
            border.width: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            z: 0
            clip: false
        }
    }
}
