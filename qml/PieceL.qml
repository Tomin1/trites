/* 
    This file is part of Trites.
	Copyright (C) 2011 odamite <odamite@gmail.com>

    Trites is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Trites is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Trites.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
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