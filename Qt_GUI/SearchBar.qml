import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: searchContainer
    width: parent.width * 0.4
    height: parent.height * 0.6
    color: "transparent"


    TextField {
        id: searchBar
        width: parent.width
        height: parent.height
        placeholderText: "Search for clothes"
        color: "black"
        padding: {
            left: 10
            right: 10
        }

        background: Rectangle {
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
            onClicked: {
                console.log("Search button clicked and signal emmitted " + searchBar.text);
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
        }
    }
}
