import QtQuick 1.0

Image {
    id: container
    width: 1024
    height: 768
    source: "Images/001_Logo.bmp"

    StartMenu_VM {
        id: s1vm
        objectName: "s1vm"
    }

    ScitonImageButton {
        id: btnScanner
        x: 444
        y: 337
        width: 219
        height: 202
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: true
        imageOn: "Images/335_Clear_Scanx.bmp"
        imageOff: "Images/334_Clear_Scan.bmp"
        onButtonClick: {
            s1vm.proceedToTestScreen();
        }
    }
}
