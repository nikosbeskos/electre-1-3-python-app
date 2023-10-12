import QtQuick 2.15
import QtQuick.Controls.Universal 2.15
import Qt.labs.qmlmodels
import "../"

Item {
    id: item1
    width: 1920
    height: 1080
    property alias previous_btn: previous_btn
    property alias textInput3: textInput3
    property alias textInput2: textInput2
    property alias textInput: textInput
    property alias confirm_btn: confirm_btn

    property alias table_custom: table_custom
    property bool el1: true
    property bool el3: false
    property bool simple: false
    property bool monte: true
    property bool accepted: false

    onEl1Changed: {
        if (item1.el1 === true) {
            item1.el3 = false
        } else if (item1.el1 === false) {
            item1.el3 = true
        }
    }
    onEl3Changed: {
        if (item1.el3 === true) {
            item1.el1 = false
        } else if (item1.el3 === false) {
            item1.el1 = true
        }
    }
    onSimpleChanged: {
        if (item1.simple === true) {
            item1.monte = false
        } else if (item1.simple === false) {
            item1.monte = true
        }
    }
    onMonteChanged: {
        if (item1.monte === true) {
            item1.simple = false
        } else if (item1.monte === false) {
            item1.simple = true
        }
    }

    Rectangle {
        id: background
        color: "#eaeaea"
        border.width: 0
        anchors.fill: parent
        z: -1
    }

    Text {
        id: text1
        width: 300
        height: 80
        color: "#222222"
        text: qsTr("Data Entry")
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 5
        anchors.leftMargin: parent.width < width ? 0 : (parent.width - width) / 2
        font.family: "Nunito"
    }

    ScrollView {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: text1.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        antialiasing: true
        clip: true
        contentHeight: 995
        contentWidth: 1855
        padding: 6

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

        Item {
            id: table_container
            width: 800
            height: 600
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: (scrollView.contentWidth - width) / 15
            anchors.topMargin: 20

            Table_custom_NEW {
                id: table_custom
                width: parent.width
                height: parent.height
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 0
                anchors.topMargin: 0
                focus: true
                clip: true
            }

            Connections {
                id: get_crit_alt_num_from_py
                target: comm

                onCrit_alt_num: function (altCritNum) {
                    var alt = altCritNum[0]
                    var crit = altCritNum[1]
                    var delegateSize = Qt.vector2d(100, 30)
                    var tableContainerSize = Qt.vector2d(crit + 1, alt + 6)
                    var tableContainerSizePX = tableContainerSize.times(
                                delegateSize)

                    table_container.width = tableContainerSizePX.x
                    table_container.height = tableContainerSizePX.y
                }
            }
        }

        Item {
            id: options_container
            width: 400
            height: 500
            visible: true
            anchors.left: table_container.right
            anchors.top: table_container.top
            anchors.topMargin: 0
            anchors.leftMargin: 40

            MouseArea {
                id: mouseArea6
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                anchors.leftMargin: -40
                anchors.bottomMargin: 177

                onEntered: {
                    console.log("LARGE M. AREA ENTERED")
                    mouseArea3.exited()
                    mouseArea4.exited()
                    mouseArea5.exited()
                }
                onExited: {
                    console.log("LARGE M. AREA EXITED")
                    mouseArea3.exited()
                    mouseArea4.exited()
                    mouseArea5.exited()
                }
            }

            Label {
                id: header
                width: 150
                height: 40
                visible: true
                color: "#222222"
                text: qsTr("Options")
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 25
                font.family: "Nunito"
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: iter_num
                width: 160
                height: 30
                visible: true
                color: "#222222"
                text: qsTr("No. of iterations:")
                anchors.left: parent.left
                anchors.top: s_threshhold.bottom
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                font.family: "Nunito"
                anchors.leftMargin: 10
                anchors.topMargin: 10

                MouseArea {
                    id: mouseArea5
                    anchors.fill: parent
                    propagateComposedEvents: true
                    hoverEnabled: true
                    anchors.rightMargin: 8
                    anchors.leftMargin: 1
                    anchors.bottomMargin: 8
                    anchors.topMargin: 6

                    onEntered: {
                        console.log("ENTERED TOOLTIP")
                        tooltip2.show(tooltip2.text, tooltip2.timeout)
                    }
                    onExited: {
                        if (!mouseArea5.containsMouse) {
                            tooltip2.hide()
                        }
                    }
                }
            }

            ToolTip {
                id: tooltip2
                parent: iter_num
                visible: mouseArea5.hovered

                width: 250
                height: 45
                text: "Number of iterations for the Monte Carlos simulation. Higher is better, but not too high. Around 5,000 to 10,000 is ideal."
                timeout: 6000
                z: 1
                contentWidth: tooltip2.width
                contentHeight: tooltip2.height
                delay: 650

                contentItem: Text {
                    id: tooltiptext2
                    text: tooltip2.text
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.pointSize: 9
                    font.family: "Nunito"
                }
            }

            TextField {
                id: textInput
                width: 100
                height: 30
                visible: true
                color: "#222222"
                text: ""
                anchors.left: iter_num.right
                anchors.top: iter_num.top
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                placeholderText: "From 10"
                padding: 3
                focus: true
                selectByMouse: true
                selectionColor: "#57b9fc"
                font.family: "Nunito"
                anchors.leftMargin: 15
                anchors.topMargin: 0

                property bool text_accepted: false

                validator: RegularExpressionValidator {
                    id: regexprvalidator
                    regularExpression: /^(?:[1-9][0-9]|[1-9][0-9]{2,3}|[1-9][0-9]{4}|1[0-4][0-9]{4}|150000)$/
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    propagateComposedEvents: true

                    onClicked: {
                        var pos = textInput.positionAt(
                                    mouseX, mouseY,
                                    TextInput.CursorBetweenCharacters)
                        textInput.cursorPosition = pos
                        textInput.focus = true
                    }
                }

                Rectangle {
                    id: rectangle
                    color: "#ffffff"
                    border.color: "#858585"
                    border.width: 0
                    anchors.fill: parent
                    anchors.rightMargin: -1
                    anchors.leftMargin: -1
                    anchors.bottomMargin: -1
                    anchors.topMargin: -1
                    z: -1
                }

                Timer {
                    id: timer2
                    interval: 800

                    onTriggered: error1.visible = true
                }

                onTextChanged: {
                    function isValid() {
                        var text = textInput.text
                        var num = parseInt(text)
                        if (isNaN(num)) {
                            return false
                        } else if (num < 10) {
                            return false
                        } else {
                            return true
                        }
                    }

                    if (!textInput.acceptableInput && !isValid()) {
                        timer2.restart()
                        textInput.text_accepted = false
                    } else if (textInput.acceptableInput && isValid()) {
                        timer2.stop()
                        textInput.text_accepted = true
                    }

                    console.debug("-------------------------")
                    console.log("textInput.acceptableInput: " + textInput.acceptableInput)
                    console.log("DATA: " + textInput.text)
                }
            }

            Label {
                id: error1
                width: 135
                height: 30
                visible: false
                color: "#6b6b6b"
                text: qsTr("Has to be a number grater than 10")
                anchors.left: textInput.right
                anchors.top: textInput.top
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                font.pointSize: 9
                anchors.leftMargin: 15
                anchors.topMargin: 0

                Timer {
                    id: timer1
                    interval: 5000

                    onTriggered: error1.visible = false
                }

                onVisibleChanged: timer1.start()
            }

            Label {
                id: s_threshhold
                width: 160
                height: 30
                visible: true
                color: "#222222"
                text: qsTr("S threshold:")
                anchors.left: parent.left
                anchors.top: header.bottom
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                font.family: "Nunito"
                anchors.leftMargin: 10
                anchors.topMargin: 30
            }

            TextField {
                id: textInput2
                width: 100
                height: 30
                visible: true
                color: "#222222"
                text: ""
                anchors.left: s_threshhold.right
                anchors.top: s_threshhold.top
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                placeholderText: "From 0.5 to 1"
                padding: 3
                selectByMouse: true
                selectionColor: "#57b9fc"
                anchors.leftMargin: 15
                font.family: "Nunito"
                anchors.topMargin: 0

                property bool text_accepted: false

                validator: RegularExpressionValidator {
                    regularExpression: /^(0\.5[0-9]?|0\.[6-9][0-9]?)$/
                }

                MouseArea {
                    id: mouseArea1
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor

                    onClicked: {
                        var pos = textInput2.positionAt(
                                    mouseX, mouseY,
                                    TextInput.CursorBetweenCharacters)
                        textInput2.cursorPosition = pos
                        textInput2.focus = true
                    }
                }

                Rectangle {
                    id: rectangle2
                    color: "#ffffff"
                    border.color: "#858585"
                    border.width: 0
                    anchors.fill: parent
                    anchors.leftMargin: -1
                    anchors.bottomMargin: -1
                    anchors.topMargin: -1
                    z: -1
                }

                Timer {
                    id: timer3
                    interval: 800

                    onTriggered: error2.visible = true
                }

                onTextChanged: {
                    //FIXME
                    function isValid() {
                        var text = textInput2.text
                        var num = parseFloat(text)
                        console.debug("-------------")
                        console.log("text: " + text)
                        console.log("num: " + num)
                        console.log("isNAN: " + isNaN(num))
                        console.log("num out of [0.5 , 1]: " + (num < 0.5
                                                                || num > 1))
                        console.log("num in [0.5 , 1]: " + (num >= 0.5
                                                            && num <= 1))
                        if (isNaN(num)) {
                            return false
                        } else if (num < 0.5 || num > 1) {
                            return false
                        } else {
                            return true
                        }
                    }

                    if (!textInput2.acceptableInput && !isValid()) {
                        timer3.restart()
                        textInput2.text_accepted = false
                    } else if (textInput2.acceptableInput && isValid()) {
                        timer3.stop()
                        textInput2.text_accepted = true
                    }

                    console.debug("--------")
                    console.log("textInput.acceptableInput: " + textInput2.acceptableInput)
                    console.log("!textInput2.acceptableInput && !isValid(): "
                                + (!textInput2.acceptableInput && !isValid()))
                    console.debug("------------end-------------")
                }
            }

            Label {
                id: error2
                width: 151
                height: 30
                visible: false
                color: "#6b6b6b"
                text: qsTr("Has to be a number between 0.5 and 1")
                anchors.left: textInput2.right
                anchors.top: textInput2.top
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                anchors.leftMargin: 15
                anchors.topMargin: 0
                font.pointSize: 9

                Timer {
                    id: timer4
                    interval: 5000

                    onTriggered: error2.visible = false
                }

                onVisibleChanged: timer4.start()
            }

            Label {
                id: dist
                x: -3
                width: 160
                height: 30
                visible: true
                color: "#222222"
                text: qsTr("Distribution:")
                anchors.left: parent.left
                anchors.top: iter_num.bottom
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                anchors.leftMargin: 10
                font.family: "Nunito"
                anchors.topMargin: 10

                MouseArea {
                    id: mouseArea4
                    anchors.fill: parent
                    propagateComposedEvents: true
                    hoverEnabled: true
                    anchors.rightMargin: 45
                    anchors.leftMargin: 1
                    anchors.bottomMargin: 8
                    anchors.topMargin: 7

                    onEntered: {
                        console.log("ENTERED TOOLTIP")
                        tooltip1.show(tooltip1.text, tooltip1.timeout)
                    }
                    onExited: {
                        if (!mouseArea4.containsMouse) {
                            tooltip1.hide()
                        }
                    }
                }
            }

            ToolTip {
                id: tooltip1
                parent: dist
                visible: mouseArea4.hovered

                width: 160
                height: 35
                text: "Distribution that the random numbers will follow."
                timeout: 4500
                z: 1
                contentWidth: tooltip1.width
                contentHeight: tooltip1.height
                delay: 650

                contentItem: Text {
                    id: tooltiptext1
                    text: tooltip1.text
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.pointSize: 9
                    font.family: "Nunito"
                }
            }

            Rectangle {
                id: combo_area
                width: 100
                height: 30
                visible: true
                color: "#ffffff"
                border.color: "#57b9fc"
                border.width: 1
                anchors.left: dist.right
                anchors.top: dist.top
                anchors.leftMargin: 15
                anchors.topMargin: 0

                Combobox_Custom {
                    id: combobox_Custom
                    visible: true
                    anchors.fill: parent
                }
            }

            Label {
                id: tolerance
                x: -4
                width: 160
                height: 30
                visible: true
                color: "#222222"
                text: qsTr("Tolerance:")
                anchors.left: parent.left
                anchors.top: dist.bottom
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                font.family: "Nunito"
                anchors.topMargin: 10
                anchors.leftMargin: 10

                MouseArea {
                    id: mouseArea3
                    anchors.fill: parent
                    propagateComposedEvents: true
                    hoverEnabled: true
                    anchors.rightMargin: 65
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 8
                    anchors.topMargin: 7

                    onEntered: {
                        console.log("ENTERED TOOLTIP")
                        tooltip.show(tooltip.text, tooltip.timeout)
                    }
                    onExited: {
                        if (!mouseArea3.containsMouse) {
                            tooltip.hide()
                        }
                    }
                }
            }

            ToolTip {
                id: tooltip
                parent: tolerance
                visible: mouseArea3.hovered

                width: 180
                height: 35
                text: "Tolerance in \u00B1 % for the random numbers generator."
                timeout: 6000
                z: 1
                contentWidth: tooltip.width
                contentHeight: tooltip.height
                delay: 650

                contentItem: Text {
                    id: tooltiptext
                    text: tooltip.text
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.pointSize: 9
                    font.family: "Nunito"
                }
            }

            TextField {
                id: textInput3
                width: 102
                height: 32
                visible: true
                color: "#222222"
                text: ""
                anchors.left: tolerance.right
                anchors.top: tolerance.top
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                padding: 3
                placeholderText: "From 0 to 100"
                focus: true
                selectByMouse: true
                selectionColor: "#57b9fc"
                font.family: "Nunito"
                anchors.leftMargin: 15
                anchors.topMargin: 0

                property bool text_accepted: false

                validator: RegularExpressionValidator {
                    id: regexprvalidator1
                    regularExpression: /^(?:100|[1-9][0-9]?|0)(?:\s%)?$/
                }

                MouseArea {
                    id: mouseArea2
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    propagateComposedEvents: true

                    onClicked: {
                        var pos = textInput3.positionAt(
                                    mouseX, mouseY,
                                    TextInput.CursorBetweenCharacters)
                        textInput3.cursorPosition = pos
                        textInput3.focus = true
                    }
                }

                Rectangle {
                    id: rectangle3
                    color: "#ffffff"
                    border.color: "#858585"
                    border.width: 0
                    anchors.fill: parent
                    anchors.rightMargin: -1
                    anchors.leftMargin: -1
                    anchors.bottomMargin: -1
                    anchors.topMargin: -1
                    z: -1
                }

                Timer {
                    id: timer5
                    interval: 800

                    onTriggered: error3.visible = true
                }

                onTextChanged: {
                    function isValid() {
                        var text = textInput3.text
                        var num = parseInt(text)
                        if (isNaN(num)) {
                            return false
                        } else if (num < 10) {
                            return false
                        } else {
                            return true
                        }
                    }

                    if (!textInput3.acceptableInput && !isValid()) {
                        timer5.restart()
                        textInput3.text_accepted = false
                    } else if (textInput3.acceptableInput && isValid()) {
                        timer5.stop()
                        if (!textInput3.text.endsWith(" %")) {
                            timer7.restart()
                        }
                        textInput3.text_accepted = true
                    }

                    console.debug("-------------------------")
                    console.log("textInput.acceptableInput: " + textInput3.acceptableInput)
                    console.log("DATA: " + textInput3.text)
                }
                Timer {
                    id: timer7
                    interval: 2000
                    onTriggered: textInput3.text = (textInput3.text + " %")
                }
            }

            Label {
                id: error3
                width: 151
                height: 30
                visible: false
                color: "#6b6b6b"
                text: qsTr("Has to be a number between 0 and 100")
                anchors.left: textInput3.right
                anchors.top: textInput3.top
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                anchors.leftMargin: 15
                anchors.topMargin: 0
                font.pointSize: 9

                Timer {
                    id: timer6
                    interval: 5000

                    onTriggered: error3.visible = false
                }

                onVisibleChanged: timer6.start()
            }
        }

        Custom_btn_1 {
            id: confirm_btn
            x: 1338
            text: "Confirm"
            anchors.right: options_container.right
            anchors.top: options_container.bottom
            enabled: enableBtn()
            anchors.rightMargin: 0
            anchors.topMargin: 40

            Connections {
                id: connect_btn_to_py
                objectName: "connect_btn_to_py"
                target: confirm_btn

                signal options(string s_thresh, string iter_no, string distribution, string toler)

                onClicked: {
                    var s_thresh = textInput2.text
                    var iter_no = textInput.text
                    var distribution = combobox_Custom.comboBox.currentText
                    var toler = textInput3.text
                    connect_btn_to_py.options(s_thresh, iter_no,
                                              distribution, toler)
                }
            }

            Timer {
                repeat: true
                interval: 500

                onTriggered: confirm_btn.enabled = confirm_btn.enableBtn()
            }

            function enableBtn() {
                if (item1.state === "el1_monte") {
                    if (textInput.text_accepted && textInput2.text_accepted
                            && textInput3.text_accepted) {
                        return true
                    } else {
                        return false
                    }
                } else if (item1.state === "el1_simple") {
                    if (textInput2.text_accepted) {
                        return true
                    } else {
                        return false
                    }
                } else if (item1.state === "el3_simple") {
                    if (item1.el3) {
                        return true
                    } else {
                        return false
                    }
                } else if (item1.state === "el3_monte") {
                    if (textInput.text_accepted && textInput3.text_accepted) {
                        return true
                    } else {
                        return false
                    }
                }
            }
        }

        Custom_btn_1 {
            id: previous_btn
            x: 1266
            text: "Previous"
            anchors.verticalCenter: confirm_btn.verticalCenter
            anchors.right: confirm_btn.left
            anchors.rightMargin: 25
        }
    }

    Text {
        id: text2
        x: 424
        y: 18
        width: 200
        height: 60
        text: "State: " + item1.state
        anchors.right: text1.left
        font.pixelSize: 35
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 50
        font.family: "Nunito"
    }
    states: [
        State {
            name: "el1_monte"
            when: (item1.el1 === true && item1.monte === true
                   && item1.simple === false && item1.el3 === false)

            PropertyChanges {
                target: s_threshhold
                visible: true
            }
            PropertyChanges {
                target: textInput2
                visible: true
            }
            PropertyChanges {
                target: iter_num
                visible: true
            }
            PropertyChanges {
                target: textInput
                visible: true
            }
            PropertyChanges {
                target: dist
                visible: true
            }
            PropertyChanges {
                target: combo_area
                visible: true
            }
            PropertyChanges {
                target: tolerance
                visible: true
            }
            PropertyChanges {
                target: textInput3
                visible: true
            }
        },
        State {
            name: "el1_simple"
            when: (item1.el1 === true && item1.simple === true
                   && item1.monte === false && item1.el3 === false)

            PropertyChanges {
                target: s_threshhold
                visible: true
            }
            PropertyChanges {
                target: textInput2
                visible: true
            }
            PropertyChanges {
                target: iter_num
                visible: false
            }
            PropertyChanges {
                target: textInput
                visible: false
            }
            PropertyChanges {
                target: dist
                visible: false
            }
            PropertyChanges {
                target: combo_area
                visible: false
            }
            PropertyChanges {
                target: tolerance
                visible: false
            }
            PropertyChanges {
                target: textInput3
                visible: false
            }
        },
        State {
            name: "el3_simple"
            when: (item1.el1 === false && item1.simple === true
                   && item1.monte === false && item1.el3 === true)

            PropertyChanges {
                target: s_threshhold
                visible: false
            }
            PropertyChanges {
                target: textInput2
                visible: false
            }
            PropertyChanges {
                target: iter_num
                visible: false
            }
            PropertyChanges {
                target: textInput
                visible: false
            }
            PropertyChanges {
                target: dist
                visible: false
            }
            PropertyChanges {
                target: combo_area
                visible: false
            }
            PropertyChanges {
                target: tolerance
                visible: false
            }
            PropertyChanges {
                target: textInput3
                visible: false
            }
        },
        State {
            name: "el3_monte"
            when: (item1.el1 === false && item1.simple === false
                   && item1.monte === true && item1.el3 === true)

            PropertyChanges {
                target: s_threshhold
                visible: false
            }
            PropertyChanges {
                target: textInput2
                visible: false
            }
            PropertyChanges {
                target: iter_num
                visible: true
            }
            PropertyChanges {
                target: textInput
                visible: true
            }
            PropertyChanges {
                target: dist
                visible: true
            }
            PropertyChanges {
                target: combo_area
                visible: true
            }
            PropertyChanges {
                target: tolerance
                visible: true
            }
            PropertyChanges {
                target: textInput3
                visible: true
            }
        }
    ]
}
