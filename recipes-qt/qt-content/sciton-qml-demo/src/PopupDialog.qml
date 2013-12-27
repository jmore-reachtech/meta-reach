import QtQuick 1.0

Rectangle {
    id: trans
    width: 1024
    height: 768
    color: "transparent"

    MouseArea {
        id: mouse_area1
        anchors.fill: parent
    }

    Rectangle {
        id: container
        width: 640
        height: 480
        color: "#f7f246"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        PopupDialog_VM {
            id: s0vm
            objectName: "s0vm"
        }

        Rectangle {
            id: inner
            width: 620
            height: 460
            color: "white"
            border.width: 5
            border.color: "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: textMessage1
                x: 50
                y: 11
                width: 600
                height: 41
                color: "black"
                text: s0vm.popupMessage1
                wrapMode: Text.WordWrap
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 17
                smooth: true
                onTextChanged: {
                    console.log('popupMessage1 text updated');
                    s0vm.ackPopupMessage1Change();
                }
            }

            Text {
                id: textMessage2
                x: 50
                y: 61
                width: 600
                height: 41
                color: "black"
                text: s0vm.popupMessage2
                wrapMode: Text.WordWrap
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 25
                smooth: true
                onTextChanged: {
                    console.log('popupMessage2 text updated');
                    s0vm.ackPopupMessage2Change();
                }
            }

            Text {
                id: textMessage3
                x: 50
                y: 111
                width: 600
                height: 41
                color: "black"
                text: s0vm.popupMessage3
                wrapMode: Text.WordWrap
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 17
                smooth: true
                onTextChanged: {
                    console.log('popupMessage3 text updated');
                    s0vm.ackPopupMessage3Change();
                }
            }

            Text {
                id: textMessage4
                x: 50
                y: 161
                width: 600
                height: 41
                color: "black"
                text: s0vm.popupMessage4
                wrapMode: Text.WordWrap
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 17
                smooth: true
                onTextChanged: {
                    console.log('popupMessage4 text updated');
                    s0vm.ackPopupMessage4Change();
                }
            }

            Text {
                id: textMessage5
                x: 50
                y: 211
                width: 600
                height: 41
                color: "black"
                text: s0vm.popupMessage5
                wrapMode: Text.WordWrap
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: false
                font.family: "Arial"
                styleColor: "#000000"
                font.pixelSize: 17
                smooth: true
                onTextChanged: {
                    console.log('popupMessage5 text updated');
                    s0vm.ackPopupMessage5Change();
                }
            }

            // Back Button
            ScitonImageButton {
                id: btnBack
                x: 288
                y: 398
                width: 72
                height: 46
                anchors.horizontalCenter: parent.horizontalCenter
                imageOn: "Images/100_BackEn.bmp"
                imageOff: "Images/099_Back.bmp"
                imageDisabled: "Images/099_Back.bmp"
                enabled: s0vm.backVisible == 1
                visible: s0vm.backVisible == 1
                onButtonClick: {
                    s0vm.backSelection();
                }
                onEnabledChanged: {
                    console.log('back button visible updated');
                    s0vm.ackBackVisibleChange();
                }
            }

        }
    }
}
