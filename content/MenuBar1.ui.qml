

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
    width: 230
    height: 30
    property bool isClicked: false
    property alias help_btn: help_btn
    property alias view_btn: view_btn
    property alias edit_btn: edit_btn
    property alias file_btn: file_btn

    Menu_btn {
        id: file_btn
        width: 55
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
    }

    Menu_btn {
        id: edit_btn
        width: 55
        text: "Edit"
        anchors.left: file_btn.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
    }

    Menu_btn {
        id: view_btn
        width: 55
        text: "View"
        anchors.left: edit_btn.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
    }

    Menu_btn {
        id: help_btn
        width: 55
        text: "Help"
        anchors.left: view_btn.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
    }
}
