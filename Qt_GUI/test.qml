import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    width: 1920
    height: 1280
    visible: true
    title: qsTr("STM IPC Task")

    Rectangle {
        id: topBanner
        width: parent.width
        height: parent.height * (1/13)
        color: "black"

        TextField{
            id: searchBar
            width: parent.width*0.4
            height: parent.height*0.6
            anchors.centerIn: parent
            placeholderText: "Search for clothes"
            color: "black"
            padding: {
                left:10
                right:10
            }

            background: Rectangle{
                color: "white"
                radius: 5
            }
        }

        Button {
            id: search
            width: searchBar.width / 15
            height: searchBar.height
            anchors.left: searchBar.right
            anchors.verticalCenter: searchBar.verticalCenter
            scale: mouseArea.pressed ? 1.1 : 1.0  // Increase size when pressed

            background: Rectangle {
                id: searchBg
                color: mouseArea.hovered ? "#fca450" : "#febd69"
                radius: 5
                anchors.fill: parent
            }

            icon.source: "qrc:/images/search.png"
            icon.width: width * 0.6
            icon.height: height * 0.6

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onPressed: search.scale = 1.1  // Scale up on press
                onReleased: search.scale = 1.0  // Scale back on release

                onEntered: searchBg.color = "#fca450"  // Hover color
                onExited: searchBg.color = "#febd69"  // Default color
            }

            Behavior on scale {
                NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
            }
        }

        Row {
            anchors.verticalCenter: searchBar.verticalCenter
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 15  // Space between buttons

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
                        // source: "qrc:/images/orders.png"
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
                    onClicked: console.log("Orders button clicked")
                }
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
                    onClicked: console.log("Cart button clicked")
                }
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

    Image {
        id: ramadanBanner
        source: "qrc:/images/RAM.jpg"
        width: parent.width
        height: parent.height/4
        anchors.top: topBanner.bottom
        anchors.margins: 10

    }


    GridView {
        id: productGrid
        width: parent.width
        height: parent.height - topBanner.height - ramadanBanner.height - 20
        anchors.top: ramadanBanner.bottom
        anchors.margins: 10
        cellWidth: width / 5
        cellHeight: cellWidth * 1.2
        clip: true  // ✅ Ensures items outside the GridView area are clipped


        model: ListModel { id: productModel }

        Component.onCompleted: {
            var items = databaseLoader.loadClothes();
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
                    text: model.price
                    font.pixelSize: 14
                    color: "green"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log(model.name + " clicked")
            }
        }
    }

}
