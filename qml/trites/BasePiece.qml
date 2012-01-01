import QtQuick 1.1

/* This is base for all different pieces.
   It adds common properties and animations
   and makes code easier to read. */
Item {
    property real blockSize

    /* All the pieces are stored in a square */
    property int pSize;
    width: blockSize * pSize
    height: blockSize * pSize

    /* Stores data of the piece for collision detection.
       Includes piece form in 4/2 different rotations in 4/2 strings:
         0 = no block
         1 = block */
    property variant collision;

    /* Modify these properties instead of standard x, y and rotation */
    property int pX
    property int pY
    property int pRot
    property int pRotReal
    property string pColor

    property int startX
    property int startY

    property int animLength: 200

    /* Handle pieces position in grid (nicer code) */
    x: pX * blockSize
    y: pY * blockSize
    rotation: pRotReal * 90

    /* Pieces like Z, S and I have only 2 rotation states instead of 4 */
    property bool twoRotation: false

    /* Some nice animations */
    Behavior on rotation {
        NumberAnimation {
            duration: animLength
            easing.type: Easing.OutQuad
        }
    }

    /* No animation from (0,0) to initial position */
    property bool spawned: false
    Behavior on x {
        enabled: spawned
        NumberAnimation {
            duration: animLength
            easing.type: Easing.OutQuad
        }
    }

    Behavior on y {
        enabled: spawned
        NumberAnimation {
            duration: animLength
            easing.type: Easing.OutQuad
        }
    }
}
