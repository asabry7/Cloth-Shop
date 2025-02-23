import QtQuick 2.15
import QtQuick.Controls 2.15

GridView {
    id: productGrid
    width: parent.width
    height: parent.height - topBanner.height
    cellWidth: width / 5
    cellHeight: cellWidth * 1.2
    clip: true

    model: ListModel { id: productModel }
    property var allItems: []  // Store all items to reset after filtering


    // Connect to the databaseUpdated signal
    Connections {
        target: databaseLoader
        function onDatabaseUpdated() {
            // Reload data when the database is updated
            var items = databaseLoader.loadClothes();
            allItems = items;  // Save all items for filtering
            updateModel(allItems);
        }
    }



    Component.onCompleted: {
        var items = databaseLoader.loadClothes();
        allItems = items;  // Save all items for filtering
        updateModel(allItems);
    }

    function updateModel(items) {
        productModel.clear();
        for (var i = 0; i < items.length; i++) {
            productModel.append(items[i]);
        }
    }

    delegate: Rectangle {
        width: productGrid.cellWidth * 0.9
        height: productGrid.cellHeight * 0.9
        color: "white"
        radius: 10
        border.color: "#ddd"
        border.width: 1
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Image {
                source: model.image
                width: parent.width * 0.9
                height: width
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: model.name
                font.pixelSize: 16
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Price: " + model.price
                font.pixelSize: 14
                color: "green"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Stock: " + model.stock
                font.pixelSize: 14
                color: "red"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                contextMenu.itemName = model.name;
                contextMenu.itemPrice = model.price;
                contextMenu.itemImage = model.image;
                contextMenu.itemStock = parseInt(model.stock);
                contextMenu.popup();
            }
        }
    }

    Menu {
        id: contextMenu
        width: 200

        property string itemName
        property string itemPrice
        property string itemImage
        property int itemStock
        property string actionType // "cart" or "order"

        background: Rectangle {
            color: "white"
            radius: 8
            border.color: "black"
            border.width: 3
        }

        MenuItem {
            text: "Place an Order"
            contentItem: Text {
                text: parent.text
                font.bold: true
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onTriggered: {
                contextMenu.actionType = "order";
                quantityDialog.open();
            }
        }

        MenuItem {
            text: "Add to Cart"
            contentItem: Text {
                text: parent.text
                font.bold: true
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onTriggered: {
                contextMenu.actionType = "cart";
                quantityDialog.open();
            }
        }
    }

    Dialog {
        id: quantityDialog
        title: "Enter Quantity"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        background: Rectangle {
            color: "white"
        }

        // Center the dialog in the main window
        x: (mainWindow.width - width) / 2
        y: (mainWindow.height - height) / 2 *0.4

        Column {
            spacing: 10
            width: parent.width

            Text {
                text: "Enter quantity for " + contextMenu.itemName
                font.pixelSize: 14
                color: "black"
            }

            SpinBox {
                id: quantitySpinBox
                from: 1
                to: contextMenu.itemStock
                value: 1
            }
        }


        onAccepted: {
            var quantitySelected = quantitySpinBox.value;

            for (var i = 0; i < productModel.count; i++) {
                if (productModel.get(i).name === contextMenu.itemName) {
                    var newStock = Math.max(0, productModel.get(i).stock - quantitySelected);
                    productModel.setProperty(i, "stock", newStock); // Update stock dynamically

                    if (newStock === 0) {
                        productModel.remove(i); // 🔹 Remove item if stock is 0
                    }
                    break; // Move break here
                }
            }

            var orderItem = {
                "name": contextMenu.itemName,
                "price": contextMenu.itemPrice,
                "image": contextMenu.itemImage,
                "quantity": quantitySelected
            };

            if (contextMenu.actionType === "order") {
                orderManager.addPlacedOrder(orderItem);
            } else {
                cartManager.addCartItem(orderItem);
            }
        }

    }

}
