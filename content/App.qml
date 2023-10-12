// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0
import QtQuick 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Window 2.15

Window {
    id: window
    width: 1300
    height: 700

    visible: true
    color: "#00ffffff"
    flags: window.visibility === Window.Minimized ? Qt.Window : (window.visibility === Window.Windowed ? Qt.CustomizeWindowHint | Qt.Window : (Qt.CustomizeWindowHint | Qt.Window))
    visibility: Window.Windowed
    contentOrientation: Qt.PortraitOrientation
    maximumHeight: 1080
    maximumWidth: 1920
    minimumHeight: 500
    minimumWidth: 415
    title: "ELECTRE Project"

    MainApp {
        id: mainApp
        anchors.fill: parent
        objectName: "mainApp"
    }

    Connections {
        target: mainApp.enlarge_btn

        onClicked: {
            if (window.visibility === Window.Windowed) {
                window.showFullScreen()
            } else if (window.visibility === Window.FullScreen) {
                window.showNormal()
            }
        }
    }

    Connections {
        target: mainApp.minimize_btn

        onClicked: {
            window.showMinimized()
        }
    }
}
