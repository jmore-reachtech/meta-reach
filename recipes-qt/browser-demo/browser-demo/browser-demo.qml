import QtQuick 2.4
import QtQuick.Window 2.2
import QtWebEngine 1.1

Window {
    visible: true
    visibility: Window.FullScreen
    color: "black"


    WebEngineView {
        id: webView
        anchors.fill: parent
        url: "http://www.ossystems.com.br"
        }
}
