import QtQuick 2.8
import QtMultimedia 5.8

Rectangle {
    width: 1024
    height: 768
    color: "black"


    SoundEffect {
        id: beep
        source: "/application/src/audio/beep.wav"
    }

    Image {
        asynchronous: true
        width: 600
        height: 400
        anchors.centerIn: parent
        source: "/application/src/images/qt_logo.png"

        MouseArea {
            id: playArea
            anchors.fill: parent
            onPressed: { beep.play() }
        }
    }

}
