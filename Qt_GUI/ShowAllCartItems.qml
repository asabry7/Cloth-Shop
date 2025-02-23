import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: cartPopup

    width: 400
    height: 350
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
            text: "Cart Items"
            font.bold: true
            font.pixelSize: 18
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ListView {
            id: cartList
            width: parent.width
            height: parent.height - 90
            clip: true
            model: cartModel

            delegate: Rectangle {
                width: cartList.width
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

                    Rectangle {
                        width: parent.width / 3
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

        Button {
            text: "Place the Order"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.8
            height: 40
            background: Rectangle {
                color: "blue"
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                console.log("Placing order... Clearing cart.");

                for (var i = 0; i < cartModel.count; i++) {
                    var item = cartModel.get(i);

                    var orderItem = {
                        "name": item.name,
                        "price": item.price,
                        "image": item.image,
                        "quantity": item.quantity
                    };
                    orderManager.addPlacedOrder(orderItem)
                }
                cartModel.clear();   // Clear the ListModel in QML
                cartManager.clearCart();  // Clear cartItems in C++
                cartPopup.close();
            }
        }


    }
}
