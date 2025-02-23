import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: restockPopup

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
            text: "Restock Item"
            font.bold: true
            font.pixelSize: 18
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Input field for Item Name
        TextField {
            id: itemNameField
            width: parent.width
            placeholderText: "Item Name"
            color: "white"
            font.pixelSize: 14
        }

        // Input field for Price
        TextField {
            id: priceField
            width: parent.width
            placeholderText: "Price"
            color: "white"
            font.pixelSize: 14
            validator: DoubleValidator { bottom: 0 } // Ensure the price is a positive number
        }

        // Input field for Quantity
        TextField {
            id: quantityField
            width: parent.width
            placeholderText: "Quantity"
            font.pixelSize: 14
            color: "white"
            validator: IntValidator { bottom: 1 } // Ensure the quantity is a positive integer
        }

        // Button to confirm restock
        Button {
            text: "Restock"
            width: parent.width
            height: 40
            font.pixelSize: 16
            onClicked: {
                var itemName = itemNameField.text;
                var price = parseFloat(priceField.text);
                var quantity = parseInt(quantityField.text);

                if (itemName === "" || isNaN(price) || isNaN(quantity)) {
                    console.log("Please fill in all fields correctly.");
                    return;
                }

                // Call the updateStock method
                var success = databaseLoader.updateStock(itemName, price, quantity);
                if (success) {
                    console.log("Stock updated successfully!");
                } else {
                    console.log("Failed to update stock.");
                }

                // Clear input fields and close the popup
                itemNameField.text = "";
                priceField.text = "";
                quantityField.text = "";
                restockPopup.close();
            }
        }
    }
}
