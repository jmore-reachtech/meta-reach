import QtQuick 1.0
import "Reach/ReachConnection.js" as ReachConnection
import "Reach/ScitonIDs.js" as ScitonIDs

Rectangle {
    id: rectangle1
    width: 1024
    height: 768

    MainView_VM {
        id: mainvm
        objectName: "mainvm"
    }

    StartMenu {
        id: s1
        visible: mainvm.s1 == 1
        onVisibleChanged: {
            mainvm.ackS1Change();
        }
    }

    ClearScan_YAG_1064_nm {
        id: s99
        visible: mainvm.s99 == 1
        onVisibleChanged: {
            mainvm.ackS99Change();
        }
    }

    PopupDialog {
        id: s0
        x: 168
        y: 58
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: mainvm.s0 == 1
        onVisibleChanged: {
            mainvm.ackS0Change();
        }
    }

    ReachSimulator {
        id: sim
        x: 126
        y: 672
        visible: false
    }
}
