import QtQuick 1.1
import "game.js" as Game

/* The S piece:
       XX
      XX      */
BasePiece {
    pSize: 3;
    pColor: "green"
    twoRotation: true
    collision: [
        "000011110",
        "010011001"
    ]
    startX: 4
    startY: -1

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
        pX: 1
        pY: 1
        bColor: pColor;
    }

    Block
    {
        pX: 2
        pY: 1
        bColor: pColor;
    }
}
