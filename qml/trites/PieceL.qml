import QtQuick 1.1
import "game.js" as Game

/* The L piece:
      XXX
      X        */
BasePiece {
    pSize: 3;
    pColor: "orange"
    collision: [
        "000111100",
        "110010010",
        "001111000",
        "010010011"
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
        pX: 0
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
