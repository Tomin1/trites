import QtQuick 1.1
import "game.js" as Game

/* The T piece:
      XXX
       X       */
BasePiece {
    pSize: 3
    pColor: "purple"
    collision: [
        "000111010",
        "010110010",
        "010111000",
        "010011010"
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
        pY: 1
        bColor: pColor;
    }
}
