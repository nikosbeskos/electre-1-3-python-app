

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15

ListView {
    id: view
    width: 420
    height: 200
    clip: false
    snapMode: ListView.NoSnap
    boundsMovement: Flickable.FollowBoundsBehavior
    spacing: 0
    synchronousDrag: true
    pixelAligned: false
    boundsBehavior: Flickable.StopAtBounds

    highlightMoveDuration: 0

    children: [
        Rectangle {
            color: "#1d1d1d"
            anchors.fill: parent
            z: -1
        }
    ]

    model: List_customModel {}

    delegate: List_customDelegate {}
}
