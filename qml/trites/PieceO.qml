import QtQuick 1.1
import "game.js" as Game

/* The O piece:
      XX
      XX       */
BasePiece {
    pSize: 2;
    pColor: "yellow"
    collision: [
        "1111",
        "1111",
        "1111",
        "1111"
    ]
    startX: 4
    startY: 0

    Block
    {
        pX: 0
        pY: 0
        bColor: pColor;
    }

    Block
    {
        pX: 0
        pY: 1
        bColor: pColor;
    }

    Block
    {
        pX: 1
        pY: 0
        bColor: pColor;
    }

    Block
    {
        pX: 1
        pY: 1
        bColor: pColor;
    }
}
