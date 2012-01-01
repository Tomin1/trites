import QtQuick 1.1
import "game.js" as Game

/* The I piece:
      XXXX     */
BasePiece {
    pSize: 4;
    pColor: "cyan"
    twoRotation: true
    collision: [
        "0000000011110000",
        "0010001000100010",
    ]
    startX: 3
    startY: -2

    Block
    {
        pX: 0
        pY: 2
        bColor: pColor;
    }

    Block
    {
        pX: 1
        pY: 2
        bColor: pColor;
    }

    Block
    {
        pX: 2
        pY: 2
        bColor: pColor;
    }

    Block
    {
        pX: 3
        pY: 2
        bColor: pColor;
    }
}
