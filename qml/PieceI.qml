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
