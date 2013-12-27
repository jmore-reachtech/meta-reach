import QtQuick 1.0

Rectangle {
    id: rectangle1

    width: 58
    height: 46

    property alias enabled: mouse_area1.enabled
    property int repeat : 0

    signal buttonClick()
    onButtonClick: {
    }

    BorderImage {
        id: border_imageOff
        source: "Images/030_NdYag_RepeatOFF.bmp"
        visible: (repeat < 1) || (repeat > 5)
    }

    BorderImage {
        id: border_imageRepeat1
        source: "Images/025_NdYag_Repeat1.bmp"
        visible: repeat == 1
    }

    BorderImage {
        id: border_imageRepeat2
        source: "Images/026_NdYag_Repeat2.bmp"
        visible: repeat == 2
    }

    BorderImage {
        id: border_imageRepeat3
        source: "Images/027_NdYag_Repeat3.bmp"
        visible: repeat == 3
    }

    BorderImage {
        id: border_imageRepeat4
        source: "Images/028_NdYag_Repeat4.bmp"
        visible: repeat == 4
    }

    BorderImage {
        id: border_imageRepeat5
        source: "Images/029_NdYag_Repeat5.bmp"
        visible: repeat == 5
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent
        onPressed: buttonClick()
    }
}
