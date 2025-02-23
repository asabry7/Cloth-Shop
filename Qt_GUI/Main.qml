import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: mainWindow
    width: 1920
    height: 1280
    visible: true
    title: qsTr("STM IPC Task")

    TopBanner { id: topBanner }
    ListModel { id: orderModel }
    ListModel { id: cartModel }

    Image {
        id: ramadanBanner
        source: "qrc:/images/RAM.jpg"
        width: parent.width
        height: parent.height / 4
        anchors.top: topBanner.bottom
        anchors.margins: 10
    }

    Items {
        id: productGrid
        anchors.top: ramadanBanner.bottom
        anchors.margins: 10
    }
}
