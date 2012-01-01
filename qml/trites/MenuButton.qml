import QtQuick 1.0

Image {
    width: 288
    height: 60
    source: mousearea.pressed ? "data/menubutton_pressed.svg" : "data/menubutton_unpressed.svg"

    property bool bPressed: false
    property string label: "Button"
    signal clicked

    Text {
        anchors.fill: parent
        text: parent.label
        font.pointSize: 24
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
