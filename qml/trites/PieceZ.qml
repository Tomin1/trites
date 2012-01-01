import QtQuick 1.1
import "game.js" as Game

/* The Z piece:
      XX
       XX      */
BasePiece {
    pSize: 3;
    pColor: "red"
    twoRotation: true
    collision: [
        "000110011",
        "001011010"
    ]
    startX: 4
    startY: -1

    Block
    {
        pX: 0
        pY: 1
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
        pX: 1
        pY: 1
        bColor: pColor;
    }

    Block
    {
        pX: 2
        pY: 2
        bColor: pColor;
    }
}
