import QtQuick 2.9

Rectangle {
    color: "#222222"
    width: 1024
    height: 768

    Component.onCompleted: {
        beeper.init();
        beeper.openwave("/application/src/audio/beep.wav");
    }
    
    Rectangle {
        id: box1
        x: 126
        y: 131
        width: 125
        height: 50
        color: "#729fcf"
        
        Text {
            id: btn1
            y: 12
            height: 25
            text: qsTr("Button 1")
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            font.pixelSize: 20
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                box1.color = "white"
                beeper.play()
            }
            onReleased: {
                box1.color = "#729fcf"
            }
            onClicked: {
                connection.sendMessage("button1.value=1")
            }
        }
    }
    
    Rectangle {
        id: box3
        x: 779
        y: 131
        width: 125
        height: 50
        color: "#729fcf"
        
        Text {
            id: btn3
            y: 12
            height: 25
            text: qsTr("Button 3")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                box3.color = "white"
                beeper.play()
            }
            onReleased: {
                box3.color = "#729fcf"
            }
            onClicked: {
                connection.sendMessage("button3.value=3")
            }
        }
    }
    
    Rectangle {
        id: box2
        x: 450
        y: 270
        width: 125
        height: 50
        color: "#729fcf"
        
        Text {
            id: btn2
            y: 12
            height: 25
            text: qsTr("Button 2")
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            font.pixelSize: 20
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                box2.color = "white"
                beeper.play()
            }
            onReleased: {
                box2.color = "#729fcf"
            }
            onClicked: {
                connection.sendMessage("button2.value=1")
            }
        }
    }

    Text {
        id: element
        x: 126
        y: 476
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("Reading 1:")
        font.pixelSize: 24
    }

    Text {
        id: element1
        objectName: "reading1"
        x: 257
        y: 476
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("---")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
    }

    Text {
        id: element2
        x: 126
        y: 524
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("Reading 2:")
        font.pixelSize: 24
    }

    Text {
        id: element3
        objectName: "reading2"
        x: 257
        y: 524
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("---")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
    }

    Text {
        id: element4
        x: 126
        y: 571
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("Reading 3:")
        font.pixelSize: 24
    }

    Text {
        id: element5
        objectName: "reading3"
        x: 257
        y: 571
        width: 125
        height: 34
        color: "#ffffff"
        text: qsTr("---")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
    }
}
