import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: topBanner
    width: parent.width
    height: parent.height * (1/13)
    color: "black"

    SearchBar {
        id: searchBar
        anchors.centerIn: parent
    }

    Row {
        anchors.verticalCenter: searchBar.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 15  // Space between buttons


        // Restock Button
        Rectangle {
            id: restockButton
            height: searchBar.height
            width: restockIcon.width + restockText.contentWidth + 20
            color: "transparent"
            border.color: "transparent"
            border.width: 2
            radius: 5

            Row {
                anchors.centerIn: parent
                spacing: 5

                Image {
                    id: restockIcon
                    height: parent.height * 0.8
                    width: height
                }

                Text {
                    id: restockText
                    text: "Restock"
                    font.pixelSize: searchBar.height * 0.5
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: restockButton.border.color = "white"
                onExited: restockButton.border.color = "transparent"
                onClicked: {
                    restockPopup.open();
                }


            }
        }

        // RestockView Component
        ShowRestock {
            id: restockPopup
            parent: topBanner.parent  // Attach to main window
            x: parent.width - width  // Position it on the right

        }

        // Orders Button
        Rectangle {
            id: ordersButton
            height: searchBar.height
            width: ordersIcon.width + ordersText.contentWidth + 20
            color: "transparent"
            border.color: "transparent"
            border.width: 2
            radius: 5

            Row {
                anchors.centerIn: parent
                spacing: 5

                Image {
                    id: ordersIcon
                    height: parent.height * 0.8
                    width: height
                }

                Text {
                    id: ordersText
                    text: "Orders"
                    font.pixelSize: searchBar.height * 0.5
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ordersButton.border.color = "white"
                onExited: ordersButton.border.color = "transparent"
                onClicked: {
                    orderModel.clear();
                    var orders = orderManager.getPlacedOrders();

                    if (orders.length === 0) {
                        console.log("No orders found");
                    }

                    for (var i = 0; i < orders.length; i++) {
                        orderModel.append(orders[i]);
                    }

                    orderPopup.open();
                }


            }
        }



        // OrderView Component
        ShowAllOrders {
            id: orderPopup
            parent: topBanner.parent  // Attach to main window
            x: parent.width - width  // Position it on the right

        }


        // Cart Button
        Rectangle {
            id: cartButton
            height: searchBar.height
            width: cartIcon.width + cartText.contentWidth + 20
            color: "transparent"
            border.color: "transparent"
            border.width: 2
            radius: 5

            Row {
                anchors.centerIn: parent
                spacing: 5

                Image {
                    id: cartIcon
                    source: "qrc:/images/cart.png"
                    height: parent.height
                    width: height
                }

                Text {
                    id: cartText
                    text: "Cart"
                    font.pixelSize: searchBar.height * 0.5
                    color: "white"
                }
            }


            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: cartButton.border.color = "white"
                onExited: cartButton.border.color = "transparent"
                onClicked: {
                    cartModel.clear();
                    var cartItems = cartManager.getCartItems();

                    if (cartItems.length === 0) {
                        console.log("No Items found in the Cart");
                    }

                    for (var i = 0; i < cartItems.length; i++) {
                        cartModel.append(cartItems[i]);
                    }

                    cartPopup.open();
                }


            }
        }

        // CartView Component
        ShowAllCartItems {
            id: cartPopup
            parent: topBanner.parent  // Attach to main window
            x: parent.width - width  // Position it on the right

        }

    }

    Row {
        anchors.verticalCenter: searchBar.verticalCenter
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 15  // Space between elements

        // STM Logo
        Image {
            id: stmLogo
            source: "qrc:/images/stm.png"
            width: searchBar.width/6
            height: searchBar.height
        }

        // Location Button
        Rectangle {
            id: locationButton
            height: searchBar.height
            width: locationIcon.width + locationText.contentWidth + 30  // Adjust width dynamically
            color: "transparent"
            border.color: "transparent"
            border.width: 2
            radius: 5

            Row {
                anchors.centerIn: parent
                spacing: 5

                Image {
                    id: locationIcon
                    source: "qrc:/images/location.png"
                    height: parent.height * 0.8
                    width: height
                }

                Text {
                    id: locationText
                    text: "Deliver to New Cairo"
                    font.pixelSize: searchBar.height * 0.5
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: locationButton.border.color = "white"
                onExited: locationButton.border.color = "transparent"
                onClicked: console.log("Location button clicked")
            }
        }
    }
}
