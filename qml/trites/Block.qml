import QtQuick 1.1

/* Block element for moving and static pieces */
Item {
    property real blockSize: parent.blockSize ? parent.blockSize : 0;

    width: blockSize
    height: blockSize
    smooth: true

    property int pX
    property int pY
    x: pX * blockSize
    y: pY * blockSize

    /* TODO: make this rotation "smoother" */
    //rotation: parent.pRotReal * -90
    property string bColor: "cyan"
    property int moveDown: 0

    /* Awesome bounce animation when row removed =) */
    property bool spawned: false
    Behavior on y {
        enabled: spawned
        NumberAnimation {
            duration: 200
            easing.type: Easing.InQuad
        }
    }

    Image {
        source:  "data/block_" + parent.bColor + ".png"
        smooth: true
        anchors.fill: parent
    }

    /*Rectangle
    {
        color: parent.bColor;
        anchors.fill: parent
        opacity: 0.75
    }*/
}
