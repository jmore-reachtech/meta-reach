import QtQuick 1.0

MouseArea {
    property int repeatDelay : 1000
    property int repeatInterval : 250

    signal firstClick();
    signal repeatClick();

    onClicked: {
    }

    onPressed: {
        firstClick();
        intervalTimer.stop();
        delayTimer.restart();
    }

    onReleased: {
        intervalTimer.stop();
        delayTimer.stop();
    }

    Timer {
        id: intervalTimer
        interval: repeatInterval;
        running: false;
        repeat: true;
        onTriggered: {
            repeatClick();
        }
    }

    Timer {
        id: delayTimer
        interval: repeatDelay;
        running: false;
        repeat: false;
        onTriggered: {
            repeatClick();
            intervalTimer.restart();
        }
    }
}
