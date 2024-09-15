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

/* Block element for moving and static pieces */
Item {
    property real blockSize: parent.blockSize ? parent.blockSize : 0;

    width: blockSize
    height: blockSize
    smooth: true

    property int pX
    property int pY
    x: pX * blockSize
    y: pY * blockSize

    /* TODO: make this rotation "smoother" */
    //rotation: parent.pRotReal * -90
    property string bColor: "cyan"
    property int moveDown: 0

    /* Awesome bounce animation when row removed =) */
    property bool spawned: false
    Behavior on y {
        enabled: spawned
        NumberAnimation {
            duration: 200
            easing.type: Easing.InQuad
        }
    }

    Image {
        source:  "data/block_" + parent.bColor + ".png"
        smooth: true
        anchors.fill: parent
    }

    /*Rectangle
    {
        color: parent.bColor;
        anchors.fill: parent
        opacity: 0.75
    }*/
}
