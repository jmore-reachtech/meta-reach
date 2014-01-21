import QtQuick 1.0

Rectangle {
    id: rectangle1
    property alias enabled: mouse_area1.enabled
    property alias imageOn: border_image1.source
    property alias imageOff: border_image2.source
    property alias imageDisabled: border_image3.source
    property string initMessage: "none"

    width: 137
    height: 126

    signal buttonClick()
    onButtonClick: {
    }

    BorderImage {
        id: border_image1
        visible: mouse_area1.enabled && mouse_area1.pressed
    }

    BorderImage {
        id: border_image2
        visible: mouse_area1.enabled && !mouse_area1.pressed
    }

    BorderImage {
        id: border_image3
        visible: !mouse_area1.enabled
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent
        onPressed: buttonClick()
    }
}
