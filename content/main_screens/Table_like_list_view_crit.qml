

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
    height: 420
    highlightMoveDuration: 0
    clip: true
    antialiasing: true
    maximumFlickVelocity: 1500
    snapMode: ListView.SnapToItem
    boundsMovement: Flickable.StopAtBounds
    boundsBehavior: Flickable.StopAtBounds

    children: [
        Rectangle {
            color: "#dbdbdb"
            anchors.fill: parent
            z: -1
        }
    ]

    highlight: Rectangle {
        width: view.width
        height: 60
        color: "#a658bbff"
        radius: 2
        border.color: "#57b9fc"
        border.width: 3
    }

    model: Criteria_listModel {}

    delegate: Table_delegate_c {
        id: table_delegate_c
    }

    function initialize() {
        view.model.set(0, {
                           "criteriaName": "Criteria 1",
                           "optimizationType": "Maximize"
                       })
        view.model.set(1, {
                           "criteriaName": "Criteria 2",
                           "optimizationType": "Minimize"
                       })
        view.model.set(2, {
                           "criteriaName": "Criteria 3",
                           "optimizationType": "Maximize"
                       })
    }
    //    Component.onCompleted: initialize()
}
