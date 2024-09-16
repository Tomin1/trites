/* 
    This file is part of Trites.
    Copyright (C) 2011 odamite <odamite@gmail.com>
    Copyright (C) 2024 tomin <code@tomin.site>

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

import Sailfish.Silica 1.0
import QtQuick 2.6

Image {
    width: window.scaledValue(288)
    height: window.scaledValue(60)
    source: mousearea.pressed ? "data/menubutton_pressed.svg" : "data/menubutton_unpressed.svg"

    property bool bPressed: false
    property string label: "Button"
    signal clicked

    Text {
        anchors.fill: parent
        text: parent.label
        font.pixelSize: window.scaledValue(24) * 1.5
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}