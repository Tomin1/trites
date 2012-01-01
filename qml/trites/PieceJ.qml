import QtQuick 1.1
import "game.js" as Game

/* The J piece:
      XXX
        X      */
BasePiece {
    pSize: 3;
    pColor: "blue"
    collision: [
        "000111001",
        "010010110",
        "100111000",
        "011010010"
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
        pX: 2
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
