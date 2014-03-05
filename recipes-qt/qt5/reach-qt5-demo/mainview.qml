import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    width: 640
    height: 480
    color: "gray"

    property var myString: "SHFL Deals Winners!"
    // this is the background video
    Video{
        id: video
        source: "/application/src/Wildlife.m4v"
        width: 800 
        height: 600
        anchors.centerIn: parent
        muted: true
        onStopped: video.play();
    }

    // This is the drop shadow "dark gray" text
    Text {
        id: text1
        anchors.centerIn: parent
        color: "#111111"
        text: qsTr(myString)
        font.pixelSize: 1

        SmoothedAnimation on font.pixelSize {
                  id: textAnimation1
                  to: 80;
                  velocity: 50
                  running: false

                  onStopped: textAnimation2.start();
        }

        SmoothedAnimation on font.pixelSize {
                  id: textAnimation2
                  to: 30;
                  velocity: 50
                  running: false

                  onStopped: {
                      textAnimation3.start();
                  }
        }

        SmoothedAnimation on rotation {
                  id: textAnimation3
                  to: 360;
                  velocity: 200
                  running: false

                  onStopped: textAnimation4.start();
        }

        SmoothedAnimation on rotation {
                  id: textAnimation4
                  to: 0;
                  velocity: 200
                  running: false

                  onStopped: textAnimation1.start();
        }
    }

    // This is the main "white" text
    Text { 
        id: text2
        anchors.left: text1.left
        anchors.leftMargin: 3
        anchors.top: text1.top
        anchors.topMargin: 3
        color: "#ffffff"
        text: qsTr(myString)
        font.pixelSize: 1

        SmoothedAnimation on font.pixelSize {
                  id: textAnimation12
                  to: 80;
                  velocity: 50
                  running: false

                  onStopped: textAnimation22.start();
        }

        SmoothedAnimation on font.pixelSize {
                  id: textAnimation22
                  to: 30;
                  velocity: 50
                  running: false

                  onStopped: {
                      textAnimation32.start();
                  }
        }

        SmoothedAnimation on rotation {
                  id: textAnimation32
                  to: 360;
                  velocity: 200
                  running: false

                  onStopped: textAnimation42.start();
        }

        SmoothedAnimation on rotation {
                  id: textAnimation42
                  to: 0;
                  velocity: 200
                  running: false

                  onStopped: textAnimation12.start();
        }
    }





    Component.onCompleted: {
        video.play()
        textAnimation1.start();
        textAnimation12.start();
    }




}

