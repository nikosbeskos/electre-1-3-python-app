import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    objectName: "results_screen_root"
    width: 1920
    height: 1080

    Rectangle {
        id: backgorund
        color: "#eaeaea"
        border.width: 0
        anchors.fill: parent
        z: -1
    }

    Text {
        id: header
        width: 300
        height: 80
        color: "#222222"
        text: qsTr("Results")
        anchors.left: parent.left
        anchors.top: parent.top
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.leftMargin: parent.width < width ? 0 : (parent.width - width) / 2
        anchors.topMargin: 5
        font.family: "Nunito"
    }

    ScrollView {
        id: scrollView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        contentHeight: 2000
        contentWidth: 1853
        antialiasing: true
        padding: 6
        clip: true
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.bottomMargin: 1
        anchors.topMargin: 0

        Text {
            id: decMatrix
            width: 250
            height: 40
            color: "#222222"
            text: qsTr("Decision Matrix")
            anchors.left: parent.left
            anchors.top: parent.top
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 100
            font.family: "Nunito"
            anchors.topMargin: 20
        }

        Table_custom_Results {
            id: decMtx_Table
            width: 500
            height: 250
            anchors.left: decMatrix.left
            anchors.top: decMatrix.bottom
            clip: true
            anchors.leftMargin: 0
            anchors.topMargin: 20

            Component.onCompleted: {
                var decModel = data_entry.table_custom.view.model
                console.log("[FROM RESULS SCREEN] MODEL: " + decModel)
            }
        }

        // TODO: Move position bindings from the component to the Loader.
        //       Check all uses of 'parent' inside the root element of the component.
        //       Rename all outer uses of the id "setSimpleWraperItem" to "loader_setSimpleWraperItem.item".
        //       Rename all outer uses of the id "preordersAndRankingsMtx" to "loader_setSimpleWraperItem.item.preordersAndRankingsMtx".
        //       Rename all outer uses of the id "credDegORsuperiority" to "loader_setSimpleWraperItem.item.credDegORsuperiority".
        //       Rename all outer uses of the id "creddegORsuperiorityMtx" to "loader_setSimpleWraperItem.item.creddegORsuperiorityMtx".
        //       Rename all outer uses of the id "preordersAndRankings" to "loader_setSimpleWraperItem.item.preordersAndRankings".
        Component {
            id: component_setSimpleWraperItem
            Item {
                property alias preordersAndRankingsMtx: inner_preordersAndRankingsMtx
                property alias credDegORsuperiority: inner_credDegORsuperiority
                property alias creddegORsuperiorityMtx: inner_creddegORsuperiorityMtx
                property alias preordersAndRankings: inner_preordersAndRankings
                property alias img: inner_img

                id: setSimpleWraperItem
                anchors.left: decMtx_Table.left
                anchors.top: decMtx_Table.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 20

                Text {
                    id: inner_credDegORsuperiority
                    width: 400
                    height: 40
                    color: "#222222"
                    text: root.isEl1 ? "Superiority Matrix" : "Credibility Degree Matrix"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    font.family: "Nunito"
                }
                Table_custom_Results {
                    id: inner_creddegORsuperiorityMtx
                    width: 500
                    height: 250
                    anchors.left: inner_credDegORsuperiority.left
                    anchors.top: inner_credDegORsuperiority.bottom
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Text {
                    id: inner_preordersAndRankings
                    width: 350
                    color: "#222222"
                    text: root.isEl1 ? "Ranking" : "Preorders and Ranking"
                    anchors.left: inner_creddegORsuperiorityMtx.left
                    anchors.top: inner_creddegORsuperiorityMtx.bottom
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Nunito"
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Table_custom_Results {
                    id: inner_preordersAndRankingsMtx
                    width: 500
                    height: 250
                    anchors.left: inner_preordersAndRankings.left
                    anchors.top: inner_preordersAndRankings.bottom
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Text {
                    id: inner_graphs
                    width: 50
                    color: "#222222"
                    text: "Graphs"
                    anchors.left: inner_preordersAndRankingsMtx.left
                    anchors.top: inner_preordersAndRankingsMtx.bottom
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Nunito"
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Image {
                    id: inner_img
                    width: 1000
                    height: 600
                    visible: root.isSimple ? true : false
                    anchors.left: inner_graphs.left
                    anchors.top: inner_graphs.bottom
                    horizontalAlignment: Image.AlignLeft
                    verticalAlignment: Image.AlignTop
                    source: ""
                    fillMode: Image.PreserveAspectFit
                    anchors.leftMargin: 0
                    anchors.topMargin: 20

                    onSourceChanged: {
                        console.info("\n\n\nimage W|H: " + inner_img.sourceSize)
                    }
                }

                Component.onCompleted: {
                    var childrenlist = setSimpleWraperItem.children
                    var longest = childrenlist[0].width
                    for (var i = 0; i < childrenlist.length; i++) {
                        //                    console.log("cild: " + childrenlist[i] + " width: " + childrenlist[i].width)
                        if (childrenlist[i].width > longest) {
                            longest = childrenlist[i].width
                        }
                    }

                    var sum = 0
                    for (i = 0; i < childrenlist.length; i++) {
                        //                    console.log("cild: " + childrenlist[i] + " height: " + childrenlist[i].height)
                        sum += childrenlist[i].height
                    }

                    //                console.log("(LONGEST|SUM): (" + longest + "|" + sum + ")")
                    setSimpleWraperItem.width = longest
                    setSimpleWraperItem.height = sum
                }
            }
        }

        // TODO: Move position bindings from the component to the Loader.
        //       Check all uses of 'parent' inside the root element of the component.
        //       Rename all outer uses of the id "setMonteWrapper" to "loader_setMonteWrapper.item".
        //       Rename all outer uses of the id "rankAcceptabilityMtx" to "loader_setMonteWrapper.item.rankAcceptabilityMtx".
        //       Rename all outer uses of the id "expectetRankMtx" to "loader_setMonteWrapper.item.expectetRankMtx".
        //       Rename all outer uses of the id "expectedRank" to "loader_setMonteWrapper.item.expectedRank".
        //       Rename all outer uses of the id "rankAcceptability" to "loader_setMonteWrapper.item.rankAcceptability".
        Component {
            id: component_setMonteWrapper
            Item {
                property alias rankAcceptabilityMtx: inner_rankAcceptabilityMtx
                property alias expectedRankMtx: inner_expectedRankMtx
                property alias expectedRank: inner_expectedRank
                property alias rankAcceptability: inner_rankAcceptability

                id: setMonteWrapper
                anchors.left: decMtx_Table.left
                anchors.top: decMtx_Table.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 20

                Text {
                    id: inner_expectedRank
                    width: 230
                    color: "#222222"
                    text: "Expected Rank"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Nunito"
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                }

                Table_custom_Results {
                    id: inner_expectedRankMtx
                    width: 500
                    height: 250
                    anchors.left: inner_expectedRank.left
                    anchors.top: inner_expectedRank.bottom
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Text {
                    id: inner_rankAcceptability
                    width: 260
                    color: "#222222"
                    text: "Rank Acceptability"
                    anchors.left: inner_expectedRankMtx.left
                    anchors.top: inner_expectedRankMtx.bottom
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Nunito"
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }

                Table_custom_Results {
                    id: inner_rankAcceptabilityMtx
                    width: 500
                    height: 250
                    anchors.left: inner_rankAcceptability.left
                    anchors.top: inner_rankAcceptability.bottom
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                }
            }
        }

        Loader {
            id: loader_SimpleOrMonte
            anchors.left: decMtx_Table.left
            anchors.top: decMtx_Table.bottom
            active: true
            anchors.leftMargin: 0
            anchors.topMargin: 20
            sourceComponent: isSimple ? component_setSimpleWraperItem : component_setMonteWrapper
            Component.onCompleted: {

                loader_SimpleOrMonte.anchors.left = decMtx_Table.left
                loader_SimpleOrMonte.anchors.top = decMtx_Table.bottom
                loader_SimpleOrMonte.anchors.leftMargin = 0
                loader_SimpleOrMonte.anchors.topMargin = 20
            }
        }
    }

    signal sendModels(var models)

    property bool isEl1: false
    property bool isEl3: !isEl1
    property bool isSimple: false
    property bool isMonte: !isSimple

    Connections {
        id: coms_from_and_to_py
        target: comm

        onSvg_src: function (src) {
            var source = "data:image/svg+xml," + encodeURIComponent(src)
            loader_SimpleOrMonte.item.img.source = source
        }

        onGet_results_models: function () {

            var decMtxModel = data_entry.table_custom.view.model
            decMtx_Table.view.model = decMtxModel

            var expectedMtxModel
            var acceptabilityMtxModel

            var models

            if (root.isEl1) {
                if (root.isSimple) {
                    var SuperiorityMtxModel = loader_SimpleOrMonte.item.creddegORsuperiorityMtx.view.model
                    var rankingMtxModel = loader_SimpleOrMonte.item.preordersAndRankingsMtx.view.model

                    models = [SuperiorityMtxModel, rankingMtxModel]
                    // send models to python
                    root.sendModels(models)
                } else if (root.isMonte) {
                    expectedMtxModel = loader_SimpleOrMonte.item.expectedRankMtx.view.model
                    acceptabilityMtxModel
                            = loader_SimpleOrMonte.item.rankAcceptabilityMtx.view.model

                    models = [expectedMtxModel, acceptabilityMtxModel]
                    //send to python
                    root.sendModels(models)
                }
            } else if (root.isEl3) {
                if (root.isSimple) {
                    var credDegMtxModel = loader_SimpleOrMonte.item.creddegORsuperiorityMtx.view.model
                    var preordersAndRankingsMtxModel = loader_SimpleOrMonte.item.preordersAndRankingsMtx.view.model

                    models = [credDegMtxModel, preordersAndRankingsMtxModel]
                    // send to py
                    root.sendModels(models)
                } else if (root.isMonte) {
                    expectedMtxModel = loader_SimpleOrMonte.item.expectedRankMtx.view.model
                    acceptabilityMtxModel
                            = loader_SimpleOrMonte.item.rankAcceptabilityMtx.view.model

                    models = [expectedMtxModel, acceptabilityMtxModel]
                    //send to python
                    root.sendModels(models)
                }
            }
        }

        onCrit_alt_num: function (altCritNum) {

            var alt = altCritNum[0]
            var crit = altCritNum[1]

            var delegateSize = Qt.vector2d(100, 30)

            var decMatrixSize = 0
            var superiorityMtxSize = 0

            var decMatrixSizePX = 0
            var superiorityMtxSizePX = 0

            var credDegMtxSize = 0
            var credDegMtxSizePX

            var expectedRankSize = 0
            var rankAcceptabilitySize = 0
            var rankAcceptabilitySizePX = 0
            var expectedRankSizePX = 0

            var rankingsMtxSize = 0
            var rankingsMtxSizePX = 0

            var canvasPx = 0

            var maxX = 0
            var maxY = 0
            var totalSize = 0

            //console.log("\n-----\nMODEL:\t" + model + "\n-----\n-----")
            //            console.info("[FROM crit_alt_num CONNECTION] crit/alt:\t" + crit + "/" + alt)
            if (root.isEl1) {
                if (root.isSimple) {
                    decMatrixSize = Qt.vector2d(crit + 1, alt + 4)
                    superiorityMtxSize = Qt.vector2d(alt + 1, alt + 2)
                    rankingsMtxSize = Qt.vector2d(alt + 1, 3)

                    decMatrixSizePX = decMatrixSize.times(delegateSize)
                    superiorityMtxSizePX = superiorityMtxSize.times(
                                delegateSize)
                    rankingsMtxSizePX = rankingsMtxSize.times(delegateSize)
                    canvasPx = Qt.vector2d(loader_SimpleOrMonte.item.img.width,
                                           loader_SimpleOrMonte.item.img.height)

                    //                    console.info("decMtxSizePX:\t" + decMatrixSizePX
                    //                                 + "\nsuperiorityMtxSizePX:\t" + superiorityMtxSizePX)
                    decMtx_Table.width = decMatrixSizePX.x
                    decMtx_Table.height = decMatrixSizePX.y

                    loader_SimpleOrMonte.item.creddegORsuperiorityMtx.width = superiorityMtxSizePX.x
                    loader_SimpleOrMonte.item.creddegORsuperiorityMtx.height
                            = superiorityMtxSizePX.y

                    loader_SimpleOrMonte.item.preordersAndRankingsMtx.width = rankingsMtxSizePX.x
                    loader_SimpleOrMonte.item.preordersAndRankingsMtx.height = rankingsMtxSizePX.y

                    maxX = Math.max(decMatrixSizePX.x, superiorityMtxSizePX.x,
                                    rankingsMtxSizePX.x, canvasPx.x)

                    maxY = decMtx_Table.y + decMtx_Table.height + superiorityMtxSizePX.y
                            + rankingsMtxSizePX.y + canvasPx.y + 350

                    totalSize = Qt.vector2d(maxX, maxY)

                    scrollView.contentWidth = Math.max(totalSize.x,
                                                       scrollView.contentWidth)
                    scrollView.contentHeight = totalSize.y

                    //                    console.info(
                    //                                "\n\n-----\n\ntotal size: " + totalSize
                    //                                + "\nscrollview content: " + scrollView.contentWidth
                    //                                + "|" + scrollView.contentHeight + "\n------\n")
                } else if (root.isMonte) {
                    decMatrixSize = Qt.vector2d(crit + 1, alt + 4)
                    expectedRankSize = Qt.vector2d(alt + 1, 2)
                    rankAcceptabilitySize = Qt.vector2d(alt + 1, alt + 1)

                    decMatrixSizePX = decMatrixSize.times(delegateSize)
                    expectedRankSizePX = expectedRankSize.times(delegateSize)
                    rankAcceptabilitySizePX = rankAcceptabilitySize.times(
                                delegateSize)

                    decMtx_Table.width = decMatrixSizePX.x
                    decMtx_Table.height = decMatrixSizePX.y

                    loader_SimpleOrMonte.item.expectedRankMtx.width = expectedRankSizePX.x
                    loader_SimpleOrMonte.item.expectedRankMtx.height = expectedRankSizePX.y

                    loader_SimpleOrMonte.item.rankAcceptabilityMtx.width = rankAcceptabilitySizePX.x
                    loader_SimpleOrMonte.item.rankAcceptabilityMtx.height
                            = rankAcceptabilitySizePX.y

                    maxX = Math.max(decMatrixSizePX.x, expectedRankSizePX.x,
                                    rankAcceptabilitySizePX.x)

                    maxY = decMtx_Table.y + decMtx_Table.height
                            + expectedRankSizePX.y + rankAcceptabilitySizePX.y + 350

                    totalSize = Qt.vector2d(maxX, maxY)

                    scrollView.contentWidth = Math.max(totalSize.x,
                                                       scrollView.contentWidth)
                    scrollView.contentHeight = totalSize.y
                }
            } else if (root.isEl3) {
                if (root.isSimple) {
                    decMatrixSize = Qt.vector2d(crit + 1, alt + 6)
                    credDegMtxSize = Qt.vector2d(alt + 1, alt + 1)
                    rankingsMtxSize = Qt.vector2d(alt + 1, 4)

                    decMatrixSizePX = decMatrixSize.times(delegateSize)
                    credDegMtxSizePX = credDegMtxSize.times(delegateSize)
                    rankingsMtxSizePX = rankingsMtxSize.times(delegateSize)
                    canvasPx = Qt.vector2d(loader_SimpleOrMonte.item.img.width,
                                           loader_SimpleOrMonte.item.img.height)

                    decMtx_Table.width = decMatrixSizePX.x
                    decMtx_Table.height = decMatrixSizePX.y

                    loader_SimpleOrMonte.item.creddegORsuperiorityMtx.width = credDegMtxSizePX.x
                    loader_SimpleOrMonte.item.creddegORsuperiorityMtx.height = credDegMtxSizePX.y

                    loader_SimpleOrMonte.item.preordersAndRankingsMtx.width = rankingsMtxSizePX.x
                    loader_SimpleOrMonte.item.preordersAndRankingsMtx.height = rankingsMtxSizePX.y

                    maxX = Math.max(decMatrixSizePX.x, credDegMtxSizePX.x,
                                    rankingsMtxSizePX.x, canvasPx.x)

                    maxY = decMtx_Table.y + decMtx_Table.height + credDegMtxSizePX.y
                            + rankingsMtxSizePX.y + canvasPx.y + 350

                    totalSize = Qt.vector2d(maxX, maxY)

                    scrollView.contentWidth = Math.max(totalSize.x,
                                                       scrollView.contentWidth)
                    scrollView.contentHeight = totalSize.y
                } else if (root.isMonte) {
                    decMatrixSize = Qt.vector2d(crit + 1, alt + 6)
                    expectedRankSize = Qt.vector2d(alt + 1, 2)
                    rankAcceptabilitySize = Qt.vector2d(alt + 1, alt + 1)

                    decMatrixSizePX = decMatrixSize.times(delegateSize)
                    expectedRankSizePX = expectedRankSize.times(delegateSize)
                    rankAcceptabilitySizePX = rankAcceptabilitySize.times(
                                delegateSize)

                    decMtx_Table.width = decMatrixSizePX.x
                    decMtx_Table.height = decMatrixSizePX.y

                    loader_SimpleOrMonte.item.expectedRankMtx.width = expectedRankSizePX.x
                    loader_SimpleOrMonte.item.expectedRankMtx.height = expectedRankSizePX.y

                    loader_SimpleOrMonte.item.rankAcceptabilityMtx.width = rankAcceptabilitySizePX.x
                    loader_SimpleOrMonte.item.rankAcceptabilityMtx.height
                            = rankAcceptabilitySizePX.y

                    maxX = Math.max(decMatrixSizePX.x, expectedRankSizePX.x,
                                    rankAcceptabilitySizePX.x)

                    maxY = decMtx_Table.y + decMtx_Table.height
                            + expectedRankSizePX.y + rankAcceptabilitySizePX.y + 350

                    totalSize = Qt.vector2d(maxX, maxY)

                    scrollView.contentWidth = Math.max(totalSize.x,
                                                       scrollView.contentWidth)
                    scrollView.contentHeight = totalSize.y
                }
            }
        }
    }

    //    // workaroiund for signal handling from python
    //    signal reemitCriAltNum(var altCritNum)
    //    signal reGetResultsModels
    //    // signal to send to python for refining
    //    signal sendModels(var models)
    //    signal reSvgSrc(string src)

    //    property bool isEl1: false
    //    property bool isEl3: !isEl1
    //    property bool isSimple: false
    //    property bool isMonte: !isSimple

    //    Component.onCompleted: {
    //        comm.crit_alt_num.connect(reemitCriAltNum)
    //        comm.get_results_models.connect(reGetResultsModels)
    //        comm.svg_src.connect(reSvgSrc)
    //    }

    //    onReSvgSrc: function (src) {
    //        var source = "data:image/svg+xml," + encodeURIComponent(src)
    //        loader_SimpleOrMonte.item.img.source = source
    //    }

    //    onReemitCriAltNum: {
    //        var alt = altCritNum[0]
    //        var crit = altCritNum[1]
    //        var delegateSize = Qt.vector2d(100, 30)
    //        var decMatrixSize = 0
    //        var superiorityMtxSize = 0
    //        var decMatrixSizePX = 0
    //        var superiorityMtxSizePX = 0
    //        var credDegMtxSize = 0
    //        var credDegMtxSizePX
    //        var expectedRankSize = 0
    //        var rankAcceptabilitySize = 0
    //        var rankAcceptabilitySizePX = 0
    //        var expectedRankSizePX = 0
    //        var rankingsMtxSize = 0
    //        var rankingsMtxSizePX = 0
    //        var canvasPx = 0

    //        var maxX = 0
    //        var maxY = 0
    //        var totalSize = 0

    //        //console.log("\n-----\nMODEL:\t" + model + "\n-----\n-----")
    //        //        console.info("\ncrit/alt:\t" + crit + "/" + alt)
    //        if (isEl1) {
    //            if (isSimple) {
    //                decMatrixSize = Qt.vector2d(crit + 1, alt + 4)
    //                superiorityMtxSize = Qt.vector2d(alt + 1, alt + 2)
    //                rankingsMtxSize = Qt.vector2d(alt + 1, 3)

    //                decMatrixSizePX = decMatrixSize.times(delegateSize)
    //                superiorityMtxSizePX = superiorityMtxSize.times(delegateSize)
    //                rankingsMtxSizePX = rankingsMtxSize.times(delegateSize)
    //                canvasPx = Qt.vector2d(loader_SimpleOrMonte.item.img.width,
    //                                       loader_SimpleOrMonte.item.img.height)
    //                console.info("decMtxSizePX:\t" + decMatrixSizePX
    //                             + "\nsuperiorityMtxSizePX:\t" + superiorityMtxSizePX)

    //                decMtx_Table.width = decMatrixSizePX.x
    //                decMtx_Table.height = decMatrixSizePX.y

    //                loader_SimpleOrMonte.item.creddegORsuperiorityMtx.width = superiorityMtxSizePX.x
    //                loader_SimpleOrMonte.item.creddegORsuperiorityMtx.height = superiorityMtxSizePX.y

    //                loader_SimpleOrMonte.item.preordersAndRankingsMtx.width = rankingsMtxSizePX.x
    //                loader_SimpleOrMonte.item.preordersAndRankingsMtx.height = rankingsMtxSizePX.y

    //                maxX = Math.max(decMatrixSizePX.x, superiorityMtxSizePX.x,
    //                                rankingsMtxSizePX.x, canvasPx.x)

    //                maxY = decMtx_Table.y + decMtx_Table.height + superiorityMtxSizePX.y
    //                        + rankingsMtxSizePX.y + canvasPx.y + 350

    //                totalSize = Qt.vector2d(maxX, maxY)

    //                scrollView.contentWidth = Math.max(totalSize.x,
    //                                                   scrollView.contentWidth)
    //                scrollView.contentHeight = totalSize.y

    //                console.info(
    //                            "\n\n-----\n\ntotal size: " + totalSize
    //                            + "\nscrollview content: " + scrollView.contentWidth
    //                            + "|" + scrollView.contentHeight + "\n------\n")
    //            } else if (isMonte) {
    //                decMatrixSize = Qt.vector2d(crit + 1, alt + 4)
    //                expectedRankSize = Qt.vector2d(alt + 1, 2)
    //                rankAcceptabilitySize = Qt.vector2d(alt + 1, alt + 1)

    //                decMatrixSizePX = decMatrixSize.times(delegateSize)
    //                expectedRankSizePX = expectedRankSize.times(delegateSize)
    //                rankAcceptabilitySizePX = rankAcceptabilitySize.times(
    //                            delegateSize)

    //                decMtx_Table.width = decMatrixSizePX.x
    //                decMtx_Table.height = decMatrixSizePX.y

    //                loader_SimpleOrMonte.item.expectedRankMtx.width = expectedRankSizePX.x
    //                loader_SimpleOrMonte.item.expectedRankMtx.height = expectedRankSizePX.y

    //                loader_SimpleOrMonte.item.rankAcceptabilityMtx.width = rankAcceptabilitySizePX.x
    //                loader_SimpleOrMonte.item.rankAcceptabilityMtx.height = rankAcceptabilitySizePX.y

    //                maxX = Math.max(decMatrixSizePX.x, expectedRankSizePX.x,
    //                                rankAcceptabilitySizePX.x)

    //                maxY = decMtx_Table.y + decMtx_Table.height
    //                        + expectedRankSizePX.y + rankAcceptabilitySizePX.y + 350

    //                totalSize = Qt.vector2d(maxX, maxY)

    //                scrollView.contentWidth = Math.max(totalSize.x,
    //                                                   scrollView.contentWidth)
    //                scrollView.contentHeight = totalSize.y
    //            }
    //        } else if (isEl3) {
    //            if (isSimple) {
    //                decMatrixSize = Qt.vector2d(crit + 1, alt + 6)
    //                credDegMtxSize = Qt.vector2d(alt + 1, alt + 1)
    //                rankingsMtxSize = Qt.vector2d(alt + 1, 4)

    //                decMatrixSizePX = decMatrixSize.times(delegateSize)
    //                credDegMtxSizePX = credDegMtxSize.times(delegateSize)
    //                rankingsMtxSizePX = rankingsMtxSize.times(delegateSize)
    //                canvasPx = Qt.vector2d(loader_SimpleOrMonte.item.img.width,
    //                                       loader_SimpleOrMonte.item.img.height)

    //                decMtx_Table.width = decMatrixSizePX.x
    //                decMtx_Table.height = decMatrixSizePX.y

    //                loader_SimpleOrMonte.item.creddegORsuperiorityMtx.width = credDegMtxSizePX.x
    //                loader_SimpleOrMonte.item.creddegORsuperiorityMtx.height = credDegMtxSizePX.y

    //                loader_SimpleOrMonte.item.preordersAndRankingsMtx.width = rankingsMtxSizePX.x
    //                loader_SimpleOrMonte.item.preordersAndRankingsMtx.height = rankingsMtxSizePX.y

    //                maxX = Math.max(decMatrixSizePX.x, credDegMtxSizePX.x,
    //                                rankingsMtxSizePX.x, canvasPx.x)

    //                maxY = decMtx_Table.y + decMtx_Table.height + credDegMtxSizePX.y
    //                        + rankingsMtxSizePX.y + canvasPx.y + 350

    //                totalSize = Qt.vector2d(maxX, maxY)

    //                scrollView.contentWidth = Math.max(totalSize.x,
    //                                                   scrollView.contentWidth)
    //                scrollView.contentHeight = totalSize.y
    //            } else if (isMonte) {
    //                decMatrixSize = Qt.vector2d(crit + 1, alt + 6)
    //                expectedRankSize = Qt.vector2d(alt + 1, 2)
    //                rankAcceptabilitySize = Qt.vector2d(alt + 1, alt + 1)

    //                decMatrixSizePX = decMatrixSize.times(delegateSize)
    //                expectedRankSizePX = expectedRankSize.times(delegateSize)
    //                rankAcceptabilitySizePX = rankAcceptabilitySize.times(
    //                            delegateSize)

    //                decMtx_Table.width = decMatrixSizePX.x
    //                decMtx_Table.height = decMatrixSizePX.y

    //                loader_SimpleOrMonte.item.expectedRankMtx.width = expectedRankSizePX.x
    //                loader_SimpleOrMonte.item.expectedRankMtx.height = expectedRankSizePX.y

    //                loader_SimpleOrMonte.item.rankAcceptabilityMtx.width = rankAcceptabilitySizePX.x
    //                loader_SimpleOrMonte.item.rankAcceptabilityMtx.height = rankAcceptabilitySizePX.y

    //                maxX = Math.max(decMatrixSizePX.x, expectedRankSizePX.x,
    //                                rankAcceptabilitySizePX.x)

    //                maxY = decMtx_Table.y + decMtx_Table.height
    //                        + expectedRankSizePX.y + rankAcceptabilitySizePX.y + 350

    //                totalSize = Qt.vector2d(maxX, maxY)

    //                scrollView.contentWidth = Math.max(totalSize.x,
    //                                                   scrollView.contentWidth)
    //                scrollView.contentHeight = totalSize.y
    //            }
    //        }
    //    }

    //    onReGetResultsModels: {

    //        var decMtxModel = data_entry.table_custom.view.model
    //        decMtx_Table.view.model = decMtxModel

    //        var expectedMtxModel
    //        var acceptabilityMtxModel

    //        var models

    //        if (isEl1) {
    //            if (isSimple) {
    //                var SuperiorityMtxModel = loader_SimpleOrMonte.item.creddegORsuperiorityMtx.view.model
    //                var rankingMtxModel = loader_SimpleOrMonte.item.preordersAndRankingsMtx.view.model

    //                models = [SuperiorityMtxModel, rankingMtxModel]
    //                // send models to python
    //                root.sendModels(models)
    //            } else if (isMonte) {
    //                expectedMtxModel = loader_SimpleOrMonte.item.expectedRankMtx.view.model
    //                acceptabilityMtxModel = loader_SimpleOrMonte.item.rankAcceptabilityMtx.view.model

    //                models = [expectedMtxModel, acceptabilityMtxModel]
    //                //send to python
    //                root.sendModels(models)
    //            }
    //        } else if (isEl3) {
    //            if (isSimple) {
    //                var credDegMtxModel = loader_SimpleOrMonte.item.creddegORsuperiorityMtx.view.model
    //                var preordersAndRankingsMtxModel = loader_SimpleOrMonte.item.preordersAndRankingsMtx.view.model

    //                models = [credDegMtxModel, preordersAndRankingsMtxModel]
    //                // send to py
    //                root.sendModels(models)
    //            } else if (isMonte) {
    //                expectedMtxModel = loader_SimpleOrMonte.item.expectedRankMtx.view.model
    //                acceptabilityMtxModel = loader_SimpleOrMonte.item.rankAcceptabilityMtx.view.model

    //                models = [expectedMtxModel, acceptabilityMtxModel]
    //                //send to python
    //                root.sendModels(models)
    //            }
    //        }
    //    }
}
