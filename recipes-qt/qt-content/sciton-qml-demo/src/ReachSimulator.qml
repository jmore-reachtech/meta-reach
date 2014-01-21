import QtQuick 1.0

Rectangle {
    width: 280
    height: 75
    color: "#b9a7a7"
    border.width: 5
    border.color: "#000000"

    Text {
        id: propIDLabel
        x: 154
        y: 7
        text: "Property ID"
    }
    TextInput {
        id: propID
        x: 222
        y: 7
        width: 50
        height: 13
    }
    Text {
        id: propValueLabel
        x: 140
        y: 31
        text: "Property Value"
    }
    TextInput {
        id: propValue
        x: 222
        y: 30
        width: 50
    }
    TextButton {
        id: btnSendProp
        x: 162
        y: 51
        text: "Send Property"
        onClicked: {

        }
    }

    Text {
        id: screenIDLabel
        x: 24
        y: 7
        text: "Screen ID"
    }
    TextInput {
        id: screenID
        x: 82
        y: 7
        width: 50
        height: 13
    }
    Text {
        id: screenValueLabel
        x: 10
        y: 30
        text: "Screen Value"
    }
    TextInput {
        id: screenValue
        x: 82
        y: 30
        width: 50
    }
    TextButton {
        id: btnSendScreen
        x: 36
        y: 51
        text: "Send Screen"
        onClicked: {

        }
    }

}
