import QtQuick 1.0

Rectangle {
    id: rectangle1

    width: 58
    height: 46

    property alias enabled: mouse_area1.enabled
    property int offset : 0

    signal buttonClick()
    onButtonClick: {
    }

    BorderImage {
        id: border_imageCenter
        source: "Images/243_Pattern1Ctr.bmp"
        visible: offset == 0
    }

    BorderImage {
        id: border_imageUpLeft
        source: "Images/244_Pattern1UpLft.bmp"
        visible: offset == 1
    }

    BorderImage {
        id: border_imageUpCenter
        source: "Images/245_Pattern1UpCtr.bmp"
        visible: offset == 2
    }

    BorderImage {
        id: border_imageUpRight
        source: "Images/246_Pattern1UpRight.bmp"
        visible: offset == 3
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent
        onPressed: buttonClick()
    }
}
