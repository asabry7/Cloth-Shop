import QtQuick 2.15
import QtQuick.Controls 2.15


Popup {
    id: orderPopup

    width: 400
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside


    background: Rectangle {
        color: "white"
        radius: 10
        border.color: "#ccc"
        border.width: 1
    }

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Text {
            text: "Placed Orders"
            font.bold: true
            font.pixelSize: 18
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ListView {
            id: orderList
            width: parent.width
            height: parent.height - 50
            clip: true
            model: orderModel

            delegate: Rectangle {
                width: orderList.width
                height: 60
                color: "white"
                border.color: "#ddd"
                border.width: 1
                radius: 5

                Row {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Image {
                        source: model.image
                        width: 40
                        height: 40
                        fillMode: Image.PreserveAspectFit
                    }

                    Column {
                        Text {
                            text: model.name
                            font.bold: true
                            color: "black"
                        }
                        Text {
                            text: model.price
                            color: "green"
                        }
                    }

                    Rectangle{
                        width: parent.width/3
                        height: width

                    }

                    Text {
                        text: "Quantity"
                        font.bold: true
                        color: "black"
                    }

                    Text {
                        id: quantity
                        text: model.quantity
                        font.bold: true
                        color: "black"
                    }

                }
            }
        }
    }
}
