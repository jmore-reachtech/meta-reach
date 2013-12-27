import QtQuick 1.0

Rectangle {
    id: rectangle1

    property alias enabled: mouse_area1.enabled
    property alias imageStandbyOn: border_image1.source
    property alias imageStandbyOff: border_image2.source
    property alias imageReadyOn: border_image3.source
    property alias imageReadyOff: border_image4.source
    property alias imageReadyFlashingOn: border_image5.source
    property alias imageReadyFlashingOff: border_image6.source
    property alias imageTreatOn: border_image7.source
    property alias imageTreatOff: border_image8.source

    property bool useFlashImage: false
    property int mode: 0
    signal modeChange(int value)
    onModeChange : {
        console.log("onModeChange");
        if (mode == 2)
        {
            useFlashImage = true;
            intervalTimer.restart();
        }
        else
        {
            intervalTimer.stop();
            useFlashImage = false;
        }
    }
    property int flashInterval : 500

    width: 137
    height: 126

    signal buttonClick()
    onButtonClick: {
    }

    Timer {
        id: intervalTimer
        interval: flashInterval;
        running: true;
        repeat: true;
        onTriggered: {
            useFlashImage = !useFlashImage;
        }
    }

    BorderImage {
        id: border_image1
        visible: mouse_area1.enabled && mouse_area1.pressed && (mode == 0)
    }

    BorderImage {
        id: border_image2
        visible: mouse_area1.enabled && !mouse_area1.pressed && (mode == 0)
    }

    BorderImage {
        id: border_image3
        visible: mouse_area1.enabled && mouse_area1.pressed && ((mode == 1) || (mode == 2 && !useFlashImage))
    }

    BorderImage {
        id: border_image4
        visible: mouse_area1.enabled && !mouse_area1.pressed && ((mode == 1) || (mode == 2 && !useFlashImage))
    }

    BorderImage {
        id: border_image5
        visible: mouse_area1.enabled && mouse_area1.pressed && (mode == 2 && useFlashImage)
    }

    BorderImage {
        id: border_image6
        visible: mouse_area1.enabled && !mouse_area1.pressed && (mode == 2 && useFlashImage)
    }

    BorderImage {
        id: border_image7
        visible: mouse_area1.enabled && mouse_area1.pressed && (mode == 3)
    }

    BorderImage {
        id: border_image8
        visible: mouse_area1.enabled && !mouse_area1.pressed && (mode == 3)
    }


    MouseArea {
        id: mouse_area1
        anchors.fill: parent
        onPressed: buttonClick()
    }
}
