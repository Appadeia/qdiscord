import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: root
    color: hovering ? "#3c4247" : "#23272A"
    // border.color: "#141616"
    property alias text: label.text
    property bool hovering: false
    property bool lastSelected: false

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        color: "white"
        text: ". . ."
    }
    Image {
        visible: root.lastSelected
        source: "qrc:/comment-check.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
    }
}
